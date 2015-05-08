#!/bin/bash
(($(du -cs ~/.trash | tail -1 | awk '{print $1}') > 1048576)) && \
PROMPT_COMMAND="echo -ne \"\033]0;TRASH IS FULL\007\"" || \
PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\007"'
