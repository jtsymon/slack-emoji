#!/usr/bin/env bash

TEAM=''
COOKIE=''

URL="https://${TEAM}.slack.com/customize/emoji"

# http://stackoverflow.com/questions/1732348#1732454
crumb=$(curl $URL -H "Cookie: $COOKIE" | grep -oP '<input.*?name="crumb".*?value="\K[^"]*(?=")')

for file in images/*; do
    [ -f "$file" ] || continue
    name="$(basename $file)"
    name="${name%.*}"
    curl $URL \
        -H "Cookie: $COOKIE" \
        -F "add=1" \
        -F "crumb=$crumb" \
        -F "mode=data" \
        -F "name=$name" \
        -F "img=@$file" >/dev/null
done

for file in aliases/*; do
    [ -f "$file" ] || continue
    name="$(basename $file)"
    name="${name%.*}"
    curl $URL \
        -H "Cookie: $COOKIE" \
        -F "add=1" \
        -F "crumb=$crumb" \
        -F "mode=alias" \
        -F "name=$name" \
        -F "alias=$(cat $file)" >/dev/null
done
