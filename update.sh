#!/bin/bash

set -e

POETRY=~/.local/bin/poetry
CSV=mwra-biobot.csv
TIDIED=mwra-biobot-tidied.csv

if [[ $(grep `$POETRY run extract --name` $CSV) ]] ; then
    echo "No new file, exiting"
    exit 0
fi

$POETRY run extract

if [[ `git status $CSV --porcelain` ]] ; then
    R --no-save < tidy.R
    PDF=`head -n 1 $CSV | cut -f 4 -d ' '`
    git commit -m "Update CSV files from $PDF" $CSV $TIDIED
    git push origin main || exit 1
fi
