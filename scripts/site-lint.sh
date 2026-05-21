#!/bin/bash
# site-lint.sh - Citation-rule grep automation for stuffolio-site
#
# Rule provenance: ../stuffolio-strategy/strategy/SITE_LINT_PROVENANCE.md
# Plan: PLANS/2026-05-20-plan-1a-plan-3.md Phase A
#
# Modes:
#   --pricing     POSITIONING_ONE_PAGER_2026-05-07.md:100-104 (no-sub / free-trial / standalone-price / queries)
#   --vocab       Marketing.md:105-110 + "How we talk about AI" sub-section + specialist names
#   --bylines     "Updated [Month Year]" drift > 60 days from <time datetime="">
#   --beta-debt   BETA-PERIOD-ONLY comments; silent pre-launch, alarm when LAUNCH_FLIPPED=1
#   --all         Run every check
#
# Output format: file:line:rule:matched-text
# Exit code: 0 = clean, 1 = violations found, 2 = usage error
#
# Allowlist mechanism: append "# ALLOWLINT: rule-name (reason)" to the line
# (HTML: "<!-- ALLOWLINT: rule-name (reason) -->"). The reason must cite the
# rule source. The allowlist is the editorial-judgment surface; the lint is
# the structural-violation surface.
#
# Scoping notes (decisions made during Phase A build):
#   - User manual files (Stuffolio_Users_Manual*.html, Stuffolio_Quick_Start_Guide.html)
#     are excluded from --vocab and --pricing per Marketing.md:160-163 (in-app
#     docs allowlist). They still get --bylines and --beta-debt checks.
#   - --bylines is a CONSISTENCY check between the visible "Updated Month Year"
#     string and the same line's <time datetime="">. It does NOT check freshness
#     vs. today — that's Phase E.5 (build-time stamping). A datetime+string pair
#     that agree but are both stale will return clean.
#   - --pricing queries-vocab is broader than POSITIONING:102 strictly requires
#     (rule says "user-facing pricing copy"); flagging all "queries"/"query"
#     uses surfaces more than just the price-mention drift, but the noise is
#     bounded and reviewable. Allowlist documented exceptions.
#   - --vocab three-clause heuristic is gated behind VOCAB_STRICT=1 because it
#     would otherwise fire on every legitimate AI mention.

set -u  # -e disabled: grep returning 1 (no match) is not an error here

# IFS=newline so file lists with spaces in paths iterate correctly. Restored
# locally inside helpers where we read colon-delimited grep output.
IFS='
'

# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SITE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Public HTML pages. Excludes user-manual files which have a per-rule allowlist
# (Marketing.md:160-163 — in-app docs are a legitimate context for some
# otherwise-banned phrasings).
PUBLIC_PAGES=$(find "$SITE_ROOT" -maxdepth 1 -name "*.html" -type f \
  ! -name "Stuffolio_Users_Manual*.html" \
  ! -name "Stuffolio_Quick_Start_Guide.html" \
  | sort)

USER_MANUAL_PAGES=$(find "$SITE_ROOT" -maxdepth 1 -name "Stuffolio_Users_Manual*.html" -type f \
  | sort)

VIOLATIONS=0

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------

# emit RULE FILE LINE TEXT
emit() {
  local rule="$1" file="$2" line="$3" text="$4"
  local rel="${file#$SITE_ROOT/}"
  printf '%s:%s:%s:%s\n' "$rel" "$line" "$rule" "$text"
  VIOLATIONS=$((VIOLATIONS + 1))
}

# is_allowlisted FILE LINE RULE
# Returns 0 if the line carries an ALLOWLINT comment for this rule (or for "all").
is_allowlisted() {
  local file="$1" line="$2" rule="$3"
  local content
  content=$(sed -n "${line}p" "$file")
  case "$content" in
    *"ALLOWLINT: ${rule}"*) return 0 ;;
    *"ALLOWLINT: all"*) return 0 ;;
    *) return 1 ;;
  esac
}

# NB: The colon-delimited `read line text` calls below need IFS=:, which
# overrides the file-level IFS=newline. Bash scopes the `IFS=:` on the read
# command line to that command only, so the file-level IFS=newline stays in
# effect for the surrounding `for file in $PUBLIC_PAGES` loop.

