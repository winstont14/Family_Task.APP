# Flutter Family Task App Structure

## Project Goal
Build a simple family task management application inspired by the clean and minimal design of Notion.

The application should help parents assign simple daily tasks to children while allowing children to report completed work back to parents.

The UI should be:
- Extremely simple and minimal
- Easy for children to understand
- Calm and modern like Notion
- Large readable text
- Large touch-friendly buttons
- Clean workspace layout
- Soft colors and low visual clutter
- Easy for parents to manage

---

# App Features

## Core Features
- Create family workspace
- Parent creates tasks/jobs
- Assign tasks to children
- Child marks task as completed
- Child sends report back to parent
- Parent views completed tasks
- Simple reward/progress tracking
- Save data locally

---

# UI Design Principles

## Accessibility First

### Large Text
- Titles: 28px
- Task text: 20px
- Button text: 18px

### Large Touch Areas
Minimum button size:
- 48x48

### Simple Navigation
- One main screen
- No nested menus
- Clear labels and icons

### Soft and Comfortable Colors
Recommended colors:

```dart
Primary: #5B8DEF
Background: #F5F7FB
Card: #FFFFFF
Done: #B8D8BA
Text: #222222
Subtitle: #777777
```

---

# Recommended Tech Stack

## Main Framework
- Flutter

## Language
- Dart

## State Management
- Provider

## Local Database
- Hive

## Font
- Google Fonts (Poppins)

---

# Folder Structure

```txt
lib/
│
├── main.dart
│
├── core/
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── colors.dart
│   │
│   └── utils/
│       └── constants.dart
│
├── models/
│   └── todo_model.dart
│
├── screens/
│   ├── home/
│   │   └── home_screen.dart
│   │
│   └── add_todo/
│       └── add_todo_screen.dart
│
├── widgets/
│   ├── todo_card.dart
│   ├── empty_state.dart
│   ├── add_button.dart
│   └── section_title.dart
│
├── services/
│   └── local_storage_service.dart
│
└── providers/
    └── todo_provider.dart
```

---

# pubspec.yaml Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  provider: ^6.1.2
  google_fonts: ^6.2.1
  hive: ^2.2.3
  hive_flutter: ^1.1.0
```

---

# Main Screen Layout

```txt
--------------------------------
Family Workspace 👨‍👩‍👧‍👦

Good Morning, Alex 👋

Today's Tasks
-----------------
[ ] Clean your room
[ ] Feed the cat
[✓] Finish homework

[ + Add Task ]

Completed Today
-----------------
[✓] Water the plants

Progress ⭐
3 / 4 tasks completed
--------------------------------
```

--------------------------------
Hello 👋
What do you want to do today?

[ + Add Task ]

TODAY
-----------------
[ ] Buy milk
[✓] Call mom
[ ] Drink water

COMPLETED
-----------------
[✓] Morning walk
--------------------------------
```

---

# Recommended Widgets

## Main Widgets
- Scaffold
- AppBar
- ListView
- Card
- TextField
- Checkbox
- FloatingActionButton
- Dismissible

---

# Todo Data Model

```dart
class Todo {
  String id;
  String title;
  bool isDone;
  DateTime createdAt;

  Todo({
    required this.id,
    required this.title,
    this.isDone = false,
    required this.createdAt,
  });
}
```

---

# Suggested Widget Structure

## Family Workspace Card

Displays:
- Family name
- Members
- Today's progress

---

## Task Card

Features:
- Large checkbox
- Large readable title
- Assigned child avatar
- Simple completion status
- Tap to complete
- Parent approval status

Example:

```txt
--------------------------------
☐ Feed the cat
Assigned to: Emma

Due Today
--------------------------------
```

--------------------------------
☐ Buy medicine

Today 6:00 PM
--------------------------------
```

---

# Theme Example

```dart
ThemeData(
  scaffoldBackgroundColor: Color(0xFFF5F7FB),
  useMaterial3: true,
)
```

---

# State Management Flow

```txt
UI
↓
Provider
↓
Service
↓
Local Storage
```

---

# Development Roadmap

## Step 1
Create static UI

## Step 2
Add task functionality

## Step 3
Complete task functionality

## Step 4
Delete task functionality

## Step 5
Save tasks locally

## Step 6
Improve animations and accessibility

---

# Future Improvements

## Version 2 Ideas
- Reward system
- Stars and badges
- Weekly goals
- Voice task input
- Notifications
- Shared family calendar
- AI-generated chore suggestions
- Cloud sync

---

# Best First Goal

Your first successful version should allow:

- Parent creates workspace
- Parent adds task
- Parent assigns task to child
- Child marks task as completed
- Parent sees completion update

If these five features work, you already built a functional family productivity app.

---

# Design Inspiration

Inspired by:
- Notion
- Apple Reminders
- Google Tasks

Design style:
- Minimal cards
- Rounded corners
- Soft shadows
- Neutral colors
- Large spacing
- Calm and distraction-free UI

Recommended UI style:
- White background
- Light gray sections
- Soft blue accent color
- Rounded cards
- Minimal icons
- Simple typography

