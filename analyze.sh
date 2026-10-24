#!/usr/bin/env bash

private_sizes=$(mktemp "${TMPDIR:-/tmp}/analyze-private-sizes.XXXXXX") || exit 1
trap 'rm -f "$private_sizes"' EXIT

case "$(uname -s)" in
    Darwin*) stat_style='bsd' ;;
    *) stat_style='gnu' ;;
esac

get_file_size() {
    case "$stat_style" in
        bsd) stat -f '%z' "$1" ;;
        gnu) stat -c '%s' "$1" ;;
    esac
}

while IFS= read -r -d '' private_file; do
    file_size=$(get_file_size "$private_file") || exit 1
    printf '%s\n' "$file_size" >> "$private_sizes" || exit 1
done < <(find data/private -type f ! -name '.gitkeep' ! -name '.DS_Store' -print0)

printf 'Private size matches\tDropbox file\n'
while IFS= read -r -d '' dropbox_file; do
    file_size=$(get_file_size "$dropbox_file") || exit 1
    match_count=$(awk -v size="$file_size" '$1 == size { count++ } END { print count + 0 }' "$private_sizes") || exit 1
    printf '%s\t%q\n' "$match_count" "$dropbox_file"
done < <(find data/dropbox -type f ! -name '.gitkeep' ! -name '.DS_Store' -print0)