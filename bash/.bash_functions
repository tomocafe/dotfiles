# vim:ft=sh

###############################################################################
# Extensions
###############################################################################

function _join () {
    local IFS="$1"
    shift
    echo "$*"
}

function _hardCopy () {
    local f
    for f in $@; do
        f=${f%/}
        if [[ -L $f ]]; then
            local src=$(readlink -f $f)
            unlink $f && cp -r $src $f
        fi
    done
}

function _makeChangeDirectory () {
    # Pass in mkdir arguments and/or multiple directories, cd to the last directory given
    command mkdir $@ && command cd ${@: -1}
}

function _ext () {
    local op="$1"
    shift
    local re='^[a-zA-Z0-9_-]+$'
    case "$op" in
        push|add|change|mv)
            [[ $# -ge 1 ]] || return 1
            local x="$1"
            shift
            [[ "$x" =~ $re ]] || return 1
            ;;
    esac
    local rv=0
    local f dst
    for f in "$@"; do
        f="${f%/}"
        _checkWriteable "$f" || { let rv++; continue; }
        case "$op" in
            push|add)  dst="$f.$x" ;;
            change|mv) dst="${f%.*}.$x" ;;
            pop|rm)    dst="${f%.*}" ;;
        esac
        [[ "$dst" == "$f" ]] && continue
        _checkExists "$dst" && { let rv++; continue; }
        mv "$f" "$dst"
    done
    return $rv
}

###############################################################################
# Messaging
###############################################################################

function _putError () 
{
    echo -e "\e[31m└─ Error ──── \e[0m$@" 1>&2
}

function _putWarning () 
{
    echo -e "\e[91m└─ Warning ── \e[0m$@" 1>&2
}

function _putInfo () 
{
    echo -e "\e[36m└─ Info ───── \e[0m$@" 1>&2
}

###############################################################################
# Path manipulation
###############################################################################

# Base functions to manipulate colon-delimited lists

