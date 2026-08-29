#!/usr/bin/env bash
# Guards the resume against the drift that has bitten this repo before:
# claims corrected in one place but left stale in the other, and a resume
# that quietly grows past one page.
#
# Runs from anywhere; paths resolve relative to the repo root.
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEX="$ROOT/resume/AengusResume.tex"
PDF="$ROOT/resume.pdf"
HTML="$ROOT/index.html"
fail=0

# Claims that were wrong once. They must not reappear in either file.
# Add a line here every time you correct something.
BANNED=(
  "Member of Technical Staff"
  "Bayesian optimization"
  "Currently at Ironsite"
  "20&times; tail"
  '20$\times$ tail'
  "TypeScript"
)

for claim in "${BANNED[@]}"; do
  for f in "$TEX" "$HTML"; do
    if [ -f "$f" ] && grep -qF -- "$claim" "$f"; then
      echo "STALE CLAIM  ${f#$ROOT/}: '$claim'"
      fail=1
    fi
  done
done

# The resume must stay one page.
if [ -f "$PDF" ] && command -v pdfinfo >/dev/null 2>&1; then
  pages=$(pdfinfo "$PDF" 2>/dev/null | awk '/^Pages:/{print $2}')
  if [ "${pages:-0}" != "1" ]; then
    echo "PAGE COUNT   resume.pdf is ${pages:-?} pages, expected 1"
    fail=1
  fi
fi

[ "$fail" -eq 0 ] && echo "resume checks passed"
exit "$fail"