# -----------------------------------------------------------------------------
# --pricing checks (POSITIONING_ONE_PAGER_2026-05-07.md:100-103)
# -----------------------------------------------------------------------------

check_pricing() {
  echo "# --pricing (POSITIONING_ONE_PAGER:100-103)"

  # Rule 1: ban standalone "no subscription"
  # Acceptable forms: "no required subscription", "no AI subscription",
  # "optional subscription". The phrase "no subscription" without one of
  # those qualifiers on the same line is the violation.
  local file line text rel
  for file in $PUBLIC_PAGES; do
    [ -f "$file" ] || continue
    while IFS=: read -r line text; do
      [ -z "$line" ] && continue
      case "$text" in
        *[Nn]o\ required\ [Ss]ubscription*) continue ;;
        *[Nn]o\ AI\ [Ss]ubscription*) continue ;;
        *[Nn]o\ paid\ [Ss]ubscription*) continue ;;
        *[Oo]ptional\ [Ss]ubscription*) continue ;;
      esac
      if is_allowlisted "$file" "$line" "no-subscription"; then
        continue
      fi
      emit "no-subscription" "$file" "$line" "$text"
    done < <(grep -niE 'no subscription' "$file" 2>/dev/null || true)
  done

  # Rule 2: ban "free trial" framing
  # The 7-day trial is a product affordance, not Apple's intro-offer mechanic.
  # Acceptable: "7 days to try", "free to try at install", "try free for".
  for file in $PUBLIC_PAGES; do
    [ -f "$file" ] || continue
    while IFS=: read -r line text; do
      [ -z "$line" ] && continue
      if is_allowlisted "$file" "$line" "free-trial"; then
        continue
      fi
      emit "free-trial" "$file" "$line" "$text"
    done < <(grep -niE 'free[- ]trial' "$file" 2>/dev/null || true)
  done

  # Rule 3: ban standalone "$9.99 unlocks everything" / "Pay Once. Own It."
  # Must be qualified within a sentence's reach. Heuristic: flag the headline
  # forms; allowlist required if intentional.
  for file in $PUBLIC_PAGES; do
    [ -f "$file" ] || continue
    while IFS=: read -r line text; do
      [ -z "$line" ] && continue
      if is_allowlisted "$file" "$line" "standalone-price"; then
        continue
      fi
      emit "standalone-price" "$file" "$line" "$text"
    done < <(grep -niE '\$9\.99 unlocks everything|Pay Once\. Own It\.' "$file" 2>/dev/null || true)
  done

  # Rule 4: ban "queries" in user-facing pricing copy (POSITIONING:102)
  # Only fires on lines that also mention pricing/quota/subscription/allowance —
  # POSITIONING:102 scopes this to "user-facing pricing copy" specifically.
  # General-context "query" mentions (feature descriptions, technical docs) are
  # out of scope. Enable VOCAB_STRICT=1 in --vocab to flag all uses for review.
  for file in $PUBLIC_PAGES; do
    [ -f "$file" ] || continue
    while IFS=: read -r line text; do
      [ -z "$line" ] && continue
      if is_allowlisted "$file" "$line" "queries-vocab"; then
        continue
      fi
      emit "queries-vocab" "$file" "$line" "$text"
    done < <(grep -niE '\b[Qq]ueries\b|\b[Qq]uery\b' "$file" 2>/dev/null \
             | grep -iE 'pric|quota|subscri|allowance|tier|free|\$|month|year' || true)
  done
}

# -----------------------------------------------------------------------------
# --vocab checks (Marketing.md:105-110, "How we talk about AI", specialist names)
# -----------------------------------------------------------------------------

