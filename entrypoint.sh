#!/bin/sh

# system clipboard server
lemonade server >/dev/null 2>&1 &

exec nvim "$@"
