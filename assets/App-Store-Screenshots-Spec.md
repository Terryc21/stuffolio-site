# Stuffolio — App Store Screenshot Spec Sheet
## For Figma / Design Tool Implementation

---

## Canvas Sizes (create 3 Figma pages)

| Page | Device | Canvas Size | Orientation |
|------|--------|------------|-------------|
| 1 | iPhone 6.9" | 1290 x 2796 px | Portrait |
| 2 | iPad 13" | 2064 x 2752 px | Portrait |
| 3 | Mac | 2880 x 1800 px | Landscape |

**Export:** PNG, 72 DPI, sRGB color space, fully opaque (no transparency)

---

## Layout Grid

### iPhone (1290 x 2796 px)

```
┌──────────────────────────────┐
│        80px top padding      │
│                              │
│   ┌──────────────────────┐   │
│   │    CAPTION TEXT       │   │  ← Zone: y=80 to y=560
│   │    (2 lines max)      │   │    Height: ~480px
│   └──────────────────────┘   │
│                              │
│        40px gap              │
│                              │
│   ┌──────────────────────┐   │
│   │                      │   │
│   │                      │   │
│   │    DEVICE FRAME      │   │  ← Zone: y=600 to y=2716
│   │    (iPhone mockup)   │   │    Height: ~2116px
│   │                      │   │
│   │                      │   │
│   └──────────────────────┘   │
│        80px bottom padding   │
└──────────────────────────────┘

Caption zone: 17% of height
Device zone: 76% of height
Padding: 7% total
```

**Caption area:**
- X: 80px left/right margins (content width: 1130px)
- Y: 80px from top
- Height: 480px
- Alignment: Center horizontal, center vertical within zone

**Device frame:**
- Centered horizontally
- Device width: ~900px (70% of canvas)
- Bottom-aligned with 80px padding

### iPad (2064 x 2752 px)

```
┌──────────────────────────────────┐
│          80px top padding        │
│                                  │
│   ┌──────────────────────────┐   │
│   │      CAPTION TEXT        │   │  ← Zone: y=80 to y=520
│   │      (2 lines max)       │   │    Height: ~440px
│   └──────────────────────────┘   │
│                                  │
│          40px gap                │
│                                  │
│   ┌──────────────────────────┐   │
│   │                          │   │
│   │      DEVICE FRAME        │   │  ← Zone: y=560 to y=2672
│   │      (iPad mockup)       │   │    Height: ~2112px
│   │                          │   │
│   └──────────────────────────┘   │
│          80px bottom padding     │
└──────────────────────────────────┘

Caption zone: 16% of height
Device zone: 77% of height
```

**Device frame:**
- Centered horizontally
- Device width: ~1550px (75% of canvas)

### Mac (2880 x 1800 px)

```
┌────────────────────────────────────────────────┐
│                60px top padding                 │
│                                                 │
│   ┌─────────────────────────────────────────┐   │
│   │           CAPTION TEXT                  │   │  ← Zone: y=60 to y=360
│   │           (2 lines max)                 │   │    Height: ~300px
│   └─────────────────────────────────────────┘   │
│                                                 │
│                30px gap                         │
│                                                 │
│   ┌─────────────────────────────────────────┐   │
│   │                                         │   │
│   │         MAC WINDOW FRAME                │   │  ← Zone: y=390 to y=1740
│   │         (with title bar)                │   │    Height: ~1350px
│   │                                         │   │
│   └─────────────────────────────────────────┘   │
│                60px bottom padding              │
└────────────────────────────────────────────────┘

Caption zone: 17% of height
Device zone: 75% of height
```

**Window frame:**
- Centered horizontally
- Window width: ~2400px (83% of canvas)
- Include macOS title bar with traffic lights
- Optional: 3-5 degree perspective tilt

---

## Typography

| Element | Font | Weight | Size (iPhone) | Size (iPad) | Size (Mac) |
|---------|------|--------|--------------|-------------|------------|
| Caption line 1 | SF Pro Display | Bold | 84px | 96px | 72px |
| Caption line 2 | SF Pro Display | Bold | 84px | 96px | 72px |
| Line height | — | — | 1.15 | 1.15 | 1.15 |

- Color: #FFFFFF (white) on all backgrounds
- Alignment: Center
- Max lines: 2
- No text shadow, no outline, no gradient through text
- **Critical for OCR:** Clean, high-contrast, no decorative styling

---

## Color Palette (Backgrounds)

Alternating colors — no two adjacent screenshots share a color.
All from Stuffolio's colorblind-safe palette.

