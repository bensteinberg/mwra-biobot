#!/bin/bash

set -e

POETRY=~/.local/bin/poetry
CSV=mwra-biobot.csv

if [[ $(grep `$POETRY run extract --name` $CSV) ]] ; then
    echo "No new file, exiting"
    exit 0
fi

$POETRY run extract

if [[ `git status $CSV --porcelain` ]] ; then
    R --no-save < tidy.R
    git commit -m "Update CSV files" $CSV mwra-biobot-tidied.csv
    git push origin main || exit 1
fi
