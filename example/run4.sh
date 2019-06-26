#!/bin/bash
set -euo pipefail

dyn-fuzz() {
    tmux new -s PAFL -d

    tmux send -t "PAFL" "$AFL_PREFIX/afl-fuzz -i in -o out -m 20981520 -t 1000  -M master -N 4 -I 0 $@" Enter

    tmux split-window -h -t "PAFL"
    tmux send -t "PAFL" "$AFL_PREFIX/afl-fuzz -i in -o out  -m 20981520 -t 1000 -S fuzzer1 -N 4 -I 1  $@" Enter
    # 默认上下分屏
    tmux split-window -t "PAFL"
    tmux select-pane -L
    tmux split-window -t "PAFL"
    tmux send -t "PAFL" "$AFL_PREFIX/afl-fuzz -i in -o out -m 20981520 -t 1000  -S fuzzer2 -N 4 -I 2 $@" Enter
    tmux select-pane -R
    tmux send -t "PAFL" "$AFL_PREFIX/afl-fuzz -i in -o out  -m 20981520 -t 1000  -S fuzzer3 -N 4 -I 3  $@" Enter

    tmux attach -t PAFL

}

log-debug() {
    echo -e "\e[94m[*]\e[0m $*"
}

log-error() {
    echo -e "\e[91m[!]\e[0m $*"
    exit 1
}

print-args() {
    [[ "$#" -le 2 ]] && return
    log-debug "$1"
    for arg in "${@:2}"; do
        log-debug "\t$arg"
    done
}

usage() {
    local prog="$(basename "$0")"
    log-error "Usage\n" \
              "    $prog ./app\n"
}
if [ "$#" -eq 0 ];
then usage; exit 1; fi
AFL_PREFIX=$(dirname "$PWD")
if [ "$#" -eq 1 ];
then dyn-fuzz $@;exit;fi;
if [[ "$1" != "fast" ]]; then
    mode_option="-FP"
elif [[ "$1" != "fair" ]]; then
    mode_option="-FD"
fi
dyn-fuzz "$mode_option" " " "${@:2}"
