#!/usr/bin/env bash
set -euo pipefail

# Always operate from the repo root (works locally and in GitHub Actions)
repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

# Reference FASTAs (top-level per species, not subdirs like type_repeats/)
ref_files=(
  clostridioides_difficile/*.fasta
  escherichia_coli/*.fasta
)

for f in "${ref_files[@]}"; do
    # If the glob didn't match anything, skip
    [ -e "$f" ] || continue

    # Strip path and extension to get base name
    fname="$(basename "$f")"      # e.g. ecoligenes.fasta
    base="${fname%.fasta}"        # e.g. ecoligenes

    # Last commit SHA and short date (YYYY-MM-DD) that touched this file
    commit_sha="$(git log -1 --format=%H  -- "$f")"
    commit_date="$(git log -1 --format=%cs -- "$f")"

    version_str="custom_${commit_sha}"

    # Write sidecar version file next to it, e.g. escherichia_coli/ecoligenes_version.txt
    printf '%s\t%s\n' "$version_str" "$commit_date" \
        > "$(dirname "$f")/${base}_version.txt"
done
