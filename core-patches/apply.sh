#!/usr/bin/env bash
# Fetches Gyroflow core at the revision in gyroflow-core.rev (the `rev` of gyroflow-core in common/Cargo.toml, in full)
# into ext/gyroflow and applies the patches in this folder. The plugins build against that copy (see the [patch] section in each Cargo.toml).
# Run it once before building, and again after updating gyroflow-core: `just core`
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
rev=$(tr -d '[:space:]' < "$root/core-patches/gyroflow-core.rev")
[ ${#rev} -eq 40 ] || { echo "core-patches/gyroflow-core.rev must hold a full commit hash" >&2; exit 1; }

dir="$root/ext/gyroflow"
stamp="$dir/.patched-$rev-$(cat "$root"/core-patches/*.patch | shasum | cut -c1-12)"
if [ -f "$stamp" ]; then
    echo "Gyroflow core $rev already patched in $dir"
    exit 0
fi

rm -rf "$dir"
mkdir -p "$dir"
cd "$dir"
git init -q
git remote add origin https://github.com/gyroflow/gyroflow.git
git fetch -q --depth 1 origin "$rev"
git -c advice.detachedHead=false checkout -q FETCH_HEAD
for p in "$root"/core-patches/*.patch; do
    echo "Applying $(basename "$p")"
    git apply --whitespace=nowarn "$p"
done
touch "$stamp"
echo "Gyroflow core $rev patched in $dir"
