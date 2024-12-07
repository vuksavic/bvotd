#!/bin/sh

PASSAGES_FILE="/usr/local/etc/bible_passages.txt"

if [ -f "$PASSAGES_FILE" ]; then
    GROUP=$(grep -n "^### " "$PASSAGES_FILE" | shuf -n 1)
    GROUP_LINE=$(echo "$GROUP" | cut -d':' -f1)
    GROUP_NAME=$(echo "$GROUP" | cut -d':' -f2 | sed 's/^### //')

    NEXT_GROUP_LINE=$(grep -n "^### " "$PASSAGES_FILE" | awk -v start="$GROUP_LINE" -F':' '$1 > start {print $1; exit}')
    END_LINE=${NEXT_GROUP_LINE:-$(wc -l < "$PASSAGES_FILE")}

    VERSE=$(sed -n "$((GROUP_LINE + 1)),$((END_LINE - 1))p" "$PASSAGES_FILE" | grep "^\[[0-9]*:[0-9]*\]" | shuf -n 1)

    echo "" >> /etc/motd
    echo "$GROUP_NAME" >> /etc/motd
    echo "" >> /etc/motd
    echo "$VERSE" >> /etc/motd
else
    echo "bible passages not found" > /etc/motd
fi
