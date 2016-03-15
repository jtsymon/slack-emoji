#!/usr/bin/env bash

TOKEN=''

IMAGE_DIR="$(pwd)/images"
ALIAS_DIR="$(pwd)/aliases"

mkdir -p $IMAGE_DIR $ALIAS_DIR
declare -A aliases
for emoji in $(curl "https://slack.com/api/emoji.list?token=$TOKEN" | jq '.emoji | to_entries | map(.key + "~" + .value)[]'); do
    emoji=${emoji%\"}
    emoji=${emoji#\"}
    key=${emoji%~*}
    val=${emoji#*~}
    case $val in
        alias:*)
            echo ${val#*:} > $ALIAS_DIR/$key
            ;;
        *)
            [[ -f $IMAGE_DIR/$key ]] || curl $val > $IMAGE_DIR/$key
            ;;
    esac
done
