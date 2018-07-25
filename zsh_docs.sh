#!/bin/bash

esc=$(printf '\033')
BICyan="${esc}[1;95m"
UBlack="${esc}[2;37m"
Color_Off="${esc}[0m"

rg "^(alias|function).*#" ~/.zshrc -N | while read -r line
do
  echo "$line" \
    | sed -E "s/^\w+\s(\w+).*#\s(.*)/${BICyan}\1${Color_Off} - ${UBlack}\2${Color_Off}/"
done
