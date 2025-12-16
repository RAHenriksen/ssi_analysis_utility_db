#!/usr/bin/env bash
set -euo pipefail

# Go through all TR fasta files
for f in ../type_repeats/*.fasta; do
    # Strip path and extension to get TR name
    fname="$(basename "$f")"
    tr="${fname%.fasta}"

    # Last commit SHA and date that touched this file
    commit_sha="$(git log -1 --format=%H -- "$f")"
    commit_date="$(git log -1 --format=%cs -- "$f")"

    version_str="custom_${commit_sha}"

    # Write sidecar version file next to it, e.g. A1.version.txt
    printf '%s\t%s\n' "$version_str" "$commit_date" \
        > "../type_repeats/${tr}_version.txt"
done