check_vocab() {
  echo "# --vocab (Marketing.md:105-110 + How we talk about AI + specialist names)"

  # Rule: banned audience-association words (Marketing.md:105)
  # hoard / declutter / Marie Kondo / minimalism
  local file line text
  for file in $PUBLIC_PAGES; do
    [ -f "$file" ] || continue
    while IFS=: read -r line text; do
      [ -z "$line" ] && continue
      if is_allowlisted "$file" "$line" "audience-vocab"; then
        continue
      fi
      emit "audience-vocab" "$file" "$line" "$text"
    done < <(grep -niE '\b(hoard|hoarder|hoarding|declutter|decluttering|Marie Kondo|minimalism|minimalist)\b' "$file" 2>/dev/null || true)
  done

  # Rule: banned insurance phrasings (Marketing.md:106-107, 127-131, 162-167)
  # insurance-grade / insurance-approved / insurance-ready / claim-ready
  # submit a claim / file a claim / claim system
  for file in $PUBLIC_PAGES; do
    [ -f "$file" ] || continue
    while IFS=: read -r line text; do
      [ -z "$line" ] && continue
      if is_allowlisted "$file" "$line" "insurance-vocab"; then
        continue
      fi
      emit "insurance-vocab" "$file" "$line" "$text"
    done < <(grep -niE 'insurance[- ](grade|approved|ready)|claim[- ]ready|(submit|file) a claim|claim system' "$file" 2>/dev/null || true)
  done

  # Rule: banned "estate planning" (Marketing.md:108)
  # Replacement: "legal arrangements", "passing things along"
  for file in $PUBLIC_PAGES; do
    [ -f "$file" ] || continue
    while IFS=: read -r line text; do
      [ -z "$line" ] && continue
      if is_allowlisted "$file" "$line" "estate-planning"; then
        continue
      fi
      emit "estate-planning" "$file" "$line" "$text"
    done < <(grep -niE 'estate[- ]planning' "$file" 2>/dev/null || true)
  done

  # Rule: banned collector/grade vocab (Marketing.md:109)
  for file in $PUBLIC_PAGES; do
    [ -f "$file" ] || continue
    while IFS=: read -r line text; do
      [ -z "$line" ] && continue
      if is_allowlisted "$file" "$line" "collector-vocab"; then
        continue
      fi
      emit "collector-vocab" "$file" "$line" "$text"
    done < <(grep -niE 'antique collector|collector[- ]grade|investment[- ]grade' "$file" 2>/dev/null || true)
  done

  # Rule: "AI-powered" as a hero claim (Marketing.md:110, 123)
  # Banned on public pages. User-manual files use a separate allowlist below.
  for file in $PUBLIC_PAGES; do
    [ -f "$file" ] || continue
    while IFS=: read -r line text; do
      [ -z "$line" ] && continue
      if is_allowlisted "$file" "$line" "ai-powered"; then
        continue
      fi
      emit "ai-powered" "$file" "$line" "$text"
    done < <(grep -niE 'AI[- ](powered|driven|assisted)' "$file" 2>/dev/null || true)
  done

  # Rule (NEW from Plan 2): heading-position AI check
  # H1/H2/H3 whose text starts with "AI" or contains "AI-powered/-driven/-assisted".
  # Heading-position is hero-coded; structural form of the AI-powered ban.
  for file in $PUBLIC_PAGES; do
    [ -f "$file" ] || continue
    while IFS=: read -r line text; do
      [ -z "$line" ] && continue
      if is_allowlisted "$file" "$line" "ai-heading"; then
        continue
      fi
      emit "ai-heading" "$file" "$line" "$text"
    done < <(grep -niE '<h[1-3][^>]*>[[:space:]]*(<[^>]+>)*[[:space:]]*AI[- ]|<h[1-3][^>]*>[^<]*AI[- ](powered|driven|assisted)' "$file" 2>/dev/null || true)
  done

  # Rule (NEW from Plan 2): three-clause heuristic
  # Sentences mentioning "AI" / "Stuff Scout" / "AI Assistant" should contain a
  # job-shaped phrase (action verb naming a user situation) within ~15 words.
  # This is a heuristic: flag candidates for review, not a hard ban.
  # Implementation note: greps for the trigger; relies on writer to verify the
  # job clause is present. Suppress with ALLOWLINT: three-clause when verified.
  #
  # DISABLED by default (too noisy for first pass). Enable with VOCAB_STRICT=1.
  if [ "${VOCAB_STRICT:-0}" = "1" ]; then
    for file in $PUBLIC_PAGES; do
      [ -f "$file" ] || continue
      while IFS=: read -r line text; do
        [ -z "$line" ] && continue
        if is_allowlisted "$file" "$line" "three-clause"; then
          continue
        fi
        emit "three-clause" "$file" "$line" "$text"
      done < <(grep -niE '\b(AI|Stuff Scout|AI Assistant)\b' "$file" 2>/dev/null || true)
    done
  fi

  # Rule: specialist names banned on public pages (Marketing.md:158-168)
  # NAWCC / PCGS / Heritage Auctions / Pocket Watch DB / Reverb
  # Credibility infrastructure, not marketing claims. User-manual files
  # (in-app docs) are checked separately with allowlist guidance.
  for file in $PUBLIC_PAGES; do
    [ -f "$file" ] || continue
    while IFS=: read -r line text; do
      [ -z "$line" ] && continue
      if is_allowlisted "$file" "$line" "specialist-names"; then
        continue
      fi
      emit "specialist-names" "$file" "$line" "$text"
    done < <(grep -niE '\b(NAWCC|PCGS|Heritage Auctions|Pocket Watch DB|Reverb)\b' "$file" 2>/dev/null || true)
  done

  # Rule: "what it isn't" line presence on AI feature surfaces
  # Any page that names an AI feature must contain a disavowal sentence.
  # Implementation: page-level check, not line-level. Flag pages that mention
  # AI feature names but lack any "Not a" / "Not an" / "Not the" / "is not"
  # negative-form disavowal.
  for file in $PUBLIC_PAGES; do
    [ -f "$file" ] || continue
    if grep -qiE '\b(Stuff Scout|AI Assistant|AI Product Assistant)\b' "$file" 2>/dev/null; then
      if ! grep -qiE '\b(Not an?|Not the|is not|does not (diagnose|appraise|substitute|replace))\b' "$file" 2>/dev/null; then
        local rel="${file#$SITE_ROOT/}"
        printf '%s:0:what-it-isnt:page mentions AI feature but lacks disavowal sentence\n' "$rel"
        VIOLATIONS=$((VIOLATIONS + 1))
      fi
    fi
  done
}

