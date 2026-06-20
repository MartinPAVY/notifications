# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Notify Me** is a Flutter mobile app for triggering local notifications on iOS and Android. It supports two compile-time variants with different notification configurations, and was built for personal/family notification testing.

## Commands

### Running the App
```bash
# Run variant 1 (4 fixed boolean/state notifications)
./scripts/run_notify_1.sh

# Run variant 2 (2 customizable text notifications)
./scripts/run_notify_2.sh

# Manual run with dart-define flags
flutter run --dart-define=APP_VARIANT=1 --dart-define=APP_TITLE="My Title"
```

### Building APKs
```bash
# Build both variants at once
./build_apps.sh

# Build individual variants
./scripts/build_notify_1.sh
./scripts/build_notify_2.sh
```

### Development
```bash
flutter pub get          # Install dependencies
flutter analyze          # Run Dart analyzer
flutter test             # Run tests

# Regenerate Freezed/JSON models after model changes
dart run build_runner build --delete-conflicting-outputs
```

## Architecture

### Variant System
The app has two compile-time variants controlled by `--dart-define=APP_VARIANT=1|2`:
- **Variant 1**: 4 fixed notifications (Vrai/Faux, Activé/Désactivé themes)
- **Variant 2**: 2 user-customizable text notifications (editable in settings)

`lib/src/app_config.dart` is the central place where variants are resolved. `getDynamicNotifications()` merges static and user-customized notifications at runtime.

### State Management (Riverpod)
Settings are managed via `SettingsNotifier` in `lib/src/providers/settings_provider.dart`. State is persisted automatically to `SharedPreferences` after each setter call. The `SettingsState` uses a manual `copyWith` pattern (not Freezed) for clarity.

### Data Models (Freezed)
`NotificationModel` and `NotificationsModel` in `lib/models/notifications/` are Freezed immutable models. The `.freezed.dart` and `.g.dart` files are generated — don't edit them manually.

### Key Libraries
- **Routing**: GoRouter with two routes: `/` (home) and `/settings`
- **Notifications**: `flutter_local_notifications` — platform-specific init in `main.dart`
- **Quick Actions**: Home screen shortcuts (4 for variant 1, 2 for variant 2), defined in `home.page.dart`
- **Permissions**: Requested on home page init via `permission_handler`

### UI
Dark Material 3 theme with seed color `#8DAAFA`. Pages are `ConsumerStatefulWidget` (Riverpod). The main interaction flow: select a notification card → tap send → notification fires and optionally auto-dismisses.
