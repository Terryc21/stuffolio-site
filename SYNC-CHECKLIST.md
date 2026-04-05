# Website Sync Checklist

Quick reference for syncing stuffolio.app with the Stuffolio codebase.

## Find All Sync Points

```bash
grep -rn "SYNC:" --include="*.html" .
```

This shows every SYNC marker across all HTML files -- use it as your update checklist.

## Pages and What They Cover

| Page | SYNC Markers | Content |
|------|-------------|---------|
| `index.html` | VERSION | Hero, What's New box (BETA-PERIOD-ONLY), JSON-LD |
| `features.html` | 19 FEATURE markers | All feature descriptions |
| `support.html` | 18 FAQ markers | FAQ answers |
| `whats-new.html` | CURRENT_VERSION, TESTFLIGHT_CHANGES, LASTCOMMIT | Changelog |
| `Stuffolio_Users_Manual.html` | 5 Sources/* markers | User documentation |
| `beta-testing-guide.html` | None | Build number, testing focus areas |
| `testflight-invite.html` | None | Build number, feature highlights |
| `compare.html` | None | Competitor comparison |
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
- Last full sync: April 2, 2026 (Build 30)