| Screenshot | Background Color | Hex | Gradient (optional) |
|-----------|-----------------|-----|-------------------|
| 1 | Blue | #007AFF | Top: #1A8FFF → Bottom: #0066DD |
| 2 | Purple | #AF52DE | Top: #BF6AEE → Bottom: #9A3CCE |
| 3 | Cyan | #32ADE6 | Top: #4CBDF6 → Bottom: #1A9DD6 |
| 4 | Orange | #FF9500 | Top: #FFA520 → Bottom: #E68500 |
| 5 | Pink | #FF2D55 | Top: #FF4D6F → Bottom: #E61A42 |
| 6 | Blue | #007AFF | Top: #1A8FFF → Bottom: #0066DD |
| 7 | Purple | #AF52DE | Top: #BF6AEE → Bottom: #9A3CCE |
| 8 | Cyan | #32ADE6 | Top: #4CBDF6 → Bottom: #1A9DD6 |
| 9 | Orange | #FF9500 | Top: #FFA520 → Bottom: #E68500 |
| 10 | Dark | #1C1C1E | Top: #2C2C2E → Bottom: #0C0C0E |

Gradient direction: Top to bottom, subtle (10-15% brightness shift)

---

## 10 Screenshots — Content Spec

### Screenshot 1: Track Everything You Own
- **Caption:** "Track Everything You Own"
- **Background:** Blue (#007AFF)
- **iPhone:** Dashboard showing Needs Attention card, Quick Actions, stat cards
- **iPad:** Dashboard in landscape split view
- **Mac:** Full sidebar + Dashboard detail panel
- **Show:** A populated dashboard with real-looking data (not empty state)

### Screenshot 2: AI Identifies Antiques Instantly
- **Caption:** "AI Identifies Antiques Instantly"
- **Background:** Purple (#AF52DE)
- **iPhone:** Stuff Scout results screen after photo scan — item identified with name, era, value range
- **iPad:** Stuff Scout with wider result layout
- **Mac:** Stuff Scout in window with detail panel
- **Show:** An identified antique/collectible with clear results (like the Virginia Rose platter from the website)

### Screenshot 3: Warranty Alerts Before You Lose Coverage
- **Caption:** "Warranty Alerts Before\nYou Lose Coverage"
- **Background:** Cyan (#32ADE6)
- **iPhone:** Warranty detail showing phase timeline (Full → Parts Only → Expired) with alert badge
- **iPad:** Warranty timeline in wider format
- **Mac:** Warranty detail in sidebar layout
- **Show:** A warranty mid-lifecycle with "Coverage changes in 30 days" alert visible

### Screenshot 4: Find Manuals, Parts & Repairs
- **Caption:** "Find Manuals, Parts & Repairs"
- **Background:** Orange (#FF9500)
- **iPhone:** AI Assistant results showing manual PDF links, parts sources, repair video links
- **iPad:** Results in two-column layout
- **Mac:** Results in full window
- **Show:** Real-looking results for a common appliance (dishwasher, refrigerator)

### Screenshot 5: Plan Who Gets Your Belongings
- **Caption:** "Plan Who Gets\nYour Belongings"
- **Background:** Pink (#FF2D55)
- **iPhone:** Legacy Wishes list showing items with assigned family members
- **iPad:** Legacy Wishes in split view
- **Mac:** Legacy Wishes with sidebar navigation
- **Show:** 3-4 items with different recipients, clear visual hierarchy

### Screenshot 6: Export Insurance Claims in Seconds
- **Caption:** "Export Insurance Claims\nin Seconds"
- **Background:** Blue (#007AFF)
- **iPhone:** Export preview showing PDF with photos, values, serial numbers
- **iPad:** Export preview in landscape
- **Mac:** Export dialog with format options visible
- **Show:** A professional-looking export with item photos and dollar values

### Screenshot 7: Monitor Prices & Replacement Costs
- **Caption:** "Monitor Prices &\nReplacement Costs"
- **Background:** Purple (#AF52DE)
- **iPhone:** Price Watch with price history chart and retailer comparison
- **iPad:** Price Watch with wider chart
- **Mac:** Price Watch in full window with chart detail
- **Show:** A chart showing price trend over time, current price from multiple retailers

### Screenshot 8: Share Your Home Inventory with Family
- **Caption:** "Share Your Home Inventory\nwith Family"
- **Background:** Cyan (#32ADE6)
- **iPhone:** Household sharing screen showing family member avatars with permission levels
- **iPad:** Sharing in split view with member list
- **Mac:** Sharing in sidebar with member detail
- **Show:** 2-3 family members with clear roles (Owner, Editor, Viewer)

### Screenshot 9: Scan Barcodes, Add with Voice
- **Caption:** "Scan Barcodes,\nAdd with Voice"
- **Background:** Orange (#FF9500)
- **iPhone:** Split showing barcode scanner viewfinder + voice input waveform
- **iPad:** Scanner in camera view with results
- **Mac (different caption):** "Add Items Fast —\nVoice, Paste, or Import"
- **Show:** Active scanning state or voice input with recognized text

### Screenshot 10: Private by Default. No Account Needed.
- **Caption:** "Private by Default.\nNo Account Needed."
- **Background:** Dark (#1C1C1E)
- **iPhone:** Privacy settings screen or onboarding showing opt-in toggles
- **iPad:** Privacy settings
- **Mac:** Privacy preferences pane
- **Show:** Clear toggle states — everything off by default, user in control

---

## Device Frame Specs

### iPhone Frame
- Use iPhone 15 Pro Max or iPhone 16 Pro Max frame
- Color: Natural Titanium (neutral, doesn't clash with backgrounds)
- Show status bar with realistic time, signal, battery
- Corner radius matches device exactly

### iPad Frame
- Use iPad Pro 13" (M4) frame
- Color: Space Black or Silver
- Show status bar

### Mac Frame
- Use MacBook Pro 16" frame OR just a macOS window chrome
- If using laptop frame: slight perspective tilt (3-5°) adds depth
- If using window only: include title bar with traffic light buttons (red/yellow/green)
- Show realistic menu bar

---

## Figma Component Structure

```
Page: iPhone Screenshots
  └── Frame: "iPhone_01_Dashboard" (1290x2796)
       ├── Rectangle: Background (fill: #007AFF gradient)
       ├── Text: Caption ("Track Everything You Own")
       └── Component: iPhone_Frame
            └── Image: screenshot_01_dashboard.png

Page: iPad Screenshots
  └── Frame: "iPad_01_Dashboard" (2064x2752)
       ├── Rectangle: Background
       ├── Text: Caption
       └── Component: iPad_Frame
            └── Image: screenshot_01_dashboard_ipad.png

Page: Mac Screenshots
  └── Frame: "Mac_01_Dashboard" (2880x1800)
       ├── Rectangle: Background
       ├── Text: Caption
       └── Component: Mac_Window
            └── Image: screenshot_01_dashboard_mac.png
```

### Recommended Figma Components to Create
1. **Caption Text** — auto-layout text component with font/size/color set
2. **iPhone Frame** — with image placeholder
3. **iPad Frame** — with image placeholder
4. **Mac Window** — with title bar and image placeholder
5. **Background** — rectangle with gradient fill, swappable color

### Figma Auto Layout
- Each screenshot frame: Vertical auto layout
- Padding: 80px (iPhone/iPad), 60px (Mac)
- Gap between caption and device: 40px (iPhone/iPad), 30px (Mac)
- Caption: Center aligned, hug content
- Device: Center aligned, fill width with max constraint

---

## Export Checklist

- [ ] 10 iPhone screenshots at 1290x2796 px (PNG)
- [ ] 10 iPad screenshots at 2064x2752 px (PNG)
- [ ] 10 Mac screenshots at 2880x1800 px (PNG)
- [ ] All PNG, 72 DPI, sRGB, fully opaque
- [ ] Each file under 10 MB
- [ ] Captions readable at actual phone size (test on device)
- [ ] No adjacent screenshots share the same background color
- [ ] Mac screenshot #9 uses alternate caption ("Add Items Fast...")
- [ ] Device frames show realistic status bars
- [ ] All screenshots use actual app UI (not mockups or renders)

---

## OCR Readability Checklist

- [ ] Font is SF Pro Display Bold (or similar clean sans-serif)
- [ ] Text is white (#FFFFFF) on colored backgrounds
- [ ] No text shadow, outline, or gradient through letters
- [ ] Minimum font size: 72px (iPhone), 96px (iPad), 60px (Mac)
- [ ] Text positioned in top 20% of image
- [ ] No text overlapping device frame
- [ ] High contrast ratio (white on medium-dark backgrounds)
- [ ] Test: Can a human read the caption on an actual phone screen in search results?

---

## Naming Convention

```
stuffolio_iphone_01_dashboard.png
stuffolio_iphone_02_stuff_scout.png
stuffolio_iphone_03_warranty.png
stuffolio_iphone_04_manuals.png
stuffolio_iphone_05_legacy.png
stuffolio_iphone_06_export.png
stuffolio_iphone_07_price_watch.png
stuffolio_iphone_08_sharing.png
stuffolio_iphone_09_barcode_voice.png
stuffolio_iphone_10_privacy.png

stuffolio_ipad_01_dashboard.png
... (same pattern)

stuffolio_mac_01_dashboard.png
... (same pattern)
```
