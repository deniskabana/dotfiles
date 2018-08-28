#!/bin/bash

esc=$(printf '\033')
BICyan="${esc}[1;95m"
UBlack="${esc}[2;37m"
Color_Off="${esc}[0m"

clear
rm ~/zshdocstemp 2>/dev/null
touch ~/zshdocstemp

rg "^(alias|function).*#" ~/.zshrc -N | while read -r line
do
  echo "$line" | sed -E "s/^\w+\s(\w+).*#\s(.*)/\1 -> \2/" \
    >> ~/zshdocstemp
done

# Colorised columnised output and delete tempfile while you're at it
cat ~/zshdocstemp | column -c 150 \
  | sed -E "s/(\w+)\s->\s/$(printf '\e[0m\e[35m')\1$(printf '\e[0m') -> /g" \
  | sed -E "s/->/$(printf '\e[1m')=>$(printf '\e[0m\e[2m')/g" \
  && rm ~/zshdocstemp 2>/dev/null
