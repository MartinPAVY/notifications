import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final bool autoDismissEnabled;
  final int dismissDurationMinutes;

  SettingsState({
    required this.autoDismissEnabled,
    required this.dismissDurationMinutes,
  });

  SettingsState copyWith({
    bool? autoDismissEnabled,
    int? dismissDurationMinutes,
  }) {
    return SettingsState(
      autoDismissEnabled: autoDismissEnabled ?? this.autoDismissEnabled,
      dismissDurationMinutes:
          dismissDurationMinutes ?? this.dismissDurationMinutes,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  static const String _keyAutoDismiss = 'auto_dismiss_enabled';
  static const String _keyDismissDuration = 'dismiss_duration_minutes';

  @override
  SettingsState build() {
    // We start with default values and load from prefs asynchronously
    _loadSettings();
    return SettingsState(autoDismissEnabled: true, dismissDurationMinutes: 5);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final autoDismiss = prefs.getBool(_keyAutoDismiss) ?? true;
    final duration = prefs.getInt(_keyDismissDuration) ?? 5;
    state = SettingsState(
      autoDismissEnabled: autoDismiss,
      dismissDurationMinutes: duration,
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
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(() {
  return SettingsNotifier();
});
