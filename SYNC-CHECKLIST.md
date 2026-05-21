# Website Sync Checklist

Quick reference for syncing stuffolio.app with the Stuffolio codebase.

## First-time setup (per clone)

Run once after cloning the repo:

```bash
bash scripts/install-hooks.sh
```

This installs the pre-commit git hook that auto-stamps byline dates (`<time datetime>` + visible "Updated Month Year") on any HTML page you commit. Without this step, the byline stays at whatever date it was last saved with, and `./scripts/site-lint.sh --bylines` is the only thing catching drift. With the hook, bylines you commit always match the day you committed.

Bypass for a single commit: `git commit --no-verify`. Re-run `install-hooks.sh` to pick up hook updates from `scripts/git-hooks/`.

> **Beta-to-launch ritual:** when Stuffolio goes from TestFlight beta to public App Store release, see [BETA_TO_LAUNCH_CHECKLIST.md](BETA_TO_LAUNCH_CHECKLIST.md). That document inventories every `BETA-PERIOD-ONLY` marker (15 pairs across 12 files) plus the two product decisions (App Smart Banner ID, TestFlight URL constant) that must land before the flip. The mechanical guard is `./scripts/site-lint.sh --beta-debt` (silent pre-launch, alarms at `LAUNCH_FLIPPED=1`).

## Find All Sync Points

```bash
grep -rn "SYNC:" --include="*.html" .
```

This shows every SYNC marker across all HTML files -- use it as your update checklist.

## Pages and What They Cover

| Page | SYNC Markers | Content |
|------|-------------|---------|
| `index.html` | VERSION | Hero, "What brings you here?" routing block, What's New box (BETA-PERIOD-ONLY), JSON-LD |
| `features.html` | 19 FEATURE markers | All feature descriptions |
| `use-cases.html` | None | Four-funnel entry surface (#identify, #pass-along, #take-care-of, #just-broke) + cross-cutting #insurance subsection |
| `ai-assistant.html` | None | AI Product Assistant dedicated page. Layer 1 voice. Update in lockstep with `Documentation/Architecture/AI_ASSISTANT_LAYER1_CONTRACT.md` in the app repo |
| `support.html` | 18 FAQ markers | FAQ answers |
| `whats-new.html` | CURRENT_VERSION, TESTFLIGHT_CHANGES, LASTCOMMIT | Changelog |
| `Stuffolio_Users_Manual.html` | 5 Sources/* markers | User documentation |
| `beta-testing-guide.html` | None | Build number, testing focus areas |
| `testflight-invite.html` | None | Build number, feature highlights |
| `compare.html` | None | Competitor comparison + cost calculator |
| `app-map.html` | None | Navigation map of all screens |

## Per-Sync Verification

Before updating, check these in the Xcode project:

1. **Build number** -- `grep CURRENT_PROJECT_VERSION Stuffolio.xcodeproj/project.pbxproj`
2. **Marketing version** -- `grep MARKETING_VERSION Stuffolio.xcodeproj/project.pbxproj`
3. **Min OS versions** -- `grep DEPLOYMENT_TARGET Stuffolio.xcodeproj/project.pbxproj`
4. **New features** -- `git log --oneline` since last sync
5. **Pricing** -- verify in StoreKit configuration or App Store Connect

## After Updating

- [ ] Open each modified page in browser to verify rendering
- [ ] Check SYNC markers still have matching open/close pairs
- [ ] Verify JSON-LD structured data is valid (index.html)
- [ ] Git diff review before commit

## Notes

- SYNC markers are HTML comments -- they cost nothing and serve as navigation anchors
- The old `/update-website` skill (in archived xcode-workflow-skills repo) is deprecated
- Last full sync: April 21, 2026 (Build 33)
