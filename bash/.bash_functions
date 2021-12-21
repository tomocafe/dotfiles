# vim:ft=sh

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
    _getRootProcessBase 'comm' "$@"
}

function _getRootProcessArgs () {
    _getRootProcessBase 'args' "$@"
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

###############################################################################
# Colors
###############################################################################

function _analyzeColors () {
    # Set sensible defaults for dark background
    export COLOR_BG_DIM_ID=0
    export COLOR_FG_DIM_ID=8
    export COLOR_FG_BRIGHT_ID=7
    export COLOR_FG_BRIGHTER_ID=15
    export COLOR_BG_DIM=black
    export COLOR_FG_DIM=gray
    export COLOR_FG_BRIGHT=white
    export COLOR_FG_BRIGHTER=bright_white
    bb_iscmd xrdb || return
    # Map xrdb global background to closest b/w 16-bit color codes
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
                export COLOR_BG_DIM_ID=15
                export COLOR_FG_DIM_ID=8
                export COLOR_FG_BRIGHT_ID=8
                export COLOR_FG_BRIGHTER_ID=0
                export COLOR_BG_DIM=bright_white
                export COLOR_FG_DIM=white
                export COLOR_FG_BRIGHT=gray
                export COLOR_FG_BRIGHTER=black
            else
                # Background mostly dark => white fg, black bg
                : # Keep defaults
            fi
            break
        fi
    done < <(xrdb -query 2>/dev/null)
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

function _promptSpaceSep () { printf ' '; }

function _promptHeader () {
    local color
    [[ $BB_PROMPT_LASTRC -eq 0 ]] && color="green" || color="bright_red"
    bb_promptcolor "$color"  '┌─'
    echo -n " "
}

function _promptHost () {
    local color
    case "$SHELL_ROOT_PROC" in
        # Color hostname differently if root process is a connection daemon (e.g. sshd)
        # This is a warning that closing the terminal will close a connection 
        sshd|sge_execd)
            color="bright_red"
            ;;
        *)
            color="yellow"
            ;;
    esac
    bb_promptcolor "$color" "${HOSTNAME%%.*}" # strip domain if present
    bb_checkset TTY_NUM || return
    echo -n ":"
    bb_promptcolor "blue" "$TTY_NUM"
}

function _promptGit () {
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
        *.com[/:]*) repoName=${remoteOriginUrl##*.com[/:]} ;;
        *.org[/:]*) repoName=${remoteOriginUrl##*.org[/:]} ;;
        *.edu[/:]*) repoName=${remoteOriginUrl##*.edu[/:]} ;;
        *.net[/:]*) repoName=${remoteOriginUrl##*.net[/:]} ;;
        *.io[/:]*)  repoName=${remoteOriginUrl##*.io[/:]}  ;;
        *)
            repoName=$(git rev-parse --show-toplevel)
            repoName=${repoName##*/}
            ;;
    esac
    repoName=${repoName%.git}
    # Determine the current branch
    local branch=$(git symbolic-ref -q HEAD)
    branch=${branch#refs/heads/}
    echo -n " "
    local statline="$repoName${branch:+ $branch}${uncleanFileStats:+ (${uncleanFileStats[@]})}"
    bb_promptcolor "magenta" "$statline"
}

function _promptP4 () {
    [[ -n $P4CLIENT ]] || return
    local statline="$P4CLIENT"
    if ! _checkCommand p4 || _checkSet P4_NOT_CONNECTED; then
        echo -n " "
        bb_promptcolor "red" "$statline"
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
        statline+="*"
    fi
    # Show open file count in default changelist first
    if [[ ${openFileCtPerChangelist[default]+x} ]]; then
        statline+=" (${openFileCtPerChangelist[default]})"
    fi
    # Then show any non-default changelists
    local cl
    for cl in ${!openFileCtPerChangelist[@]}; do
        [[ $cl == 'default' ]] && continue
        statline+=" (@$cl ${openFileCtPerChangelist[$cl]})"
    done
    unset openFileCtPerChangelist
    echo -n " "
    bb_promptcolor "magenta" "$statline"
}

function _promptVenv () {
    bb_checkset VIRTUAL_ENV || return
    echo -n " "
    bb_promptcolor "cyan" "${VIRTUAL_ENV##*/}"
}

function _promptJobs () {
    local jobct
    local line
    jobct=0
    while read -r line; do
        let jobct++
    done < <(jobs)
    [[ $jobct -gt 0 ]] || return
    echo -n " "
    bb_promptcolor "$COLOR_BG_DIM" "{$jobct}"
}

function _promptHist () {
    bb_promptcolor "$COLOR_BG_DIM" "[$HISTCMD]"
}

function _promptDirpath () {
    local _pwd="${PWD/#$HOME/$'~'}"
    local dirpath="${_pwd%/*}/"
    local dirname="${_pwd##*/}"
    [[ $dirname == '~' ]] && return
    local width=$(( ${#dirpath} + ${#dirname} ))
    [[ $width -ge $BB_PROMPT_REM ]] && return
    echo -e "$dirpath"
}

function _promptDirname () {
    local _pwd="${PWD/#$HOME/$'~'}"
    local dirname="${_pwd##*/}"
    bb_promptcolor "$COLOR_FG_BRIGHTER" "$dirname"
}

function _promptChar () {
    local color
    [[ $BB_PROMPT_LASTRC -eq 0 ]] && color="green" || color="bright_red"
    local prompt
    [[ $EUID -eq 0 ]] && prompt='#' || prompt='$'
    bb_promptcolor "$color" "$prompt"
    echo -n " "
}

function _promptWintitle () {
    echo -e "${HOSTNAME}:${TTY_NUM}${SHELL_ROOT_PROC:+ ($SHELL_ROOT_PROC)}"
}

###############################################################################
# Miscellaneous utilities
###############################################################################

function _isDirectoryEmpty ()
{
    local inodes="$(du --inodes -s "$1" 2>/dev/null)"
    [[ "${inodes%%$'\t'*}" -le 1 ]]
}

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

function _sms () {
    _checkCommand sendmail || return
    if ! _checkSet SMS_GATEWAY; then
        _putError "\$SMS_GATEWAY undefined: <number>@<carrier gateway domain>"
        return
    fi
    sendmail "$SMS_GATEWAY" <<EOF
subject: $HOSTNAME
$*
EOF
}

function _urlEncode () {
    python3 -c 'import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1], sys.argv[2], sys.argv[3]))' "$1" "$2" "${3:-utf-8}"
}

function _urlDecode () {
    python3 -c 'import urllib.parse, sys; print(urllib.parse.unquote(sys.argv[1], sys.argv[2]))' "$1" "${2:-utf-8}"
}

