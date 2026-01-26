# Stuffolio Website Update Plan

**Generated:** January 25, 2026
**Purpose:** Ensure website accurately reflects current codebase features

---

## Executive Summary

After deep analysis of 15 HTML files and the complete Stuffolio codebase, I've identified:
- **12 features** in codebase not adequately documented on website
- **8 beta-period markers** requiring removal/update for launch
- **5 pricing/feature discrepancies** to correct
- **3 new dashboard components** (SF5a) not mentioned anywhere

---

## Part 1: New Features Missing from Website

### 1.1 Hybrid Dashboard Redesign (SF5a + SF5b) - DOCUMENTED ✅

The iOS dashboard was completely redesigned with these new components:

| Component | Description | Where to Add |
|-----------|-------------|--------------|
| **Needs Attention Card** | Shows expiring warranties, overdue maintenance, past-due loans, flagged items | features.html, quick-start.html |
| **Quick Actions Row** | Circular buttons for Scan, Add, AI, Scout | features.html |
| **Explore Section** | Feature grid: Insights, Reports, Categories, Locations, Legacy, Recalls, Loans, Backup | features.html |
| **"View All Items" Row** | Always-visible navigation to Items tab | quick-start.html |
| **"All Caught Up!" State** | Empty state with checkmark when no attention needed | features.html |
| **Section Help Tooltips** | (?) buttons on each section header | features.html |
| **Dashboard Header Bar (SF5b)** | Integrated search + customize button | features.html |
| **Actionable Tips (SF5b)** | Contextual tips based on usage patterns | features.html |
| **Maintenance Suggestions (SF5b macOS)** | Proactive maintenance cards | features.html |
| **Rating Insights (SF5b macOS)** | Rating analytics summary card | features.html |

**Completed January 2026:**
- [x] Add "Dashboard at a Glance" section to features.html
- [x] Update quick-start.html with new dashboard navigation
- [x] Update app-map.html Dashboard section with all components
- [x] Update index.html What's New section with SF5b features
- [ ] Create new iOS screenshots showing redesigned dashboard
- [ ] Update user manual with dashboard changes

### 1.2 Repair, Keep, or Replace? - PARTIALLY DOCUMENTED

Website mentions it but missing key details:

| Feature | Status | Details Missing |
|---------|--------|-----------------|
| iFixit Repair Guides | Missing | Direct links with repairability scores |
| Brand Intelligence | Missing | Aggregate ratings from user's owned items |
| Lifespan Analysis | Missing | Age vs expected lifespan calculations |
| Confidence Levels | Missing | High/Medium/Exploratory scoring |
| AI Alternatives | Missing | Network-powered alternative suggestions |

**Action Required:**
- [ ] Expand features.html section 8 with full details
- [ ] Add to comparison.html as unique differentiator

### 1.3 Save Camera Photos to Library - NOT DOCUMENTED

New setting in Build 18+:
- Option to automatically save camera captures to Photos app
- Privacy-respecting (asks for permission first)
- Useful for users who want photo backup outside app

**Action Required:**
- [ ] Add to features.html under "Work Your Way" or "Privacy First"
- [ ] Add FAQ entry in support.html

### 1.4 Certificate Pinning Security - NOT DOCUMENTED

Security enhancement (Stuffolio3a):
- MITM protection on UPC Lookup API
- MITM protection on AI Backend API
- Enhanced security for all network calls

**Action Required:**
- [ ] Add to privacy.html security section
- [ ] Consider adding to comparison.html (security differentiator)

### 1.5 Photo Quality Assessment - PARTIALLY DOCUMENTED

Website mentions "photo quality analysis" but missing specifics:
- Blur detection scoring
- Resolution assessment
- OCR suitability scoring
- Guidance for retaking poor photos

**Action Required:**
- [ ] Expand details in features.html Quick Start section

---

## Part 2: Beta-Period Content Requiring Update

### 2.1 index.html - HIGH PRIORITY

| Line | Current Content | Action |
|------|-----------------|--------|
| 45 | Commented Apple Smart App Banner | Uncomment for launch |
| 501 | "Beta Testing Now" badge | Change to "Available on the App Store" |
| 527-531 | TestFlight download buttons | Replace with App Store buttons |
| 545-611 | "What's new in v1.0 beta" section | Remove or convert to release notes |
| 1128 | Placeholder pricing after beta | Verify final pricing |
| 1174 | "Join the Beta" CTA | Change to App Store download |

### 2.2 Navigation Links - ALL FILES

Remove "Testing Guide" from navigation in:
- [ ] features.html (line 306)
- [ ] support.html (line 99)
- [ ] quick-start.html (line 131)
- [ ] family-sharing.html (line 176)
- [ ] All other files with shared navigation

### 2.3 Files to Remove/Redirect

| File | Action |
|------|--------|
| beta-testing-guide.html | Archive or redirect to support.html |
| testflight-invite.html | Redirect to App Store or remove |

---

## Part 3: Feature Accuracy Verification

### 3.1 Numerical Claims to Verify

| Claim | Website | Codebase | Status |
|-------|---------|----------|--------|
| Categories | "21 categories" | Need to count ItemCategory enum | VERIFY |
| Room presets | "18 room presets" | Need to count in LocationPickerView | VERIFY |
| Barcode formats | "14+ formats" | Need to count in BarcodeScanner | VERIFY |
| Item limit (free) | "50 items" | Need to verify in StoreManager | VERIFY |

**Action Required:**
- [ ] Count actual categories in codebase
- [ ] Count actual room presets
- [ ] Count supported barcode formats
- [ ] Verify free tier item limit

