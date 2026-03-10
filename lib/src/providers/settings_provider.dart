import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final bool autoDismissEnabled;
  final int dismissDurationMinutes;
  final String selectedNotificationId;
  final String defaultTitle;
  final String defaultSubtitle;
  final String defaultBody;

  SettingsState({
    required this.autoDismissEnabled,
    required this.dismissDurationMinutes,
    required this.selectedNotificationId,
    required this.defaultTitle,
    required this.defaultSubtitle,
    required this.defaultBody,
  });

  SettingsState copyWith({
    bool? autoDismissEnabled,
    int? dismissDurationMinutes,
    String? selectedNotificationId,
    String? defaultTitle,
    String? defaultSubtitle,
    String? defaultBody,
  }) {
    return SettingsState(
      autoDismissEnabled: autoDismissEnabled ?? this.autoDismissEnabled,
      dismissDurationMinutes:
          dismissDurationMinutes ?? this.dismissDurationMinutes,
      selectedNotificationId:
          selectedNotificationId ?? this.selectedNotificationId,
      defaultTitle: defaultTitle ?? this.defaultTitle,
      defaultSubtitle: defaultSubtitle ?? this.defaultSubtitle,
      defaultBody: defaultBody ?? this.defaultBody,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  static const String _keyAutoDismiss = 'auto_dismiss_enabled';
  static const String _keyDismissDuration = 'dismiss_duration_minutes';
  static const String _keySelectedNotification = 'selected_notification_id';
  static const String _keyDefaultTitle = 'default_title';
  static const String _keyDefaultSubtitle = 'default_subtitle';
  static const String _keyDefaultBody = 'default_body';

  @override
  SettingsState build() {
    // We start with default values and load from prefs asynchronously
    _loadSettings();
    return SettingsState(
      autoDismissEnabled: true,
      dismissDurationMinutes: 5,
      selectedNotificationId: 'defaut',
      defaultTitle: 'Notify Défaut',
      defaultSubtitle: 'Notification Texte',
      defaultBody: 'Non défini',
    );
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final autoDismiss = prefs.getBool(_keyAutoDismiss) ?? true;
    final duration = prefs.getInt(_keyDismissDuration) ?? 5;
    final selectedId = prefs.getString(_keySelectedNotification) ?? 'defaut';
    final title = prefs.getString(_keyDefaultTitle) ?? 'Notify Défaut';
    final subtitle =
        prefs.getString(_keyDefaultSubtitle) ?? 'Notification Texte';
    final body = prefs.getString(_keyDefaultBody) ?? 'Non défini';

    state = SettingsState(
      autoDismissEnabled: autoDismiss,
      dismissDurationMinutes: duration,
      selectedNotificationId: selectedId,
      defaultTitle: title,
      defaultSubtitle: subtitle,
      defaultBody: body,
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

  Future<void> setDefaultTitle(String title) async {
    state = state.copyWith(defaultTitle: title);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDefaultTitle, title);
  }

  Future<void> setDefaultSubtitle(String subtitle) async {
    state = state.copyWith(defaultSubtitle: subtitle);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDefaultSubtitle, subtitle);
  }

  Future<void> setDefaultBody(String body) async {
    state = state.copyWith(defaultBody: body);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDefaultBody, body);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(() {
  return SettingsNotifier();
});
