#!/bin/bash
# check-site-claims.sh - flag published claims the app code contradicts.
#
# WHY THIS EXISTS
#   On 2026-09-02 an audit of all 21 pages found ~45 false or overstated claims.
#   The worst of them had propagated: the "set a target price" feature, which the
#   app has NEVER implemented, appeared on five separate pages including JSON-LD
#   structured data and a beta-tester checklist. Nothing caught it because nothing
#   was looking.
#
#   Each rule below is seeded from a claim that was VERIFIED false against code in
#   that audit, with the file:line evidence recorded in the rule. This is not a
#   guess at what might go wrong; it is a list of what already did.
#
# WHAT IT CANNOT DO
#   🛑 It catches RECURRENCE of known-false claims, never a novel one. Of the ~45
#   findings, most were claims the app never supported rather than features that
#   changed, so no change-log or diff-based check would have caught them either.
#   A human audit against code remains the only way to find a new false claim.
#   Treat a clean run as "no known-bad phrases", not "the site is accurate".
#
# USAGE
#   ./scripts/check-site-claims.sh          # check, exit 1 on any hit
#   ./scripts/check-site-claims.sh --list   # print the rules and their evidence
#
#   Allowlist a legitimate use by appending to the line:
#     <!-- ALLOWCLAIM: rule-name (reason citing why this use is correct) -->
#   matching the ALLOWLINT convention in site-lint.sh.

set -u
cd "$(dirname "$0")/.." || exit 2

VIOLATIONS=0
MODE="${1:-check}"

# rule|pattern|why it is false, with app evidence
RULES='
target-price|[Tt]arget price|No target-price concept exists in the app. grep targetPrice/priceDropAlert across Sources returns zero. The only mechanism is NotificationManager.swift:398-412, a percent-change alert against PURCHASE price that also fires on increases (:415-416).
price-drops-below|drops? below (your |the )?(target|threshold)|Same as target-price, and directionally wrong: the alert fires on rises too (NotificationManager.swift:415-416).
set-alert-button|Set Alert|No "Set Alert" control exists. Price Watch buttons are Add Price, Update, Get Price with AI, Cancel, Save (PriceWatchSection.swift).
track-prices-label|Track Prices|The toggle ships as "Track Replacement Price" (PriceWatchSection.swift:26).
onboarding-permissions|Accessibility Options|No such onboarding screen. Sources/Views/Onboarding/ has no permission or accessibility screen; OnboardingView.swift:88-205 is one value/pricing screen.
onboarding-allow-camera|Allow Camera|No such onboarding step; the string does not exist in Sources. Permissions are requested at first use.
per-item-sharing|Share with Household|There is NO per-item share button. FamilySharingManager.swift:1430-1436: when a household is active every item in the shared inventory syncs. Privacy is per-INVENTORY (:1338).
crash-auto-send|[Cc]rash reports are sent automatically|Crash reporting is opt-in and OFF by default (SettingsModel.swift:223); CrashReporting.configure() guards on it.
settings-legacy-planning|Settings *(>|&gt;|→) *Legacy Planning|No such screen. It is "Legacy Settings" (LegacySettingsView.swift:28), reached from inside Legacy Wishes, not from Settings. Feature also ships visible by default (SettingsModel.swift:362).
settings-insurance-profile|Settings *(>|&gt;|→) *Insurance Profile|No such row. The route is Settings > Coverage Insights (CoverageInsightsSettingsView.swift:35), and the profile stays hidden until coverage tracking is switched from Simple (the default, SettingsModel.swift:348) to Detailed.
recall-alerts|[Rr]ecall [Aa]lerts|There is no recall notification anywhere (421e74ca): no NotificationType case, no UNMutableNotificationContent in RecallChecker. Checks are user-triggered (RecallCheckerView.swift:312). Say "recall checking".
siri-25|25\+ ?(Siri|voice|commands|actions)|Siri answers 10 spoken phrases (10 AppShortcut registrations in WarrantyAppIntents.swift). The larger number counts Shortcuts-app ACTIONS, which are a different thing.
analytics-toggle|Analytics.*(Settings|disable|turn off)|analyticsEnabled has NO toggle UI anywhere; it defaults ON (SettingsModel.swift:319) and is read by Analytics.swift:265. The app screen also states the opposite (PrivacySettingsView.swift:425). Do not describe an analytics opt-out until the app has one.
impl-vocab|BGProcessingTask|CKSyncEngine|SwiftData|modelContext|@Model|CloudKit zone|Implementation vocabulary does not belong on a user-facing page. Name what the reader does, not how it is built.
'

if [ "$MODE" = "--list" ]; then
  printf '%s\n' "$RULES" | while IFS='|' read -r name pattern why; do
    [ -z "$name" ] && continue
    printf '\n\033[1m%s\033[0m\n  pattern: %s\n  why:     %s\n' "$name" "$pattern" "$why"
  done
  exit 0
fi

PAGES=$(find . -maxdepth 1 -name '*.html' -type f | sort)

printf '# check-site-claims: %s pages\n\n' "$(echo "$PAGES" | wc -l | tr -d ' ')"

# ⚠️ Load-bearing: the rule loop must NOT run in a pipe subshell, or VIOLATIONS
# is incremented in a child and lost, and the script exits 0 while printing
# violations. That bug was present in the first cut of this file and caught by
# testing the FAILURE direction. A gate that cannot fail is not a gate.
while IFS='|' read -r name pattern why; do
  [ -z "$name" ] && continue
  for page in $PAGES; do
    while IFS=: read -r lineno text; do
      [ -z "$lineno" ] && continue
      case "$text" in
        *ALLOWCLAIM:*"$name"*) continue ;;
      esac
      printf '%s:%s:%s\n' "${page#./}" "$lineno" "$name"
      printf '  claim: %s\n' "$(echo "$text" | sed 's/^[[:space:]]*//' | cut -c1-110)"
      printf '  why:   %s\n\n' "$why"
      VIOLATIONS=$((VIOLATIONS + 1))
    done <<EOF
$(grep -nE "$pattern" "$page" 2>/dev/null)
EOF
  done
done <<RULES_EOF
$RULES
RULES_EOF

if [ "$VIOLATIONS" -gt 0 ]; then
  printf '# %s violation(s). Each is a claim the app code contradicts.\n' "$VIOLATIONS"
  printf '# Fix the copy, or add "<!-- ALLOWCLAIM: <rule> (reason) -->" if the use is legitimate.\n'
  exit 1
fi

printf '# Clean. 0 violations.\n'
printf '# ⚠️ This checks for RECURRENCE of known-false claims only. It cannot find a new one.\n'
exit 0
