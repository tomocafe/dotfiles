###############################################################################
# Extensions
###############################################################################

function _join () {
    local IFS="$1"
    shift
    echo "$*"
}

###############################################################################
# Path manipulation
###############################################################################

function _inPath () {
    [[ $# -eq 1 ]] || return 2
    [[ ":${PATH}:" =~ ":${1}:" ]] && return 0
    return 1
}

function _prependPath () {
    local _paths=($@)
    local _sep=${PATH:+${_paths:+:}}
    local IFS=':'
    export PATH=${_paths[*]}${_sep}${PATH}
}

function _appendPath () {
    local _paths=($@)
    local _sep=${PATH:+${_paths:+:}}
    local IFS=':'
    export PATH=${PATH}${_sep}${_paths[*]}
}

function _prependPathUnique () {
    local _path
    for _path in $@; do
        _inPath $_path || _prependPath $_path
    done
}

function _appendPathUnique () {
    local _path
    for _path in $@; do
        _inPath $_path || _appendPath $_path
    done
}

function _removeFromPath () {
    local _path
    local _newpath
    for _path in $@; do
        _inPath $_path || continue
        _newpath=":${PATH}:"
        _newpath=${_newpath//:$_path:/:}
        _newpath=${_newpath#:}
        _newpath=${_newpath%:}
        export PATH="$_newpath"
    done
}

function _swapInPath () {
    [[ $# -eq 2 ]] || return
    _inPath $1 || return
    _inPath $2 || return
    _inPath "@SWAPPING@" && return # sentinel value
    local _newpath=":$PATH:"
    _newpath=${_newpath//:$1:/:@SWAPPING@:}
    _newpath=${_newpath//:$2:/:$1:}
    _newpath=${_newpath//:@SWAPPING@:/:$2:}
    _newpath=${_newpath#:}
    _newpath=${_newpath%:}
    export PATH="$_newpath"
}

function _inCdPath () {
    [[ $# -eq 1 ]] || return 2
    [[ ":${CDPATH}:" =~ ":${1}:" ]] && return 0
    return 1
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
# Process related
###############################################################################

function _getRootProcess () {
    local _pid=${1:-$$}
    while true; do
        local _stat=($(</proc/$_pid/stat))
        local _ppid=${_stat[3]}
        # Check if we found the root process
        if [[ $_ppid -eq 1 ]]; then
            echo $(ps -p $_pid -o comm=)
            break
        fi
        # Advance to parent
        _pid=${_stat[3]}
    done
}

###############################################################################
# Colors
###############################################################################

function _exportColorCodes () {
    # 16 colors
    COLORS=()
    local id
    for id in {0..15}; do
        ${COLORS[$id]}='$(tput setaf $id)'
    done
    # Special color codes
    export COLOR_RESET="$(tput sgr0)"
    export COLOR_TRESET="$(tput reset)"
    # Map xrdb global background to closest b/w 16-bit color codes
    if command -v xrdb &>/dev/null; then
        unset COLOR_FG_ID
        local line
        while read -r line; do
            if [[ $line =~ *background: ]]; then
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
                    export COLOR_FG_ID=0
                    export COLOR_FG_BOLD_ID=8
                    export COLOR_BG_ID=15
                    export COLOR_BG_BOLD_ID=7
                else
                    # Background mostly dark => white fg, black bg
                    export COLOR_FG_ID=7
                    export COLOR_FG_BOLD_ID=15
                    export COLOR_BG_ID=8
                    export COLOR_BG_BOLD_ID=0
                fi
            fi
            [[ -z $COLOR_FG_ID ]] || break 
        done < <(xrdb -query)
    fi
}

function _showColors () {
    local id=0
    local offset
    local fg=7
    while [[ $id -lt 8 ]]; do
        for offset in 0 8; do
            local col=$((id + offset))
            local hex=$(xrdb -query 2>/dev/null | grep "^*color$col:")
            hex=${hex##*#}
            printf "$(tput setaf $col)%3s$(tput sgr0) $(tput setab $col)$(tput setaf $fg)%3s$(tput sgr0) #%s\t" $col $col $hex
            fg=0
        done
        echo
        let id++
    done
    id=16
    local max=$(tput colors) 
    while [[ $id -lt $max ]]; do
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
    echo -ne "\033]0;$@\007"
}

function _setTerminalTab () {
    echo -ne "\033]30;$@\007"
}

###############################################################################
# Terminal related
###############################################################################

function _launchUrxvtDaemonized () {
    urxvtc &>/dev/null
    if [[ $? -eq 2 ]]; then
        # Need to start the daemon and then run the client
        urxvtd -q -o -f
        urxvtc &>/dev/null
    fi
}

function _forkUrxvtDaemonized () {
    (FORK_DIR=$PWD _launchUrxvtDaemonized &) # put it in a subshell to silence bash job control messages
}

###############################################################################
# Directory structure
###############################################################################



###############################################################################
# Path completion
###############################################################################



###############################################################################
# Platform checking
###############################################################################

