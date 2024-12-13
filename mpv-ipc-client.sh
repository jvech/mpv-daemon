#!/usr/bin/sh
TEMP=$(getopt -o 'hs:' -l "help,socket:" -- "$@")

if [ $? -ne 0 ]; then
    echo 'Terminating...' >&2
    exit 1
fi

eval set -- "$TEMP"
unset TEMP

SOCKET_FILE="/tmp/mpv-audio-server-$USER.socket"
usage() {
    echo "Usage: $(basename $0) [-h] [-s SOCKET] <cmd> [ARGS...]"
    echo "Options:"
    echo "  -h, --help              Show this message"
    echo "  -s, --socket=SOCKET     Point to socket file [default: $SOCKET_FILE]"
    exit $1
}

while true; do
    case "$1" in
        '-h'|'--help')
            usage 0
            break
            ;;
        '-s'|'--socket')
            SOCKET_FILE=$2
            shift 2
            break
            ;;
        '--')
            shift
            break
            ;;
        *)
            usage 1
            break
            ;;
    esac
done

if [ $# -eq 0 ]; then
    usage 1
fi

cmd="$1"
case $cmd in
    "loadfile")
        query="$(echo $2 | tr ' ' +)"
        ipc_cmd='{ "command": ['
        ipc_cmd="$ipc_cmd\"$cmd\", \"ytdl://ytsearch:$query\""
        shift 2
        for arg in $@; do
            ipc_cmd="$ipc_cmd, \"$arg\""
        done
        ipc_cmd="$ipc_cmd] }"
        echo $ipc_cmd | socat - $SOCKET_FILE
        exit 0
        ;;
    *)
        ipc_cmd='{ "command": ['
        ipc_cmd="$ipc_cmd\"$cmd\""
        shift 1
        for arg in $@; do
            case $arg in
                true|false|[0-9]+|[0-9]*.[0-9]+)
                    ipc_cmd="$ipc_cmd, $arg"
                    ;;
                *)
                    ipc_cmd="$ipc_cmd, \"$arg\""
                    ;;
            esac
        done
        ipc_cmd="$ipc_cmd] }"
        echo $ipc_cmd | socat - $SOCKET_FILE
        exit 0
        ;;
esac
W_MENU_LINES=10
