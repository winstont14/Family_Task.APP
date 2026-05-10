# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Setup (Flutter not yet installed)

Install Flutter, then from this directory:

```bash
# 1. Generate Android/iOS/Web platform scaffolding
flutter create . --project-name todo_app --org com.example

# 2. Fetch dependencies
flutter pub get

# 3. Run the app
flutter run

# Run on a specific device
flutter run -d chrome      # Web
flutter run -d ios         # iOS Simulator
flutter run -d android     # Android Emulator
```

## Common Commands

```bash
# Analyze for lint/type errors
flutter analyze

# Run tests
flutter test

# Run a single test file
flutter test test/widget_test.dart

# Regenerate Hive adapters (after changing todo_model.dart fields)
dart run build_runner build --delete-conflicting-outputs

# Hot reload / hot restart are available in the running flutter process (r / R keys)
```

## Architecture

**Data flow:** `UI → Provider → Service → Hive / Claude API`

- UI widgets read state via `context.watch<TodoProvider>()` / `context.watch<ClaudeProvider>()`.
- Mutations go through `context.read<...>()` methods — never call services from the UI directly.
- `LocalStorageService` is a thin wrapper around the Hive `todos` box.
- `ClaudeService` makes raw HTTP calls to `POST https://api.anthropic.com/v1/messages` (no official Dart SDK; uses `http` package).

### Key layers

| Layer | Path | Role |
|-------|------|------|
| Theme | `lib/core/theme/` | Colors (`AppColors`) and `ThemeData` (`AppTheme`) |
| Model | `lib/models/todo_model.dart` | Hive-annotated `Todo` entity. Pre-generated adapter in `.g.dart`. |
| Service | `lib/services/local_storage_service.dart` | CRUD on the Hive `todos` box |
| Service | `lib/services/claude_service.dart` | Claude API HTTP client; `parseTask()` + `suggestTasks()` |
| Provider | `lib/providers/todo_provider.dart` | `ChangeNotifier`; owns in-memory list and calls LocalStorageService |
| Provider | `lib/providers/claude_provider.dart` | Manages API key (persisted in `settings` Hive box), loading state, and suggestions |
| Screens | `lib/screens/` | `HomeScreen` (main), `AddTodoScreen` (bottom sheet for add/edit) |
| Widgets | `lib/widgets/` | `TodoCard`, `EmptyState`, `AddButton`, `SectionTitle` |

### TodoCard interactions
- **Tap checkbox** → `toggleTodo`
- **Long press / edit icon** → opens `AddTodoScreen` with `existingTodo` set
- **Swipe left** → `Dismissible` calls `deleteTodo`

## Hive Notes

- Boxes: `"todos"` (Todo entities), `"settings"` (API key and future prefs). Both constants in `constants.dart`.
- Adapter typeId: `0` (defined in `todo_model.g.dart`)
- `todo_model.g.dart` is pre-generated — do **not** delete it. Re-run `build_runner` only when you change `@HiveField` annotations.
- Both boxes are opened in `main()` before `runApp`; always available when widgets build.

## Claude AI Integration

- API key stored in Hive `settings` box under key `"claudeApiKey"`.
- User enters the key via the brain icon (⚙ `_ApiKeySheet`) in the home header.
- `ClaudeService` model: `claude-opus-4-7`, `max_tokens: 512`, no streaming (short responses).
- **Parse feature**: In `AddTodoScreen`, the ✦ button sends the typed text to Claude and back-fills title + due date.
- **Suggestions feature**: In `HomeScreen`, tapping ↻ requests 4 task ideas based on existing tasks. Tapping a chip adds it immediately.
- API key is never logged or sent anywhere besides `api.anthropic.com`.

## Design System

Colors are in `AppColors` (`lib/core/theme/colors.dart`):

| Token | Hex |
|-------|-----|
| primary | `#5B8DEF` |
| background | `#F5F7FB` |
| card | `#FFFFFF` |
| done | `#B8D8BA` |
| text | `#222222` |
| subtitle | `#777777` |

Text sizes: titles 28px, task text 20px, button labels 18px. Min touch area: 48×48px.
