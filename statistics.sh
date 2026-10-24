#!/usr/bin/env bash

count_files() {
    local directory="$1"
    local file
    local count=0

    while IFS= read -r -d '' file; do
        count=$((count + 1))
    done < <(find "$directory" -type f -print0)

    printf '%s\n' "$count"
}

printf 'Dropbox files: %s\n' "$(count_files 'data/dropbox')"
printf 'Private files: %s\n' "$(count_files 'data/private')"