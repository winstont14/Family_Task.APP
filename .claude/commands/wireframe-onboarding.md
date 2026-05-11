Update `lib/screens/auth/login_screen.dart` to match the wireframe onboarding spec in `WireFrame/Family_task/sections/onboarding.jsx`.

Rules:
- V2 style for `_AdminSetupScreen` (first run, no admin)
- V6 style for `LoginScreen` (profile picker)
- Mock any UI sections whose function does not exist yet — show the widget visually but add no logic
- Do NOT add new providers, services, or state — visual layer only
- Run `flutter analyze lib/screens/auth/login_screen.dart` after editing and fix all issues before finishing

V2 key elements (admin setup):
- Headline "Create workspace" (22 px bold) + caption "all in one place" (10 px, letter-spaced)
- Thin-stroke inputs (1.2 px solid ink-soft border, 10 px radius, white fill): Family name · Your name (Admin) · PIN optional
- Mock "add children" section: wf-cap label + chip row (2 example child chips + dashed "+ add another" chip) — no onTap, static display
- Full-width "Create →" button (accent fill, 12 px radius, 54 px tall)

V6 key elements (profile picker):
- Centered "Who's using this?" (26 px bold) + "this device is shared" caption
- 2-column GridView, childAspectRatio 0.85, gap 12
- Member cards: 1.6 px solid ink border (18 % opacity), 12 px radius, 56 px tone-colored avatar, name, role pill
- Accent-fill pill + 🔒 in label when member has PIN and role is admin/parent
- Last grid cell: dashed border card (`_DashedRoundedBorderPainter`) showing "+" and "add" — visual only
- Footer "parent · 4-digit PIN" centered

Design tokens to use:
- ink: #1f1f1f · ink-soft: #4a4a4a · ink-faint/caption: #8a8a8a
- paper bg: #FBFAF6 · accent: #5B8DEF
- Avatar bg tones (by member index % 6): #D4E4FC · #DCD0F0 · #C9E4CA · #F6CFB8 · #FFD6E8 · #B2F0ED
