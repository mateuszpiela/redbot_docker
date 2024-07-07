#!/bin/bash
source /redbot/redenv/bin/activate

if [[ -z "$PREFIX" ]]; then
        PREFIX="!"
fi

if [[ -z "$BOT_TOKEN" ]]; then
        echo "bot token is empty!"
        exit 1
fi

redbot default --no-prompt --prefix "$PREFIX" --token "$BOT_TOKEN"
