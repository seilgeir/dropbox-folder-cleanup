# Dropbox Folder Cleanup

This project helps identify files in `data/dropbox` that also exist in `data/private`. The private archive is organized into year-based folders. The scripts inspect the archive and, when an exact duplicate is found, can move the Dropbox copy into `data/dropbox/dup_files` without changing `data/private`.

Run the scripts from the repository root.

## Scripts

- `statistics.sh` counts regular files recursively in `data/dropbox` and `data/private`.
- `analyze.sh` lists each Dropbox file and the first private file with the same size. This is a size-based comparison only; matching sizes do not prove the contents are identical. It excludes `.gitkeep` and `.DS_Store`.
- `move_to_dup_files.sh` checks files with matching sizes against their contents. It moves exact matches from `data/dropbox` into `data/dropbox/dup_files`, creating that folder if needed. It skips `.gitkeep` and `.DS_Store`, does not overwrite an existing destination, and leaves `data/private` unchanged.

The scripts use Bash and handle filenames containing spaces and other special characters. Review the output of `analyze.sh` before running the mover, since the mover changes file locations under `data/dropbox`.