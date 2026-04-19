import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final bool autoDismissEnabled;
  final int dismissDurationMinutes;
  final String selectedNotificationId;
  final String defaultTitle;
  final String defaultSubtitle;
  final String defaultBody;
  final String defaultTitle2;
  final String defaultSubtitle2;
  final String defaultBody2;
  final String defaultTitle3;
  final String defaultSubtitle3;
  final String defaultBody3;
  final String defaultTitle4;
  final String defaultSubtitle4;
  final String defaultBody4;

  SettingsState({
    required this.autoDismissEnabled,
    required this.dismissDurationMinutes,
    required this.selectedNotificationId,
    required this.defaultTitle,
    required this.defaultSubtitle,
    required this.defaultBody,
    required this.defaultTitle2,
    required this.defaultSubtitle2,
    required this.defaultBody2,
    required this.defaultTitle3,
    required this.defaultSubtitle3,
    required this.defaultBody3,
    required this.defaultTitle4,
    required this.defaultSubtitle4,
    required this.defaultBody4,
  });

  SettingsState copyWith({
    bool? autoDismissEnabled,
    int? dismissDurationMinutes,
    String? selectedNotificationId,
    String? defaultTitle,
    String? defaultSubtitle,
    String? defaultBody,
    String? defaultTitle2,
    String? defaultSubtitle2,
    String? defaultBody2,
    String? defaultTitle3,
    String? defaultSubtitle3,
    String? defaultBody3,
    String? defaultTitle4,
    String? defaultSubtitle4,
    String? defaultBody4,
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
      defaultTitle2: defaultTitle2 ?? this.defaultTitle2,
      defaultSubtitle2: defaultSubtitle2 ?? this.defaultSubtitle2,
      defaultBody2: defaultBody2 ?? this.defaultBody2,
      defaultTitle3: defaultTitle3 ?? this.defaultTitle3,
      defaultSubtitle3: defaultSubtitle3 ?? this.defaultSubtitle3,
      defaultBody3: defaultBody3 ?? this.defaultBody3,
      defaultTitle4: defaultTitle4 ?? this.defaultTitle4,
      defaultSubtitle4: defaultSubtitle4 ?? this.defaultSubtitle4,
      defaultBody4: defaultBody4 ?? this.defaultBody4,
    );
  }
}

const int _appVariant = int.fromEnvironment('APP_VARIANT', defaultValue: 1);

class SettingsNotifier extends Notifier<SettingsState> {
  static const String _keyAutoDismiss = 'auto_dismiss_enabled';
  static const String _keyDismissDuration = 'dismiss_duration_minutes';
  static const String _keySelectedNotification = 'selected_notification_id';
  static const String _keyDefaultTitle = 'default_title';
  static const String _keyDefaultSubtitle = 'default_subtitle';
  static const String _keyDefaultBody = 'default_body';
  static const String _keyDefaultTitle2 = 'default_title2';
  static const String _keyDefaultSubtitle2 = 'default_subtitle2';
  static const String _keyDefaultBody2 = 'default_body2';
  static const String _keyDefaultTitle3 = 'default_title3';
  static const String _keyDefaultSubtitle3 = 'default_subtitle3';
  static const String _keyDefaultBody3 = 'default_body3';
  static const String _keyDefaultTitle4 = 'default_title4';
  static const String _keyDefaultSubtitle4 = 'default_subtitle4';
  static const String _keyDefaultBody4 = 'default_body4';

