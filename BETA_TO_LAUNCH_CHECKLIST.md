# Beta-to-Launch Checklist

The site is currently shipping a TestFlight beta CTA. When Stuffolio goes from beta to public App Store release, every `BETA-PERIOD-ONLY` marker in the codebase needs to flip. This document is the master inventory of those flips, plus the two product decisions that need to land before the flips happen.

The mechanical enforcement is `scripts/site-lint.sh --beta-debt`. Pre-launch the lint is silent; on launch day, set `LAUNCH_FLIPPED=1` and any surviving marker becomes a build-failing violation. The lint catches drift; this checklist guides the human walking through it.

**Companion docs:** [SYNC-CHECKLIST.md](SYNC-CHECKLIST.md) for ongoing sync points, [PLANS/2026-05-20-plan-1a-plan-3.md](PLANS/2026-05-20-plan-1a-plan-3.md) Phase D for the rationale and effort estimate.

---

## How to use this doc on launch day

1. Read the two **Product decisions** section first. Both have to land before any flips happen.
2. Walk each entry in the **Marker pairs** section. For each: (a) read the current beta state, (b) apply the launch state, (c) run the verification step.
3. After every entry is flipped, run `LAUNCH_FLIPPED=1 ./scripts/site-lint.sh --beta-debt`. The expected output is `Clean. 0 violations.` Any remaining hit is a missed flip.
4. Smoke test: open `index.html` and the four pages with the most-visible CTAs (`about.html`, `compare.html`, `features.html`, `quick-start.html`) in a browser. Confirm every TestFlight link has become an App Store link, every "Beta Testing Now" badge has become an App Store badge, and the "What's new in Build N" section has either been converted to release notes or removed.
5. Decide separately whether to keep or 410-Gone the two beta-specific pages: `beta-testing-guide.html` and `testflight-invite.html`. Plan 1a Phase D Section 3 flagged both.

Estimated time at launch: 1 hour for the mechanical flips + the decisions on the two beta-specific pages.

---

## Product decisions (required before any flip)

These need to be locked in before the marker walk. They're not part of the per-file flip; they're the inputs the flips depend on.

### D1 — App Smart Banner: real app-id or remove

`index.html:46` and `story.html:45` both contain a commented-out Smart Banner meta tag with a `YOUR_APP_ID` placeholder:

```html
<!-- <meta name="apple-itunes-app" content="app-id=YOUR_APP_ID"> -->
```

**Decision needed:** at launch, replace `YOUR_APP_ID` with the real numeric App Store ID (from App Store Connect) and uncomment, OR remove the comment entirely if the Smart Banner is not part of the launch.

If keeping the Smart Banner: uncomment and replace the placeholder in both files. Confirm the meta tag's `app-id` is the real ID (not a placeholder, not a TestFlight URL, not the bundle identifier — Apple Smart Banner expects the numeric ID).

### D2 — TestFlight URL constant: build-time substitution

10 TestFlight URL references across 7 files all point to the same URL: `https://testflight.apple.com/join/TWgM95st`. Hand-editing all 10 at launch is the failure mode this checklist exists to prevent.

**Recommendation:** before launch, replace every `https://testflight.apple.com/join/TWgM95st` with a single token (e.g., `{{APP_STORE_URL}}`) and add a pre-deploy substitution step in the Cloudflare Pages build. The token's value is `https://testflight.apple.com/join/TWgM95st` pre-launch and the App Store URL post-launch. Toggle via env var.

If the build-step migration does not happen before launch, the fallback is a manual find-replace across the 7 files. Files affected: `about.html` (1), `app-map.html` (1), `beta-testing-guide.html` (2), `compare.html` (1), `family-sharing.html` (1), `index.html` (4), `support.html` (deferred Phase E.4 may add), `use-cases.html` (1), `whats-new.html` (1), and the 10 BETA-PERIOD-ONLY blocks below contain most of them.

---

## Marker pairs (15 pairs across 12 files)

The lint's `--beta-debt` mode enumerates all of these in alarm mode. Pairs are listed in file order. Most are the same "download-cta" badge block; the index.html pairs are the structural exceptions (hero badge, hero CTA row, What's New section, final CTA section, footer badge).

### Reference comments (no flip needed)

| # | File:Line | Notes |
|---|---|---|
| R1 | `index.html:5` | Top-of-file pointer comment naming the convention. KEEP. |
| R2 | `story.html:5` | Same. KEEP. |

The lint flags these in `LAUNCH_FLIPPED=1` mode because they contain the literal string. They are intentional and stay. If the lint noise becomes an issue, the alternative is to rephrase to "BETA-LAUNCH-ONLY" or similar and update the lint regex.

### Hero / chrome flips (index.html only)

