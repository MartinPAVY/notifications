import 'package:notify_me/models/notifications/notification.dart';
import 'package:notify_me/models/notifications/notifications.dart';
import 'package:notify_me/src/providers/settings_provider.dart';

// ─── Configuration via variables d'environnement ────────────────────────────

const String appTitleConst = String.fromEnvironment(
  'APP_TITLE',
  defaultValue: 'Notify État',
);

const int appVariantConst = int.fromEnvironment(
  'APP_VARIANT',
  defaultValue: 1,
);

const String notifLabelPrefixConst = String.fromEnvironment(
  'NOTIF_LABEL_PREFIX',
  defaultValue: 'Texte',
);

const String notif1TitleOverride = String.fromEnvironment(
  'NOTIF_1_TITLE',
  defaultValue: '',
);

const String notif2TitleOverride = String.fromEnvironment(
  'NOTIF_2_TITLE',
  defaultValue: '',
);

const String notif3TitleOverride = String.fromEnvironment(
  'NOTIF_3_TITLE',
  defaultValue: '',
);

const String notif4TitleOverride = String.fromEnvironment(
  'NOTIF_4_TITLE',
  defaultValue: '',
);

const String notif1SubtitleOverride = String.fromEnvironment(
  'NOTIF_1_SUBTITLE',
  defaultValue: '',
);

const String notif2SubtitleOverride = String.fromEnvironment(
  'NOTIF_2_SUBTITLE',
  defaultValue: '',
);

const String notif3SubtitleOverride = String.fromEnvironment(
  'NOTIF_3_SUBTITLE',
  defaultValue: '',
);

const String notif4SubtitleOverride = String.fromEnvironment(
  'NOTIF_4_SUBTITLE',
  defaultValue: '',
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
      title: '$notifLabelPrefixConst:1',
      subtitle: 'Notification $notifLabelPrefixConst 1',
      body: 'Non défini',
    ),
    NotificationModel(
      id: 'defaut_2',
      title: '$notifLabelPrefixConst:2',
      subtitle: 'Notification $notifLabelPrefixConst 2',
      body: 'Non défini',
    ),
    NotificationModel(
      id: 'defaut_3',
      title: '$notifLabelPrefixConst:3',
      subtitle: 'Notification $notifLabelPrefixConst 3',
      body: 'Non défini',
    ),
    NotificationModel(
      id: 'defaut_4',
      title: '$notifLabelPrefixConst:4',
      subtitle: 'Notification $notifLabelPrefixConst 4',
      body: 'Non défini',
    ),
  ],
);

final NotificationsModel notificationTypesMeteoJour = NotificationsModel(
  notifications: List.generate(
    22,
    (i) => NotificationModel(
      id: 'jour_${i + 1}',
      title: 'Météo-jour:${i + 1}',
      subtitle: 'Condition météo jour ${i + 1}',
      body: 'Non défini',
    ),
  ),
);

final NotificationsModel notificationTypesMeteoNuit = NotificationsModel(
  notifications: List.generate(
    12,
    (i) => NotificationModel(
      id: 'nuit_${i + 1}',
      title: 'Météo-nuit:${i + 1}',
      subtitle: 'Condition météo nuit ${i + 1}',
      body: 'Non défini',
    ),
  ),
);

final NotificationsModel notificationTypes = appVariantConst == 10
    ? notificationTypesMeteoJour
    : appVariantConst == 11
        ? notificationTypesMeteoNuit
        : appVariantConst == 1
            ? notificationTypes1
            : notificationTypes2;

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
    if (n.id == 'defaut_3') {
      return NotificationModel(
        id: n.id,
        title: settings.defaultTitle3,
        subtitle: settings.defaultSubtitle3,
        body: settings.defaultBody3,
      );
    }
    if (n.id == 'defaut_4') {
      return NotificationModel(
        id: n.id,
        title: settings.defaultTitle4,
        subtitle: settings.defaultSubtitle4,
        body: settings.defaultBody4,
      );
    }
    return n;
  }).toList();
}