  @override
  SettingsState build() {
    // We start with default values and load from prefs asynchronously
    _loadSettings();
    return SettingsState(
      autoDismissEnabled: true,
      dismissDurationMinutes: 1,
      selectedNotificationId: _appVariant == 1 ? 'vrai' : 'defaut_1',
      defaultTitle: 'Texte:1',
      defaultSubtitle: 'Notification Texte 1',
      defaultBody: 'Non défini',
      defaultTitle2: 'Texte:2',
      defaultSubtitle2: 'Notification Texte 2',
      defaultBody2: 'Non défini',
      defaultTitle3: 'Texte:3',
      defaultSubtitle3: 'Notification Texte 3',
      defaultBody3: 'Non défini',
      defaultTitle4: 'Texte:4',
      defaultSubtitle4: 'Notification Texte 4',
      defaultBody4: 'Non défini',
    );
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final autoDismiss = prefs.getBool(_keyAutoDismiss) ?? true;
    final duration = prefs.getInt(_keyDismissDuration) ?? 1;
    final selectedId =
        prefs.getString(_keySelectedNotification) ??
        (_appVariant == 1 ? 'vrai' : 'defaut_1');
    final title = prefs.getString(_keyDefaultTitle) ?? 'Texte:1';
    final subtitle =
        prefs.getString(_keyDefaultSubtitle) ?? 'Notification Texte 1';
    final body = prefs.getString(_keyDefaultBody) ?? 'Non défini';
    final title2 = prefs.getString(_keyDefaultTitle2) ?? 'Texte:2';
    final subtitle2 =
        prefs.getString(_keyDefaultSubtitle2) ?? 'Notification Texte 2';
    final body2 = prefs.getString(_keyDefaultBody2) ?? 'Non défini';
    final title3 = prefs.getString(_keyDefaultTitle3) ?? 'Texte:3';
    final subtitle3 =
        prefs.getString(_keyDefaultSubtitle3) ?? 'Notification Texte 3';
    final body3 = prefs.getString(_keyDefaultBody3) ?? 'Non défini';
    final title4 = prefs.getString(_keyDefaultTitle4) ?? 'Texte:4';
    final subtitle4 =
        prefs.getString(_keyDefaultSubtitle4) ?? 'Notification Texte 4';
    final body4 = prefs.getString(_keyDefaultBody4) ?? 'Non défini';

    state = SettingsState(
      autoDismissEnabled: autoDismiss,
      dismissDurationMinutes: duration,
      selectedNotificationId: selectedId,
      defaultTitle: title,
      defaultSubtitle: subtitle,
      defaultBody: body,
      defaultTitle2: title2,
      defaultSubtitle2: subtitle2,
      defaultBody2: body2,
      defaultTitle3: title3,
      defaultSubtitle3: subtitle3,
      defaultBody3: body3,
      defaultTitle4: title4,
      defaultSubtitle4: subtitle4,
      defaultBody4: body4,
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

  Future<void> setDefaultTitle2(String title) async {
    state = state.copyWith(defaultTitle2: title);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDefaultTitle2, title);
  }

  Future<void> setDefaultSubtitle2(String subtitle) async {
    state = state.copyWith(defaultSubtitle2: subtitle);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDefaultSubtitle2, subtitle);
  }

  Future<void> setDefaultBody2(String body) async {
    state = state.copyWith(defaultBody2: body);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDefaultBody2, body);
  }

  Future<void> setDefaultTitle3(String title) async {
    state = state.copyWith(defaultTitle3: title);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDefaultTitle3, title);
  }

  Future<void> setDefaultSubtitle3(String subtitle) async {
    state = state.copyWith(defaultSubtitle3: subtitle);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDefaultSubtitle3, subtitle);
  }

  Future<void> setDefaultBody3(String body) async {
    state = state.copyWith(defaultBody3: body);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDefaultBody3, body);
  }

  Future<void> setDefaultTitle4(String title) async {
    state = state.copyWith(defaultTitle4: title);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDefaultTitle4, title);
  }

  Future<void> setDefaultSubtitle4(String subtitle) async {
    state = state.copyWith(defaultSubtitle4: subtitle);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDefaultSubtitle4, subtitle);
  }

  Future<void> setDefaultBody4(String body) async {
    state = state.copyWith(defaultBody4: body);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDefaultBody4, body);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(() {
  return SettingsNotifier();
});
