#!/bin/sh

# system clipboard server
lemonade server 2>&1 >/dev/null &

nvim "$@"
