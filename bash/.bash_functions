# vim:ft=sh

###############################################################################
# Process related
###############################################################################

function _getRootProcessBase () {
    local _output="$1"; shift
    local _pid="${1:-$$}"
    while true; do
        local _statfile="$(</proc/$_pid/stat)"
        _statfile="${_statfile/(*)/x}" # sanitize proc names with spaces, e.g. (tmux: server)
        local _stats=( $_statfile )
        local _ppid="${_stats[3]}"
        # Check if we found the root process
        if [[ $_ppid -eq 1 ]]; then
            echo "$(ps -p $_pid -o $_output=)"
            break
        fi
        # Advance to parent
        _pid="$_ppid"
    done
}

function _getRootProcess () {
    _getRootProcessBase 'comm' "$@"
}

function _getRootProcessArgs () {
    _getRootProcessBase 'args' "$@"
}

function _matchProcessTree () {
    local _pattern="$1"; shift
    local _pid="${1:-$$}"
    while true; do
        # Check if processes up the tree match pattern
        [[ $(ps -p $_pid -o args=) =~ $_pattern ]] && return $__bb_true
        local _statfile="$(</proc/$_pid/stat)"
        _statfile="${_statfile/(*)/x}" # sanitize proc names with spaces, e.g. (tmux: server)
        local _stats=( $_statfile )
        local _ppid="${_stats[3]}"
        [[ $_ppid -eq 1 ]] && break
        # Advance to parent
        _pid="$_ppid"
    done
    return $__bb_false
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
            local code="${line##*#}"
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

###############################################################################
# Prompts and titles
###############################################################################

function _promptLeft () {
    local color
    # Count background jobs at the start of the function
    # in case this function spawns background jobs (e.g., git status)
    local jobct=0
    local line
    while read -r line; do
        let jobct++
    done < <(jobs)
    # Header
    [[ $BB_PROMPT_LASTRC -eq 0 ]] && color="green" || color="bright_red"
    bb_promptcolor "$color"  '┌─'
    echo -n " "
    # Host and TTY
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
    if bb_checkset TTY_NUM; then
        echo -n ":"
        bb_promptcolor "blue" "$TTY_NUM"
    fi
    # Git, Perforce stats
    # Only print Perforce stats if not in a git repository
    _promptGit || _promptP4
    # Python virtualenv
    if bb_checkset VIRTUAL_ENV; then
        echo -n " "
        bb_promptcolor "cyan" "${VIRTUAL_ENV##*/}"
    fi
    # Background jobs
    if [[ $jobct -gt 0 ]]; then
        echo -n " "
        bb_promptcolor "$COLOR_BG_DIM" "{$jobct}"
    fi
}

function _fastGitDetect () {
    local here="${1:-$PWD}"
    here="$(readlink -f "$here")" # in case of symlink crossing filesystem boundary
    while : ; do
        [[ -d "$here/.git" ]] && return $__bb_true
        here="${here%/*}"
        [[ $here == "/" || $here == "" ]] && break
    done
    return $__bb_false
}

function _promptGit () {
    local status
    unset git
    timeout ${GIT_PROMPT_STATUS_FAST_TIMEOUT:-0.4s} git status -s &>/dev/null; status=$?
    if [[ $status -eq 124 ]]; then # timed out, use fallback method; see timeout --help for magic number 124
        if ! _fastGitDetect; then
            # We are not in a git repository
            return $__bb_false
        fi
    elif [[ $status -ne 0 ]]; then
        return $__bb_false # got non-zero from git status and it didn't timeout
    fi
    # Count the number of changed/untracked/conflict/staged files
    local line
    local changedCt=0
    local untrackedCt=0
    local conflictCt=0
    local stagedCt=0
    uncleanFileStats=()
    while read -r line; do
        case "${line:0:2}" in
            *M*)   let changedCt++ ;;
            *U*)   let conflictCt++ ;;
            \?\?)  let untrackedCt++ ;;
            *)     let stagedCt++ ;;
        esac
    done < <(LC_ALL=C timeout ${GIT_PROMPT_STATUS_TIMEOUT:-1s} git status --untracked-files=all --porcelain)
    [[ $changedCt -gt 0 ]] && uncleanFileStats+=("M:$changedCt")
    [[ $conflictCt -gt 0 ]] && uncleanFileStats+=("U:$conflictCt")
    [[ $untrackedCt -gt 0 ]] && uncleanFileStats+=("?:$untrackedCt")
    [[ $stagedCt -gt 0 ]] && uncleanFileStats+=("*:$stagedCt")
    # Use remote origin URL to determine repo name, otherwise use top level directory name
    local remoteOriginUrl=$(git config --get remote.origin.url 2>/dev/null)
    local repoName
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
    unset uncleanFileStats
    return $__bb_true
}

