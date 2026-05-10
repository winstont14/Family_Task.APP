# Flutter App Scaffold Skill

## What this skill does

Creates a complete Flutter app from a markdown specification file, without requiring Flutter to be installed on the host machine. All Dart source files and `pubspec.yaml` are written directly; platform directories (android/, ios/, web/) are left for `flutter create .` to generate.

## When to use

- User provides a `.md` spec describing a Flutter app structure, features, and tech stack.
- Flutter CLI is unavailable in the current environment.
- User wants the full source scaffold created immediately.

## Steps this skill follows

1. **Read the spec file** — extract tech stack, folder structure, dependencies, color tokens, and feature list.
2. **Create the log file** (`build_log.md`) — document environment findings and architecture decisions *before* writing code.
3. **Create directories** — all `lib/` subdirectories in one `mkdir -p` call.
4. **Write source files in dependency order:**
   - `pubspec.yaml`
   - `lib/core/theme/colors.dart` → `app_theme.dart`
   - `lib/core/utils/constants.dart`
   - `lib/models/todo_model.dart` + pre-generated `.g.dart` adapter
   - `lib/services/` → `lib/providers/` → `lib/widgets/` → `lib/screens/`
   - `lib/main.dart` (last, after all imports exist)
5. **Write `CLAUDE.md`** — commands, architecture table, Hive notes, design tokens.
6. **Write `skill.md`** — this file.
7. **Save memory** — record project context and user preferences.

## Key decisions to document in build_log.md

- Why Flutter CLI is not used (if absent)
- ID generation strategy (uuid package vs timestamp)
- Navigation pattern (BottomSheet vs push route)
- Whether to pre-generate Hive adapters or rely on build_runner
- Any dependencies added beyond the spec (e.g. `intl` for date formatting)

## Template: pre-generated Hive adapter

When `build_runner` cannot be run, write `todo_model.g.dart` manually using this pattern:

```dart
class TodoAdapter extends TypeAdapter<Todo> {
  @override final int typeId = 0;

  @override
  Todo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Todo(
      id: fields[0] as String,
      title: fields[1] as String,
      isDone: fields[2] as bool,
      createdAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Todo obj) {
    writer
      ..writeByte(4)   // number of fields
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.title)
      ..writeByte(2)..write(obj.isDone)
      ..writeByte(3)..write(obj.createdAt);
  }
}
```

## Instructions the user needs after scaffolding

```bash
brew install --cask flutter          # macOS install
flutter create . --project-name todo_app --org com.example
flutter pub get
flutter run
```

---

## Skill: Feature Expansion from Requirements Doc (v2.0.0)

### What this skill does

Extends an existing Flutter app by reading a requirements document and implementing new features on top of the existing architecture — without breaking backward compatibility.

### When to use

- User provides a requirements `.md` describing new features to add.
- Existing Hive models need new fields (backward-compat migration).
- New Hive models/boxes are needed alongside existing ones.

### Steps this skill follows

1. **Read all existing source files** — understand current architecture before touching anything.
2. **Read the requirements doc** — extract new models, providers, UI flows, and data relationships.
3. **Plan changes** — separate new files from modified files, identify backward-compat risks (Hive adapter field counts).
4. **Write new files first** (models, services, providers, widgets) — no existing code broken yet.
5. **Update Hive adapters manually** — increment field count in `writeByte(N)`, add new fields to `read` and `write`; old records with fewer fields are safe because the field-map lookup returns null for missing keys.
6. **Update providers** — add new optional parameters, add filtered list getters.
7. **Update UI files** — extend existing screens/widgets to use new providers and display new data.
8. **Update `main.dart`** — register new adapters, open new boxes, add providers to MultiProvider.
9. **Update `build_log.md`** — add a dated section documenting all file changes and decisions.
10. **Update `skill.md`** — add pattern description so future runs can follow the same process.

### Template: manually extending a Hive adapter

When adding `@HiveField(N) SomeType? newField` to an existing model:

```dart
// In model file: add the field + constructor param (nullable, with default)
@HiveField(N)
SomeType? newField;

// In .g.dart: increment the field count and add read/write entries
Todo read(...) {
  return Todo(
    ...existingFields,
    newField: fields[N] as SomeType?,  // null-safe — old records return null
  );
}

void write(...) {
  writer
    ..writeByte(N + 1)   // was N, now N+1 fields
    ...existingWrites
    ..writeByte(N)
    ..write(obj.newField);
}
```

### Template: member color palette

```dart
const List<int> kMemberColorValues = [
  0xFF5B8DEF, 0xFFAB86E8, 0xFF52C78B,
  0xFFFF9460, 0xFFFF7BAC, 0xFF4ECDC4,
];

int colorValueForMember(String id) {
  final idx = _members.indexWhere((m) => m.id == id);
  return kMemberColorValues[idx < 0 ? 0 : idx % kMemberColorValues.length];
}
```
