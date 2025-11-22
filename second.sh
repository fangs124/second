#!/bin/sh
printf '\033c\033]0;%s\a' second
base_path="$(dirname "$(realpath "$0")")"
"$base_path/second.x86_64" "$@"
