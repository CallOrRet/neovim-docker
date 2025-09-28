#!/bin/sh

export LANG=C.UTF-8
export LC_ALL=C.UTF-8
export LC_CTYPE=C.UTF-8

# system clipboard server
lemonade server >/dev/null 2>&1 &

exec nvim "$@"
