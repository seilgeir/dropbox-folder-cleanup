#!/usr/bin/env bash

private_files=()
private_file_sizes=()

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
    private_size=$(get_file_size "$private_file") || exit 1
    private_files[${#private_files[@]}]="$private_file"
    private_file_sizes[${#private_file_sizes[@]}]="$private_size"
done < <(find data/private -type f ! -name '.gitkeep' ! -name '.DS_Store' -print0)

mkdir -p 'data/dropbox/dup_files' || exit 1

while IFS= read -r -d '' dropbox_file; do
    dropbox_size=$(get_file_size "$dropbox_file") || exit 1
    match_found=0

    for ((index = 0; index < ${#private_files[@]}; index++)); do
        if [ "${private_file_sizes[$index]}" != "$dropbox_size" ]; then
            continue
        fi

        cmp -s "$dropbox_file" "${private_files[$index]}"
        compare_status=$?
        case "$compare_status" in
            0) match_found=1; break ;;
            1) ;;
            *) printf 'Could not compare %q with %q\n' "$dropbox_file" "${private_files[$index]}" >&2; exit 1 ;;
        esac
    done

    if [ "$match_found" -eq 0 ]; then
        continue
    fi

    destination="data/dropbox/dup_files/${dropbox_file##*/}"
    if [ -e "$destination" ] || [ -L "$destination" ]; then
        printf 'Skipping %q: destination already exists: %q\n' "$dropbox_file" "$destination" >&2
        continue
    fi

    mv "$dropbox_file" "$destination" || {
        printf 'Could not move %q to %q\n' "$dropbox_file" "$destination" >&2
        exit 1
    }
done < <(find data/dropbox -path 'data/dropbox/dup_files' -prune -o -type f ! -name '.gitkeep' ! -name '.DS_Store' -print0)
