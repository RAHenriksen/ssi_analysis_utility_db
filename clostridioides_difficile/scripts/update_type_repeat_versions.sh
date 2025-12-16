#!/usr/bin/env bash
set -euo pipefail

# Always operate from the repo root
repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

# Go through all TR fasta files (repo-root-relative path)
for f in clostridioides_difficile/type_repeats/*.fasta; do
    # Strip path and extension to get TR name
    fname="$(basename "$f")"
    tr="${fname%.fasta}"

    # Last commit SHA and date that touched this file
    commit_sha="$(git log -1 --format=%H  -- "$f")"
    commit_date="$(git log -1 --format=%cs -- "$f")"

    version_str="TRrepeats_custom_${commit_sha}"

    # Write sidecar version file next to it, e.g. A1_version.txt
    printf '%s\t%s\n' "$version_str" "$commit_date" \
        > "clostridioides_difficile/type_repeats/${tr}_version.txt"
done