### 3.2 Pricing Verification

| Item | Website Price | Status |
|------|---------------|--------|
| Stuffolio (one-time) | $9.99 | Verify in StoreKit config |
| AI Monthly | $2.99/month | Verify in StoreKit config |
| AI Annual | $19.99/year | Verify in StoreKit config |
| Family Sharing | Included (6 users) | Verify capability |

### 3.3 Platform Requirements

| Requirement | Website | Codebase | Status |
|-------------|---------|----------|--------|
| iOS minimum | Not specified | iOS 17.0+ | UPDATE |
| macOS minimum | Not specified | macOS 14.0+ | UPDATE |
| iCloud required | "Optional" | Optional | OK |

---

## Part 4: Comparison.html Updates

### 4.1 Add New Unique Features

Features to add to "Unique to Stuffolio" section:

| Feature | Description |
|---------|-------------|
| Hybrid Dashboard | Actionable "Needs Attention" card |
| iFixit Integration | Direct repair guide links |
| Brand Intelligence | Aggregate user ratings by brand |
| Photo Quality Scoring | AI assessment of photo usability |
| Certificate Pinning | Enhanced network security |

### 4.2 Verify Competitor Data

Last verified: January 2026 - may need refresh if >30 days old

---

## Part 5: Documentation Updates

### 5.1 User Manuals

| File | Size | Updates Needed |
|------|------|----------------|
| Stuffolio_Users_Manual.html | 158KB | Dashboard redesign section |
| Stuffolio_Users_Manual_iOS.html | 137KB | New dashboard components |
| Stuffolio_Users_Manual_macOS.html | 127KB | Verify macOS dashboard |
| Stuffolio_Quick_Start_Guide.html | 33KB | New onboarding flow |

### 5.2 Support FAQ Additions

New FAQs to add:

1. **"What is the Needs Attention card?"** - Explain dashboard redesign
2. **"How do I find my items from the Dashboard?"** - View All Items navigation
3. **"Can I save camera photos to my photo library?"** - New setting
4. **"What is the Explore section?"** - Feature shortcuts explanation
5. **"How does Repair, Keep, or Replace work?"** - Full feature explanation

---

## Part 6: Screenshot Updates

### 6.1 iOS Screenshots Needing Update

| Screenshot | Reason |
|------------|--------|
| Dashboard (light) | Shows old layout, needs SF5a redesign |
| Dashboard (dark) | Shows old layout, needs SF5a redesign |
| Needs Attention | NEW - doesn't exist |
| Quick Actions | NEW - doesn't exist |
| Explore section | NEW - doesn't exist |
| Help tooltips | NEW - show (?) buttons |

### 6.2 macOS Screenshots

| Screenshot | Reason |
|------------|--------|
| Dashboard | Verify matches current implementation |
| Settings | May need update for new settings |

---

## Part 7: Privacy & Terms Updates

### 7.1 Privacy Policy (privacy.html)

- Last updated: January 2026 (current)
- Add mention of certificate pinning security
- Verify AI provider list is current (Anthropic, etc.)

### 7.2 Terms of Service (terms.html)

- Last updated: December 2025
- Consider updating to January 2026 for launch
- No content changes needed

---

## Implementation Priority

### Phase 1: Critical for Launch (Do First)
1. [ ] Remove all beta-period content from index.html
2. [ ] Remove Testing Guide links from all navigation
3. [ ] Archive/redirect beta testing pages
4. [ ] Uncomment Apple Smart App Banner
5. [ ] Update CTAs to App Store links

### Phase 2: Feature Documentation (Do Second)
1. [ ] Add SF5a Dashboard documentation to features.html
2. [ ] Expand Repair, Keep, or Replace section
3. [ ] Add new FAQs to support.html
4. [ ] Update quick-start.html with new dashboard flow

### Phase 3: Visual Updates (Do Third)
1. [ ] Capture new iOS dashboard screenshots
2. [ ] Capture Needs Attention card screenshots
3. [ ] Capture Quick Actions row screenshots
4. [ ] Update screenshot carousels

### Phase 4: Verification (Do Last)
1. [ ] Verify all numerical claims (categories, rooms, barcodes)
2. [ ] Verify pricing in StoreKit matches website
3. [ ] Test all internal links
4. [ ] Update comparison.html with new unique features

---

## Files Changed Summary

| File | Priority | Changes |
|------|----------|---------|
| index.html | HIGH | Beta content removal, CTAs, Smart App Banner |
| features.html | HIGH | SF5a dashboard, expanded features |
| quick-start.html | MEDIUM | New dashboard navigation |
| support.html | MEDIUM | New FAQs |
| comparison.html | MEDIUM | New unique features |
| family-sharing.html | LOW | Navigation link only |
| privacy.html | LOW | Security mention |
| beta-testing-guide.html | HIGH | Archive/remove |
| testflight-invite.html | HIGH | Archive/remove |
| User manuals (4 files) | MEDIUM | Dashboard sections |

---

## Estimated Effort

| Phase | Estimated Time |
|-------|----------------|
| Phase 1: Critical | 2-3 hours |
| Phase 2: Documentation | 4-6 hours |
| Phase 3: Screenshots | 2-3 hours |
| Phase 4: Verification | 1-2 hours |
| **Total** | **9-14 hours** |

---

## Next Steps

1. Review this plan and prioritize based on launch timeline
2. Decide whether to proceed with Phase 1 immediately
3. Schedule screenshot capture session (requires running app)
4. Assign verification tasks for numerical claims

---

*Plan generated by Claude Code analysis of stuffolio-site and Stufflio codebase*
