import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final bool autoDismissEnabled;
  final int dismissDurationMinutes;
  final String selectedNotificationId;

  SettingsState({
    required this.autoDismissEnabled,
    required this.dismissDurationMinutes,
    required this.selectedNotificationId,
  });

  SettingsState copyWith({
    bool? autoDismissEnabled,
    int? dismissDurationMinutes,
    String? selectedNotificationId,
  }) {
    return SettingsState(
      autoDismissEnabled: autoDismissEnabled ?? this.autoDismissEnabled,
      dismissDurationMinutes:
          dismissDurationMinutes ?? this.dismissDurationMinutes,
      selectedNotificationId:
          selectedNotificationId ?? this.selectedNotificationId,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  static const String _keyAutoDismiss = 'auto_dismiss_enabled';
  static const String _keyDismissDuration = 'dismiss_duration_minutes';
  static const String _keySelectedNotification = 'selected_notification_id';

  @override
  SettingsState build() {
    // We start with default values and load from prefs asynchronously
    _loadSettings();
    return SettingsState(
      autoDismissEnabled: true,
      dismissDurationMinutes: 5,
      selectedNotificationId: 'defaut',
    );
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final autoDismiss = prefs.getBool(_keyAutoDismiss) ?? true;
    final duration = prefs.getInt(_keyDismissDuration) ?? 5;
    final selectedId = prefs.getString(_keySelectedNotification) ?? 'defaut';
    state = SettingsState(
      autoDismissEnabled: autoDismiss,
      dismissDurationMinutes: duration,
      selectedNotificationId: selectedId,
    );
  }

  Future<void> setAutoDismissEnabled(bool enabled) async {
    state = state.copyWith(autoDismissEnabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAutoDismiss, enabled);
  }

  Future<void> setDismissDurationMinutes(int minutes) async {
    state = state.copyWith(dismissDurationMinutes: minutes);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyDismissDuration, minutes);
  }

  Future<void> setSelectedNotificationId(String id) async {
    state = state.copyWith(selectedNotificationId: id);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySelectedNotification, id);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(() {
  return SettingsNotifier();
});