function _inPathBase () {
    [[ $# -eq 2 ]] || return 2
    eval [[ ":\${$1}:" =~ ":${2}:" ]] && return 0
    return 1
}

function _prependPathBase () {
    local _paths=("${@:2}")
    local IFS=':'
    eval export $1=\${_paths[*]}\${$1:+\${_paths:+:}}\${$1}
}

function _appendPathBase () {
    local _paths=("${@:2}")
    local IFS=':'
    eval export $1=\${$1}\${$1:+\${_paths:+:}}\${_paths[*]}
}

function _prependUniquePathBase () {
    local _path
    for _path in "${@:2}"; do
        _inPathBase "$1" "$_path" || _prependPathBase "$1" "$_path"
    done
}

function _appendUniquePathBase () {
    local _path
    for _path in "${@:2}"; do
        _inPathBase "$1" "$_path" || _appendPathBase "$1" "$_path"
    done
}

function _removeFromPathBase () {
    local _path
    local _newpath
    local _found=1
    for _path in "${@:2}"; do
        _inPathBase "$1" "$_path" || continue
        eval _newpath=":\${$1}:"
        _newpath="${_newpath//:$_path:/:}"
        _newpath="${_newpath#:}"
        _newpath="${_newpath%:}"
        eval export $1="$_newpath"
        _found=0
    done
    return $_found
}

function _swapInPathBase () {
    [[ $# -eq 3 ]] || return 2
    _inPathBase "$1" "$2" || return 1
    _inPathBase "$1" "$3" || return 1
    _inPathBase "$1" "@SWAPPING@" && return # sentinel value
    eval local _newpath=":\$$1:"
    _newpath="${_newpath//:$2:/:@SWAPPING@:}"
    _newpath="${_newpath//:$3:/:$2:}"
    _newpath="${_newpath//:@SWAPPING@:/:$3:}"
    _newpath="${_newpath#:}"
    _newpath="${_newpath%:}"
    eval export $1="$_newpath"
    return 0
}

function _printPathBase () {
    eval printf \"\${$1//:/$'\n'}$'\n'\"
}

# Instantiate functions for common colon-delimited lists, e.g. PATH
for _p in PATH LD_LIBRARY_PATH LD_PRELOAD_PATH CDPATH MANPATH; do
    _f=$(echo ${_p,,} | sed -r 's/(^|_)([a-z])/\U\2/g') # snake to pascal case
    _f=${_f//path/Path} # always capitalize path
    for _a in _in _prepend _prependUnique _append _appendUnique _removeFrom _swapIn _print; do
        eval "function ${_a}${_f} { ${_a}PathBase $_p \$@; }"
    done
done

###############################################################################
# Checking functions
###############################################################################

function _checkSet () {
    local v
    for v in $@; do
        eval test -z \${$v+x} && return 1 # unset
        eval test -z \${$v} && return 2 # set, but empty
    done
    return 0
}

function _checkCommand () {
    local cmd
    for cmd in $@; do
        command -v $cmd &>/dev/null || return 1
    done
    return 0
}

function _checkFileTypeBase () {
    local flag=$1
    shift
    local f
    for f in $@; do
        test -$flag $f || return 1
    done
    return 0
}

# Instantiate functions for common file type checks
for _t in r:Readable w:Writeable x:Executable e:Exists d:Directory L:Link; do
    eval "function _check${_t#*:} { _checkFileTypeBase ${_t%:*} \$@; }"
done

###############################################################################
# Process related
###############################################################################

function _getRootProcessBase () {
    local _output=$1; shift
    local _pid=${1:-$$}
    while true; do
        local _statfile=$(</proc/$_pid/stat)
        _statfile=${_statfile/(*)/x} # sanitize proc names with spaces, e.g. (tmux: server)
        local _stats=($_statfile)
        local _ppid=${_stats[3]}
        # Check if we found the root process
        if [[ $_ppid -eq 1 ]]; then
            echo $(ps -p $_pid -o $_output=)
            break
        fi
        # Advance to parent
        _pid=$_ppid
    done
}

function _getRootProcess () {
    _getRootProcessBase 'comm' $@
}

function _getRootProcessArgs () {
    _getRootProcessBase 'args' $@
}

function _matchProcessTree () {
    local _pattern=$1; shift
    local _pid=${1:-$$}
    while true; do
        # Check if processes up the tree match pattern
        [[ $(ps -p $_pid -o args=) =~ $_pattern ]] && return 0
        local _statfile=$(</proc/$_pid/stat)
        _statfile=${_statfile/(*)/x} # sanitize proc names with spaces, e.g. (tmux: server)
        local _stats=($_statfile)
        local _ppid=${_stats[3]}
        [[ $_ppid -eq 1 ]] && break
        # Advance to parent
        _pid=$_ppid
    done
    return 1
}

function _writeShellRootProcXProp () {
    if [[ $- == *i* ]] && _checkCommand xprop && _checkSet DISPLAY; then
        # Get the current active window ID
        wid=$(xprop -root _NET_ACTIVE_WINDOW); wid=${wid##* }
        xprop -id $wid -f SHELL_ROOT_PROC 8s -set SHELL_ROOT_PROC $(_getRootProcess $1) &>/dev/null
    fi
}

###############################################################################
# Colors
###############################################################################

function _exportColorCodes () {
    # 16 colors
    COLORS=()
    local id
    for id in {0..15}; do
        COLORS+=("$(tput setaf $id)")
    done
    # Special color codes
    export COLOR_RESET="$(tput sgr0)"
    export COLOR_TRESET="$(tput reset)"
    # Map xrdb global background to closest b/w 16-bit color codes
    if command -v xrdb &>/dev/null; then
        local line
        while read -r line; do
            if [[ $line =~ \*background: ]]; then
                local code=${line##*#}
                local r="0x${code:0:2}"
                local g="0x${code:2:2}"
                local b="0x${code:4:2}"
                local i
                local ct=0
                for i in $r $g $b; do
                    [[ $i -ge 0x7f ]] && let ct++
                done
                if [[ $ct -ge 2 ]]; then
                    # Background mostly light => black fg, white bg
                    COLOR_BG_DIM=15
                    COLOR_FG_DIM=7
                    COLOR_FG_BRIGHT=8
                    COLOR_FG_BRIGHTER=0
                else
                    # Background mostly dark => white fg, black bg
                    COLOR_BG_DIM=0
                    COLOR_FG_DIM=8
                    COLOR_FG_BRIGHT=7
                    COLOR_FG_BRIGHTER=15
                fi
                break
            fi
        done < <(xrdb -query 2>/dev/null)
    fi
    # Set sensible defaults for dark background
    export COLOR_BG_DIM=${COLOR_BG_DIM:-0}
    export COLOR_FG_DIM=${COLOR_FG_DIM:-8}
    export COLOR_FG_BRIGHT=${COLOR_FG_BRIGHT:-7}
    export COLOR_FG_BRIGHTER=${COLOR_FG_BRIGHTER:-15}
}

function _showColors () {
    local max=${1:-256}
    local id=0
    local offset
    local fg=7
    while [[ $id -lt 8 ]]; do
        for offset in 0 8; do
            local col=$((id + offset))
            local hex=$(xrdb -query 2>/dev/null | grep "^*color$col:")
            hex=${hex##*#}
            printf "$(tput setaf $col)%3s$(tput sgr0) $(tput setab $col)$(tput setaf $fg)%3s$(tput sgr0) %s%6s\t" $col $col ${hex:+#} $hex
            fg=0
        done
        echo
        let id++
    done
    id=16
    local tmax=$(tput colors)
    while [[ $id -lt $max ]] && [[ $id -lt $tmax ]]; do
        printf "$(tput setaf $id)%3s$(tput sgr0) " $id
        let id++
        [[ $((id % 8)) -eq 0 ]] && echo
    done
    echo
}

###############################################################################
# Prompts and titles
###############################################################################

function _setTerminalTitle () {
    echo -ne "\033]0;${TERMINAL_LABEL}$@\007"
}

function _setTerminalTab () {
    echo -ne "\033]30;${TERMINAL_LABEL}$@\007"
}

function _setTerminalLabel () {
    export TERMINAL_LABEL="$@"
}

function _genPromptP4Status () {
    [[ -n $P4CLIENT ]] || return
    local status="$P4CLIENT"
    if ! _checkCommand p4 || _checkSet P4_NOT_CONNECTED; then
        echo "$status"
        return
    fi
    declare -A openFileCtPerChangelist
    local line
    while read -r line; do
        ((openFileCtPerChangelist[$line]++))
    done < <(p4 -ztag -F %change% opened -C $P4CLIENT)
    local clientOpts=$(p4 -ztag -F %Options% client -o $P4CLIENT)
    clientOpts=":${clientOpts// /:}:"
    if [[ $clientOpts =~ :locked: ]]; then
        status+="*"
    fi
    # Show open file count in default changelist first
    if [[ ${openFileCtPerChangelist[default]+x} ]]; then
        status+=" (${openFileCtPerChangelist[default]})"
    fi
    # Then show any non-default changelists
    local cl
    for cl in ${!openFileCtPerChangelist[@]}; do
        [[ $cl == 'default' ]] && continue
        status+=" (@$cl ${openFileCtPerChangelist[$cl]})"
    done
    echo "$status"
}

function _genPromptGitStatus () {
    if ! git status -s &>/dev/null; then
        # We are not in a git repository
        return
    fi
    # Count the number of changed/untracked/conflict/staged files
    local line
    local changedCt=0
    local untrackedCt=0
    local conflictCt=0
    local stagedCt=0
    while read -r line; do
        case "${line:0:2}" in
            *M*)   let changedCt++ ;;
            *U*)   let conflictCt++ ;;
            \?\?)  let untrackedCt++ ;;
            *)     let stagedCt++ ;;
        esac
    done < <(LC_ALL=C git status --untracked-files=all --porcelain)
    uncleanFileStats=()
    [[ $changedCt -gt 0 ]] && uncleanFileStats+=("M:$changedCt")
    [[ $conflictCt -gt 0 ]] && uncleanFileStats+=("U:$conflictCt")
    [[ $untrackedCt -gt 0 ]] && uncleanFileStats+=("?:$untrackedCt")
    [[ $stagedCt -gt 0 ]] && uncleanFileStats+=("*:$stagedCt")
    # Use remote origin URL to determine repo name, otherwise use top level directory name
    local remoteOriginUrl=$(git config --get remote.origin.url 2>/dev/null)
    case "$remoteOriginUrl" in
        *.com/*) repoName=${remoteOriginUrl##*.com/} ;;
        *.org/*) repoName=${remoteOriginUrl##*.org/} ;;
        *.edu/*) repoName=${remoteOriginUrl##*.edu/} ;;
        *.net/*) repoName=${remoteOriginUrl##*.net/} ;;
        *.io/*)  repoName=${remoteOriginUrl##*.io/}  ;;
        *)
            repoName=$(git rev-parse --show-toplevel)
            repoName=${repoName##*/}
            ;;
    esac
    repoName=${repoName%.git}
    # Determine the current branch
    branch=$(git symbolic-ref -q HEAD)
    branch=${branch#refs/heads/}
    echo "$repoName${branch:+ $branch}${uncleanFileStats:+ (${uncleanFileStats[@]})}"
}

function _genPromptVirtualEnvStatus () {
    _checkSet VIRTUAL_ENV || return
    echo "${VIRTUAL_ENV##*/}"
}

function _genPromptJobCt () {
    local ct=0
    local line
    while read -r line; do
        let ct++
    done < <(jobs)
    [[ $ct -gt 0 ]] && echo "{$ct}"
}

function _setPrompt () {
    # Save the return code from the previous command first!
    local rc=$?
    # Calculate number of bg jobs here (before spawning anything)
    jobct="$(_genPromptJobCt)"
    # Update X window property
    ( _writeShellRootProcXProp $$ & ) # move to background subshell for speed
    # Make sure colors are exported (caching saves time compared to many tput calls)
    [[ ${#COLORS[@]} -gt 0 ]] || _exportColorCodes
    # Storage
    local sep=' '
    local blockText=()
    local blockColor=()
    local block
    # Header
    blockText+=('┌─ ')
    [[ $rc -eq 0 ]] && blockColor+=(${COLORS[10]}) || blockColor+=(${COLORS[1]}) # bright green if last command successful, red otherwise
    # Hostname
    blockText+=("${HOSTNAME%%.*}") # strip domain if present
    local rootProc=$(_getRootProcess)
    case $rootProc in
        # Color hostname differently if root process is a connection daemon (e.g. sshd)
        # This is a warning that closing the terminal will close a connection 
        sshd|sge_execd)
            blockColor+=(${COLORS[9]}) # orange (bright red)
            ;;
        *)
            blockColor+=(${COLORS[3]}) # yellow
            ;;
    esac
    # TTY
    local tty=$(tty)
    blockText+=(':')
    blockColor+=(${COLOR_RESET})
    blockText+=("${tty##*/}")
    blockColor+=(${COLORS[4]}) # blue
    # P4/git status
    # Precedence: if cwd is part of a git repository, use git status; else use P4 status based on environment variables
    block=$(_genPromptGitStatus)
    if [[ -n $block ]]; then
        blockText+=("$sep")
        blockColor+=(${COLOR_RESET})
        blockText+=("$block")
        blockColor+=(${COLORS[5]}) # magenta
    else
        block=$(_genPromptP4Status)
        if [[ -n $block ]]; then
            blockText+=("$sep")
            blockColor+=(${COLOR_RESET})
            blockText+=("$block")
            if ! _checkCommand p4 || _checkSet P4_NOT_CONNECTED; then
                blockColor+=(${COLORS[1]}) # red
            else
                blockColor+=(${COLORS[5]}) # magenta
            fi
        fi
    fi
    # Python virtualenv status
    block=$(_genPromptVirtualEnvStatus)
    if [[ -n $block ]]; then
        blockText+=("$sep")
        blockColor+=(${COLOR_RESET})
        blockText+=("$block")
        blockColor+=(${COLORS[6]}) # cyan
    fi
    local lastTitleBlockIndex=${#blockText[@]} # for setting title/tab, stop printing here
    # Background job count
    block="$jobct"
    if [[ -n $block ]]; then
        blockText+=("$sep")
        blockColor+=(${COLOR_RESET})
        blockText+=("$block")
        blockColor+=(${COLORS[$COLOR_BG_DIM]})
    fi
    # Set up right justification
    local lhsCharCt=0
    for block in "${blockText[@]}"; do
        let lhsCharCt+=${#block}
    done
    # Current working directory (right justified)
    local _pwd=${PWD/#$HOME/\~}
    local dirpath="${_pwd%/*}/"
    local dirname="${_pwd##*/}"
    [[ $dirname == '~' ]] && dirpath=''
    if [[ $((lhsCharCt + ${#dirpath} + ${#dirname} + 2)) -ge $COLUMNS ]]; then # offset +2 for parentheses
        # If the full path is too long, use only the directory name
        dirpath=''
    fi
    local cenCharCt=$((COLUMNS - lhsCharCt - ${#dirpath} - ${#dirname} - 2)) # offset -2 for parentheses
    [[ $cenCharCt -lt 1 ]] && cenCharCt=1
    local cenText=$(printf "%${cenCharCt}s" "")
    blockText+=("$cenText")
    blockColor+=(${COLOR_RESET})
    blockText+=('(')
    blockColor+=(${COLOR_RESET})
    if [[ -n "$dirpath" ]]; then
        blockText+=("$dirpath")
        blockColor+=(${COLOR_RESET})
    fi
    blockText+=("$dirname")
    blockColor+=(${COLORS[$COLOR_FG_BRIGHTER]})
    blockText+=(')')
    blockColor+=(${COLOR_RESET})
    # Set status line
    local i=0
    PS1="\r"
    local titleText=""
    while [[ $i -lt ${#blockText[@]} ]]; do
        PS1+="\[${blockColor[$i]}\]${blockText[$i]}"
        [[ $i -gt 0 && $i -lt $lastTitleBlockIndex ]] && titleText+="${blockText[$i]}" # skip header
        let i++
    done
    titleText+=" ($rootProc)"
    # Set prompt
    PS1+="\n\[${blockColor[0]}\]\$\[${COLOR_RESET}\] "
    export PS1
    # Set the terminal title/tab
    _setTerminalTitle "$titleText"
    #_setTerminalTab "$titleText"
}

function _setFastPrompt () {
    unset PROMPT_COMMAND
    shopt -u checkwinsize
    export PROMPT_DIRTRIM=4
    export PS1="\r\[${COLORS[$COLOR_FG_DIM]}\]┌─ \[${COLORS[3]}\]\h\[${COLOR_RESET}\]:\[${COLORS[4]}\]\l\[${COLOR_RESET}\] (\w)\n\[${COLORS[$COLOR_FG_DIM]}\]\$\[${COLOR_RESET}\] "
}

###############################################################################
# Terminal related
###############################################################################

function _fork () {
    _checkSet TERMINAL || return 1
    (FORK_DIR=$PWD $TERMINAL $FORK_TERMINAL_OPTS $@ &>/dev/null &) # put in a subshell to silence bash job control messages
}

###############################################################################
# Completion
###############################################################################

function _dcBackwardsPathCompletion () {
    # Note: must be used with complete -o nospace
    # $1=cmd $2=cur $3=pre
    local cwd="${2:-$PWD}"
    local upd="${cwd%/*}"
    if [[ $cwd == '/' ]]; then
        return
    elif [[ $upd == '' ]]; then
        COMPREPLY=('/')
    else
        COMPREPLY=("$upd")
    fi
}

###############################################################################
# Utilities
###############################################################################

function _history () {
    # Invoke standard history command if piping/redirecting
    if [[ ! -t 1 ]]; then
        command history $@
        return $?
    fi
    # Make sure colors are exported (caching saves time compared to many tput calls)
    [[ ${#COLORS[@]} -gt 0 ]] || _exportColorCodes
    local reset='\033[m' # COLOR_RESET/TRESET (tput sgr0/reset) are not handled well by less, just hardcode this sequence
    # Run the following in a subshell to avoid leaking HISTTIMEFORMAT
    (
        export HISTTIMEFORMAT="${HISTTIMEFORMAT:-[%D %T]  }"
        local line
        while IFS= read -r line; do
            if [[ $line =~ ^([[:space:]]*)([[:digit:]]+)\ \ (\[.*?\])\ \ (.*)$ ]]; then
                echo -e "${BASH_REMATCH[1]}${COLORS[6]}${BASH_REMATCH[2]}${reset}  ${COLORS[4]}${BASH_REMATCH[3]}${reset}  ${BASH_REMATCH[4]}";
            else
                echo "$line";
            fi
        done < <(history) | less -SFXRM +G
    )
}

function _archiveHandlerBase () {
    # Compress: $0 true  archive.extension <files>
    # Extract:  $0 false archive.extension
    [[ $# -ge 2 ]] || return 2
    local _compress=$1
    shift
    case ${1,,} in
        *.tar.gz|*.tgz) $_compress && tar czvf $@ || tar xzvf $@ ;;
        *.tar.bz2|*.tbz2) $_compress && tar cjvf $@ || tar xjvf $@ ;;
        *.tar.xz|*.txz) $_compress && tar cJvf $@ || tar xJvf $@ ;;
        *.tar) $_compress && tar cvf $@ || tar xvf $@ ;;
        *.gz) $_compress && gzip <$2 >$1 || gunzip $@ ;;
        *.bz2) $_compress && bzip2 <$2 >$1 || bunzip2 $@ ;;
        *.xz) $_compress && xz <$2 >$1 || unxz $@ ;;
        *.lzh|*.lha) $_compress && lha c $@ || lha x $@ ;;
        *.zip) $_compress && zip $@ || unzip $@ ;;
        *.Z) $_compress && command compress <$2 >$1 || command uncompress $@ ;;
        *.7z) $_compress && 7z a $@ || 7z x $@ ;;
        *) _putError "unknown archive format"; return 1 ;;
    esac
}

function _compress () {
    _archiveHandlerBase true $@
}

function _extract () {
    _archiveHandlerBase false $@
}

