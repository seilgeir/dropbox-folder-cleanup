# Project Instructions

## Purpose

I have copied parts of my file archive into the `data` directory for this project.

I suspect that some of the files in `data/dropbox` folder already exist in `data/private`.

I need to identify move duplicates from `data/dropbox` to appropriate sub-folders within `data/dropbox`.

## Method

We will compare the file my size and content to identify duplicates.
File names may (and will) differ between the two directories.

Files in `data/dropbox` have name structure that hints on their date (or at least year).
Files in `data/private` are arranged in sub-folders per year.
This structure will provide additional layer of trust in the matching process.

## Constraints

- Never change files in the `data/private` directory.
- Never delete or rename any file in the `data/dropbox` directory.
- As duplicates are identified, the file in `data/dropbox` shall be moved to a sub-folder within `data/dropbox`. File in `data/private` shall remain unchanged.

## Tooling

Use Bash for project scripts. Scripts must run on macOS and Windows Bash, so target macOS's default Bash 3.2 and avoid Bash 4+ features and GNU-only utilities. Handle filenames safely, including spaces and other special characters.

## Confirmation

Always ask before executing any script from this repo.