# -----------------------------------------------------------------------------
# --bylines: visible "Updated Month Year" must agree with the same line's
# <time datetime="YYYY-MM-DD"> to within ~60 days. Catches the failure mode
# where a writer touches the datetime but forgets the human string (or vice
# versa) — SITE_AUDIT_2026-05-20.md Bucket 5.
# -----------------------------------------------------------------------------

check_bylines() {
  echo "# --bylines (SITE_AUDIT_2026-05-20.md Bucket 5)"

  local file rel line text
  local month_name year month_num byline_epoch
  local datetime_str datetime_epoch
  local drift_seconds drift_days

  for file in $PUBLIC_PAGES; do
    [ -f "$file" ] || continue
    rel="${file#$SITE_ROOT/}"

    while IFS=: read -r line text; do
      [ -z "$line" ] && continue
      if is_allowlisted "$file" "$line" "bylines"; then
        continue
      fi

      # Both <time datetime="..."> AND "Updated Month Year" must be on the line
      datetime_str=$(printf '%s' "$text" | sed -n 's/.*datetime="\([0-9-]\{10\}\)".*/\1/p' | head -1)
      month_name=$(printf '%s' "$text" | sed -n 's/.*[Uu]pdated[[:space:]]\{1,\}\([A-Z][a-z]\{2,8\}\)[[:space:]]\{1,\}\([0-9]\{4\}\).*/\1/p' | head -1)
      year=$(printf '%s' "$text" | sed -n 's/.*[Uu]pdated[[:space:]]\{1,\}\([A-Z][a-z]\{2,8\}\)[[:space:]]\{1,\}\([0-9]\{4\}\).*/\2/p' | head -1)
      [ -z "$datetime_str" ] && continue
      [ -z "$month_name" ] && continue
      [ -z "$year" ] && continue

      case "$month_name" in
        January) month_num=01 ;;   February) month_num=02 ;;
        March)   month_num=03 ;;   April)    month_num=04 ;;
        May)     month_num=05 ;;   June)     month_num=06 ;;
        July)    month_num=07 ;;   August)   month_num=08 ;;
        September) month_num=09 ;; October)  month_num=10 ;;
        November) month_num=11 ;;  December) month_num=12 ;;
        *) continue ;;
      esac

      # macOS date: -j -f to parse. 15th of month as visible-string anchor.
      byline_epoch=$(date -j -f "%Y-%m-%d" "${year}-${month_num}-15" "+%s" 2>/dev/null) || continue
      datetime_epoch=$(date -j -f "%Y-%m-%d" "$datetime_str" "+%s" 2>/dev/null) || continue

      drift_seconds=$(( datetime_epoch - byline_epoch ))
      [ "$drift_seconds" -lt 0 ] && drift_seconds=$(( -drift_seconds ))
      drift_days=$(( drift_seconds / 86400 ))

      if [ "$drift_days" -gt 60 ]; then
        printf '%s:%s:byline-drift:datetime=%s vs "Updated %s %s" (%d days apart)\n' \
          "$rel" "$line" "$datetime_str" "$month_name" "$year" "$drift_days"
        VIOLATIONS=$((VIOLATIONS + 1))
      fi
    done < <(grep -niE '<time datetime=' "$file" 2>/dev/null || true)
  done
}

