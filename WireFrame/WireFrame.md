# Wireframe — Onboarding Section Requirements

Source files: `WireFrame/Family_task/screens-onboarding.jsx` · `WireFrame/Family_task/sections/onboarding.jsx`

---

## Design Tokens

| Token | Value | Usage |
|---|---|---|
| `--accent` | `#5B8DEF` | Primary blue — buttons, active states |
| `--ink` | `#1f1f1f` | Main text |
| `--ink-soft` | `#4a4a4a` | Secondary text |
| `--ink-faint` | `#8a8a8a` | Hints, captions |
| `--paper` | `#fbfaf6` | Screen background |
| `--done` | `#B8D8BA` | Completion green |
| Avatar tones | peach `#F6CFB8` · mint `#C9E4CA` · lilac `#DCD0F0` · lemon `#F4E3A1` | Per-member colors |

**Typography:** Caveat (headings, handwritten feel) · Patrick Hand / Kalam (body) · Architects Daughter (captions/labels)

**Stroke primitives:**
- `.wf-stroke` — 1.6px solid border, 12px radius (primary container)
- `.wf-stroke-thin` — 1.2px solid, 10px radius (inputs, chips)
- `.wf-stroke-dashed` — 1.4px dashed (empty / add placeholders)
- `.wf-fill-accent` — accent blue fill (primary buttons)

---

## Onboarding Variations (6 total)

All variations share: StatusBar at top (phone), Back/Next navigation, same token set.

---

### V1 — Step-by-Step Wizard (3 steps)
**Style:** Conventional linear stepper · safe · single-task focus

**Phone:**
- Progress dots at top (3 dots, first 2 filled = step 2 of 3)
- Large headline: `"Name your family"` (30px Caveat)
- Caption: `"Step 2 of 3"`
- Text field showing family name with ✏️
- Large family icon/emoji picker (`🏠`) centered below field
- Caption: `"tap to pick an icon"`
- Footer: `[Back]` + `[Next →]` (primary) side by side, full width

**Tablet (split layout):**
- Left panel: vertical step list — `1. Welcome` · `2. Family` (bold/active) · `3. Members` (faint)
- Right panel: same form at larger scale (34px headline, 18px field text)
- Icon picker shows 4 emoji options in a row
- Footer right-aligned: `[Back]` + `[Continue →]`

---

### V2 — Single-Page Form (all-in-one)
**Style:** Notion-y · power-user · everything visible · no wizard

**Phone:**
- Headline: `"Welcome 👋"` (26px)
- Caption: `"Set up your family in one go"`
- Section **Family name**: thin-stroke text input
- Section **Members**: chip row — filled chips for each member + dashed `+ add` chip
- Spacer pushes button to bottom
- Full-width primary button: `"Create family →"`

**Tablet:**
- Headline: `"Welcome 👋"` (38px)
- Caption: `"One screen, that's it. Set up your family."`
- Two-column grid:
  - Left: Family name field
  - Right: Icon picker (4 emoji in a row, first highlighted)
- Full-width Members section: chip row (member chips + `+ add member`)
- Footer right-aligned: `[Create family →]`

---

### V3 — Pick Your People (visual avatar grid)
**Style:** Playful · kid-friendly · illustrated

**Phone:**
- Centered headline: `"Who's in your family?"` (large)
- Placeholder illustration area (120px tall image slot)
- Emoji avatar grid (6 options: 👩 👨 🧒 👧 👶 🐶 in circle strokes)
- Caption: `"tap to add — long-press to remove"`
- Full-width primary button: `"Begin →"`

**Tablet:**
- Left column: Hero illustration (full height, `"family hugging"`)
- Right column:
  - Caption: `"tap a portrait to add"`
  - 4-column emoji grid (12 emojis in circle cells)
  - Caption: `"selected"` + row of chosen member avatars
- Footer right-aligned: `[Looks good →]`

---

### V4 — Conversational Chat-Style
**Style:** Gentle · low-effort · narrative setup bot

**Phone:**
- Caption: `"setup chat"`
- Scrollable chat thread:
  - Bot bubble (left-aligned, light blue bg): `"Hi! What should we call your family?"`
  - User bubble (right-aligned, accent blue): `"The Patels ✨"`
  - Bot: `"Lovely. How many kids?"`
  - User: `"Two"`
  - Bot: `"Tell me their names…"`
- Bottom bar: text input `"Type a reply…"` + circular accent send button `↑`

**Tablet:**
- Row header: `"Setup, the easy way"` + `[skip]` pill
- Caption: `"we'll ask, you answer"`
- Extended chat thread with emoji picker appearing inline after member name
- Bottom bar: `"Type a reply…"` + `[send]` primary button

---

### V5 — Family Postcard (sticker-book metaphor)
**Style:** Novel · keepsake feel · emotional

**Phone:**
- Headline: `"Your family postcard"`
- Large stroke container (flex-1 height) showing the postcard:
  - Top-left: large avatar (peach) + family name + `"est. today"`
  - Member avatar chips + dashed `+ add`
  - Dashed inner area: `"drag stickers here →"`
  - Row of sticker emojis: 🌟 🏠 🐾 🎈 🌈 ☀
- Full-width primary button: `"Send postcard →"`

**Tablet:**
- Postcard area rotated `rotate(-1deg)` for skeuomorphic feel
- Sticker picker grid (3×3) on the right side
- Footer: `[Pin to fridge →]`

---

### V6 — Profile Picker (shared-device first run)
**Style:** Practical · who-am-I launcher · PIN for parents

**Phone:**
- Centered headline: `"Who's using this?"`
- Caption: `"this device is shared"`
- 2×2 grid of member cards (stroke border, 12px radius):
  - Each card: XL avatar (56px) + name + role pill
  - Admin/Parent cards show `🔒` pill with accent color
  - Last cell: dashed border, `+` large, `"add"` caption
- Footer caption: `"parent · 4-digit PIN"`

**Tablet:**
- Centered headline: `"Hi, Patels 👋"` (34px)
- Caption: `"tap your face to begin · parent enters PIN"`
- 4-column grid (one card per member, larger padding 14px)
- Each card: XL avatar + name (Caveat 20px) + role pill (accent fill for PIN holders)
- Footer row: `[+ add member]` left · `"tap to switch · auto-lock 15 min"` right caption

---

## Recommended Variation for This App

**V2 (admin setup) + V6 (profile picker login)** — already implemented.

| Screen | Variation | When shown |
|---|---|---|
| First run (no admin) | V2 — Single-page form | `!family.hasAdmin` |
| Return visit | V6 — Profile picker | `family.hasAdmin && !auth.isLoggedIn` |

---

## Component Spec Reference

| Component | Size | Notes |
|---|---|---|
| Avatar | 26px (default) · 40px (lg) · 56px (xl) | Circular, per-member tone color |
| Pill | auto height, 999px radius | Outlined (default) · accent fill · done fill · faint |
| Btn (primary) | 10–14px padding | Accent fill, white text |
| Btn (secondary) | same padding | White fill, ink border |
| Input field | 8–18px padding | `.wf-stroke-thin` border, faint hint text |
| Progress dots | 8px circles | Filled = completed step, empty = future step |
| Member chip | 5–8px padding | Avatar + name, thin stroke, chip shape |
