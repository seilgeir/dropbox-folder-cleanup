#!/usr/bin/env bash

private_sizes=$(mktemp "${TMPDIR:-/tmp}/analyze-private-sizes.XXXXXX") || exit 1
trap 'rm -f "$private_sizes"' EXIT

private_files=()

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
    private_files[${#private_files[@]}]=$private_file
    file_size=$(get_file_size "$private_file") || exit 1
    printf '%s\n' "$file_size" >> "$private_sizes" || exit 1
done < <(find data/private -type f ! -name '.gitkeep' ! -name '.DS_Store' -print0)

printf 'Dropbox file\tPrivate file\n'
while IFS= read -r -d '' dropbox_file; do
    file_size=$(get_file_size "$dropbox_file") || exit 1
    match_index=$(awk -v size="$file_size" '$1 == size { print NR; exit }' "$private_sizes") || exit 1
    printf '%q\t' "$dropbox_file"
    if [ -n "$match_index" ]; then
        printf '%q' "${private_files[$((match_index - 1))]}"
    fi
    printf '\n'
done < <(find data/dropbox -type f ! -name '.gitkeep' ! -name '.DS_Store' -print0)