function _promptP4 () {
    [[ -n $P4CLIENT ]] || return $__bb_false
    local statline="$P4CLIENT"
    if ! bb_iscmd p4 || bb_checkset P4_NOT_CONNECTED; then
        echo -n " "
        bb_promptcolor "red" "$statline"
        return $__bb_true
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
    return $__bb_true
}

function _promptHist () {
    bb_promptcolor "$COLOR_BG_DIM" "[$HISTCMD]"
    echo -n " "
}

function _promptBookmark () {
    local mark
    bb_getbookmark -v mark
    bb_checkset mark || return
    bb_promptcolor "cyan" "$mark:"
    echo -n " "
}

function _promptFilesystem () {
    local fstype
    fstype="$(stat -f -c %T "$PWD" 2>/dev/null)"
    case "$fstype" in
        v9fs)
            bb_promptcolor "red" "[$fstype]"
            ;;
        *)
            ;;
    esac
    echo -n " "
}

function _promptRight () {
    # Current directory
    local pwd="${PWD/#$HOME/$'~'}"
    local dirpath="${pwd%/*}/"
    local dirname="${pwd##*/}"
    local width=$(( ${#dirpath} + ${#dirname} ))
    if [[ $dirname != '~' && $width -lt $BB_PROMPT_REM ]]; then
        echo -n "$dirpath"
    fi
    bb_promptcolor "$COLOR_FG_BRIGHTER" "$dirname"
}

function _promptNextLine () {
    local color
    [[ $BB_PROMPT_LASTRC -eq 0 ]] && color="green" || color="bright_red"
    local prompt
    [[ $EUID -eq 0 ]] && prompt='#' || prompt='$'
    bb_promptcolor "$color" "$prompt"
    echo -n " "
}

function _promptWintitle () {
    echo -e "${HOSTNAME}:${TTY_NUM}${SHELL_ROOT_PROC_DESC:+ ($SHELL_ROOT_PROC_DESC)}"
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
    # Run the following in a subshell to avoid leaking HISTTIMEFORMAT
    (
        export HISTTIMEFORMAT="${HISTTIMEFORMAT:-[%D %T]  }"
        local line
        while IFS= read -r line; do
            if [[ $line =~ ^([[:space:]]*)([[:digit:]]+)\ \ (\[.*?\])\ \ (.*)$ ]]; then
                bb_rawcolor "cyan"  "${BASH_REMATCH[1]}"
                bb_rawcolor "green" "${BASH_REMATCH[2]}"
                echo -n "  "
                bb_rawcolor "blue"  "${BASH_REMATCH[3]}"
                echo "  ${BASH_REMATCH[4]}"
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
    local c="$1"
    shift
    case "${1,,}" in
        *.tar.gz|*.tgz)   $c && tar czvf "$@" || tar xzvf "$@" ;;
        *.tar.bz2|*.tbz2) $c && tar cjvf "$@" || tar xjvf "$@" ;;
        *.tar.xz|*.txz)   $c && tar cJvf "$@" || tar xJvf "$@" ;;
        *.tar)            $c && tar cvf "$@" || tar xvf "$@" ;;
        *.gz)             $c && gzip <"$2" >"$1" || gunzip "$@" ;;
        *.bz2)            $c && bzip2 <"$2" >"$1" || bunzip2 "$@" ;;
        *.xz)             $c && xz <"$2" >"$1" || unxz "$@" ;;
        *.lzh|*.lha)      $c && lha c "$@" || lha x "$@" ;;
        *.zip)            $c && zip "$@" || unzip "$@" ;;
        *.Z)              $c && command compress <"$2" >"$1" || command uncompress "$@" ;;
        *.7z)             $c && 7z a "$@" || 7z x "$@" ;;
        *) bb_error "unknown archive format"; return 1 ;;
    esac
}

function _compress () {
    _archiveHandlerBase true "$@"
}

function _extract () {
    _archiveHandlerBase false "$@"
}

function _sms () {
    bb_iscmd sendmail || return $__bb_false
    if ! bb_checkset SMS_GATEWAY; then
        bb_error "\$SMS_GATEWAY undefined: <number>@<carrier gateway domain>"
        return $__bb_false
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