# -----------------------------------------------------------------------------
# --beta-debt: BETA-PERIOD-ONLY comments
# -----------------------------------------------------------------------------

check_beta_debt() {
  local launch_flipped="${LAUNCH_FLIPPED:-0}"

  if [ "$launch_flipped" = "1" ]; then
    echo "# --beta-debt (LAUNCH_FLIPPED=1, alarm mode)"
  else
    echo "# --beta-debt (LAUNCH_FLIPPED=0, silent pre-launch — no violations emitted)"
    return 0
  fi

  local file rel line text
  for file in $PUBLIC_PAGES; do
    [ -f "$file" ] || continue
    rel="${file#$SITE_ROOT/}"
    while IFS=: read -r line text; do
      [ -z "$line" ] && continue
      printf '%s:%s:beta-debt:%s\n' "$rel" "$line" "$text"
      VIOLATIONS=$((VIOLATIONS + 1))
    done < <(grep -niE 'BETA-PERIOD-ONLY' "$file" 2>/dev/null || true)
  done
}

# -----------------------------------------------------------------------------
# Usage and main
# -----------------------------------------------------------------------------

usage() {
  cat <<EOF
Usage: $(basename "$0") [--pricing] [--vocab] [--bylines] [--beta-debt] [--all]

Lints stuffolio-site HTML pages against rules in
  ../stuffolio-strategy/strategy/SITE_LINT_PROVENANCE.md

Modes (run individually or combined):
  --pricing     POSITIONING_ONE_PAGER:100-103
  --vocab       Marketing.md:105-110 + "How we talk about AI" + specialist names
  --bylines     Drift > 60 days on "Updated Month Year" stamps
  --beta-debt   BETA-PERIOD-ONLY markers (silent unless LAUNCH_FLIPPED=1)
  --all         Run every check

Environment:
  LAUNCH_FLIPPED=1   Treat beta-debt markers as alarms (post-launch)
  VOCAB_STRICT=1     Enable noisy three-clause heuristic in --vocab

Output: file:line:rule:matched-text
Exit:   0 clean, 1 violations, 2 usage error

To suppress a single line: append "<!-- ALLOWLINT: <rule-name> (reason) -->"
or "# ALLOWLINT: <rule-name> (reason)" on that line. Reason MUST cite the
strategy doc.
EOF
}

if [ $# -eq 0 ]; then
  usage
  exit 2
fi

DO_PRICING=0
DO_VOCAB=0
DO_BYLINES=0
DO_BETA=0

for arg in "$@"; do
  case "$arg" in
    --pricing) DO_PRICING=1 ;;
    --vocab) DO_VOCAB=1 ;;
    --bylines) DO_BYLINES=1 ;;
    --beta-debt) DO_BETA=1 ;;
    --all) DO_PRICING=1; DO_VOCAB=1; DO_BYLINES=1; DO_BETA=1 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; usage >&2; exit 2 ;;
  esac
done

[ "$DO_PRICING" = "1" ] && check_pricing
[ "$DO_VOCAB" = "1" ] && check_vocab
[ "$DO_BYLINES" = "1" ] && check_bylines
[ "$DO_BETA" = "1" ] && check_beta_debt

echo ""
if [ "$VIOLATIONS" -eq 0 ]; then
  echo "# Clean. 0 violations."
  exit 0
else
  echo "# $VIOLATIONS violation(s)."
  exit 1
fi