| # | File:Line | Current beta state | Launch state | Verification |
|---|---|---|---|---|
| H1 | `index.html:449-475` | Hero badge: `<div class="badge"><span class="dot"></span> Beta Testing Now • iPhone / iPad / Mac</div>` (line 450) | Replace with App Store availability badge: e.g., `Now on the App Store • iPhone / iPad / Mac` or remove if the App Store badge below is sufficient | View hero section; badge text reflects shipping status |
| H2 | `index.html:476-485` | Hero CTA row: TestFlight join link + Quick Start. Button text: "Become a Beta Tester" | Replace with App Store download buttons. Either two buttons (App Store + Quick Start) or one App Store badge image | Click hero CTA; lands on App Store |
| H3 | `index.html:605-662` | "What's new in Build 33" section with feature highlights | Either (a) convert to "Release Notes" with a link to whats-new.html, or (b) remove and let whats-new.html carry the changelog. Plan 1a Phase D Section 3 leans toward (a) | View index.html below the hero; section is either gone or framed as ongoing release notes, not a build-specific callout |
| H4 | `index.html:886-902` | Final CTA: "Join the Beta" button → TestFlight URL | Replace button text with "Download on App Store" and update the link to the App Store URL (or use the build-time token from D2) | Scroll to final CTA; button reads launch-appropriate copy |
| H5 | `index.html:948-955` | Footer download-cta badge (TestFlight) | Replace with App Store badge | Scroll to footer; App Store badge present |

### Footer download-cta badges (identical block across 10 files)

Every entry in this table is the same block:

```html
<!-- BETA-PERIOD-ONLY: Change to App Store badge after launch -->
<div class="download-cta">
  <a href="https://testflight.apple.com/join/TWgM95st" class="download-badge testflight">
    <img src="assets/testflight-badge.svg" alt="Download on TestFlight" width="135" height="40" onerror="this.outerHTML='<span class=badge-fallback>Join TestFlight Beta</span>'" />
  </a>
  <span class="download-tagline">Free beta • iPhone, iPad, Mac</span>
</div>
<!-- END BETA-PERIOD-ONLY -->
```

The launch state for all 10 is the same: replace TestFlight URL with App Store URL, replace `testflight-badge.svg` with `app-store-badge.svg` (asset to be added pre-launch), drop the "Free beta" tagline or rewrite to launch-appropriate copy.

| # | File:Line |
|---|---|
| F1 | `about.html:267-274` |
| F2 | `app-map.html:1396-1403` |
| F3 | `beta-testing-guide.html:568-575` |
| F4 | `compare.html:1211-1218` |
| F5 | `features.html:1653-1660` |
| F6 | `quick-start.html:565-572` |
| F7 | `story.html:688-695` |
| F8 | `support.html:1074-1081` |
| F9 | `use-cases.html:582-589` |
| F10 | `whats-new.html:853-860` |

Verification for the batch: grep `testflight-badge.svg` across all HTML files after the flip. Expected count: 0. Then grep `app-store-badge.svg`. Expected count: 10 (one per file, assuming the badge asset path is consistent).

---

## Beta-specific pages (separate decision)

These two pages do not contain `BETA-PERIOD-ONLY` markers because the *entire page* may become irrelevant at launch.

### `beta-testing-guide.html`

A how-to-test guide written for TestFlight users. At launch: either (a) repurpose as an onboarding guide for new App Store users (significant rewrite), (b) keep as a historical artifact with a "this guide is from the beta period" callout, or (c) remove (404 or redirect to `quick-start.html`).

**Recommendation:** option (c). The Quick Start Guide serves new users; the beta-testing-guide content is mostly TestFlight install instructions that don't apply post-launch.

### `testflight-invite.html`

A standalone landing page for the TestFlight invite link. At launch: serve a 410 Gone response, or redirect to the App Store URL. Keeping the page live with stale TestFlight content would confuse late visitors clicking old links.

**Recommendation:** Cloudflare Pages redirect to the App Store URL.

---

## Lint verification at launch

```bash
# Should pass (silent pre-launch):
./scripts/site-lint.sh --beta-debt

# Should fail with current state (alarm mode):
LAUNCH_FLIPPED=1 ./scripts/site-lint.sh --beta-debt

# After every flip is applied, this should pass:
LAUNCH_FLIPPED=1 ./scripts/site-lint.sh --beta-debt
```

The lint catches missed flips. The two reference comments (R1, R2) are expected hits that stay.

---

## What this checklist intentionally does NOT cover

- Per-file copy rewrites beyond the marker pairs (Phase 1a B/C/E handle those)
- ai-assistant.html (Plan 3 Phase 3.C, gated separately on Plan 4 Phase 4.B-Symptom)
- App Store metadata (App Store Connect form, not the website)
- Privacy manifest / age rating / export compliance (Stuffolio app release ritual)

For the full launch ritual including the app side, see `Documentation/Development/RELEASE_CHECKLIST.md` in the Stuffolio app repo.
