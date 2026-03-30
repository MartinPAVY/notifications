import 'package:notify_me/models/notifications/notification.dart';
import 'package:notify_me/models/notifications/notifications.dart';
import 'package:notify_me/src/providers/settings_provider.dart';

// ─── Configuration via variables d'environnement ────────────────────────────

const String appTitleConst = String.fromEnvironment(
  'APP_TITLE',
  defaultValue: 'Notify Personnelles',
);

const int appVariantConst = int.fromEnvironment(
  'APP_VARIANT',
  defaultValue: 1,
);

// ─── Listes de notifications par variante ────────────────────────────────────

final NotificationsModel notificationTypes1 = const NotificationsModel(
  notifications: [
    NotificationModel(
      id: 'vrai',
      title: 'Notify Vrai',
      subtitle: 'Notification booléan',
      body: 'True',
    ),
    NotificationModel(
      id: 'faux',
      title: 'Notify Faux',
      subtitle: 'Notification booléan',
      body: 'False',
    ),
    NotificationModel(
      id: 'active',
      title: 'Notify Activé',
      subtitle: 'Notification d\'état',
      body: 'On',
    ),
    NotificationModel(
      id: 'desactive',
      title: 'Notify Désactivé',
      subtitle: 'Notification d\'état',
      body: 'Off',
    ),
  ],
);

final NotificationsModel notificationTypes2 = const NotificationsModel(
  notifications: [
    NotificationModel(
      id: 'defaut_1',
      title: 'Notify Texte 1',
      subtitle: 'Notification Texte 1',
      body: 'Non défini',
    ),
    NotificationModel(
      id: 'defaut_2',
      title: 'Notify Texte 2',
      subtitle: 'Notification Texte 2',
      body: 'Non défini',
    ),
  ],
);

final NotificationsModel notificationTypes =
    appVariantConst == 1 ? notificationTypes1 : notificationTypes2;

// ─── Résolution dynamique (titre personnalisé depuis les settings) ────────────

List<NotificationModel> getDynamicNotifications(SettingsState settings) {
  return notificationTypes.notifications.map((n) {
    if (n.id == 'defaut_1') {
      return NotificationModel(
        id: n.id,
        title: settings.defaultTitle,
        subtitle: settings.defaultSubtitle,
        body: settings.defaultBody,
      );
    }
    if (n.id == 'defaut_2') {
      return NotificationModel(
        id: n.id,
        title: settings.defaultTitle2,
        subtitle: settings.defaultSubtitle2,
        body: settings.defaultBody2,
      );
    }
    return n;
  }).toList();
}
