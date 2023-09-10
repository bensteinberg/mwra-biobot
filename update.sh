#!/bin/bash

set -e

POETRY=~/.local/bin/poetry

if [[ $(grep `$POETRY run extract --name` mwra-biobot.csv) ]] ; then
    echo "No new file, exiting"
    exit 0
fi

$POETRY run extract

if [[ `git status mwra-biobot.csv --porcelain` ]] ; then
    git add mwra-biobot.csv
    git commit -m "Update CSV file"
    git push origin main || exit 1
fi