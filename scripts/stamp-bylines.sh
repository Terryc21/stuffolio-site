#!/bin/bash
# stamp-bylines.sh - Re-stamp <time datetime> and visible "Updated Month Year"
# strings in HTML files to today's date.
#
# Idempotent: running on an already-current file is a no-op (sed substitution
# results in identical content; mtime may change but git sees no diff).
#
# Skip behavior: files with no <address class="byline"> pattern are silently
# skipped. Files with a byline but already matching today's date are no-ops.
#
# Pair: scripts/git-hooks/pre-commit runs this on staged HTML files so byline
# drift gets fixed at commit time. The lint guard (./scripts/site-lint.sh
# --bylines) catches drift between the visible string and the datetime
# attribute; this script prevents drift between either of them and reality.
#
# Usage:
#   ./scripts/stamp-bylines.sh path/to/file.html [more.html ...]
#
# macOS Bash 3.2 compatible.

set -u

if [ $# -eq 0 ]; then
  echo "Usage: $(basename "$0") <html-file> [more.html ...]" >&2
  echo "       Re-stamps byline datetime + visible string to today." >&2
  exit 2
fi

TODAY_ISO=$(date "+%Y-%m-%d")
TODAY_MONTH=$(date "+%B")
TODAY_YEAR=$(date "+%Y")
TODAY_VISIBLE="Updated ${TODAY_MONTH} ${TODAY_YEAR}"

STAMPED=0
SKIPPED=0

for file in "$@"; do
  if [ ! -f "$file" ]; then
    echo "stamp-bylines: not a file: $file" >&2
    continue
  fi

  # Only HTML
  case "$file" in
    *.html) ;;
    *)
      SKIPPED=$((SKIPPED + 1))
      continue
      ;;
  esac

  # Only files with the byline pattern
  if ! grep -q '<address class="byline"' "$file" 2>/dev/null; then
    SKIPPED=$((SKIPPED + 1))
    continue
  fi

  # Only files with a parseable <time datetime="YYYY-MM-DD"> pattern inside
  # the byline. Skip otherwise — safer than guessing.
  if ! grep -q '<time datetime="[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}">' "$file" 2>/dev/null; then
    SKIPPED=$((SKIPPED + 1))
    continue
  fi

  # Snapshot for change detection (avoid touching mtime if nothing changes)
  BEFORE=$(cat "$file")

  # Rewrite datetime + visible string inside the byline <address>.
  # The pattern is scoped: <address class="byline" ...> ... <time datetime="DATE">VISIBLE</time> ... </address>
  # macOS sed; -E for extended regex; -i '' for in-place no backup.
  #
  # Two-pass: datetime first, then visible string. The visible-string sed is
  # anchored on "Updated " so it only touches strings that look like bylines,
  # not random "Month Year" instances elsewhere.
  sed -i '' -E \
    -e 's|(<address class="byline"[^>]*>[^<]*<span[^>]*>[^<]*</span>[^<]*<time datetime=")[0-9]{4}-[0-9]{2}-[0-9]{2}(">)|\1'"${TODAY_ISO}"'\2|g' \
    -e 's|(<address class="byline"[^>]*>[^<]*<span[^>]*>[^<]*</span>[^<]*<time[^>]*>)Updated [A-Z][a-z]+ [0-9]{4}(</time>)|\1'"${TODAY_VISIBLE}"'\2|g' \
    "$file"

  AFTER=$(cat "$file")
  if [ "$BEFORE" != "$AFTER" ]; then
    STAMPED=$((STAMPED + 1))
    echo "stamp-bylines: stamped $file -> ${TODAY_VISIBLE} (${TODAY_ISO})"
  fi
done

if [ "$STAMPED" -gt 0 ]; then
  echo "stamp-bylines: ${STAMPED} file(s) stamped."
fi
exit 0
