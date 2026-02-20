import 'package:flutter/material.dart';
import 'package:notify_me/models/notifications/notification.dart';
import 'package:notify_me/models/notifications/notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quick_actions/quick_actions.dart';
import 'src/router/app_router.dart';
import 'package:notify_me/src/providers/settings_provider.dart';

// Configuration from environment variables
const String appTitleConst = String.fromEnvironment(
  'APP_TITLE',
  defaultValue: 'Notifs Personnelles',
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(
    settings: initializationSettings,
    onDidReceiveNotificationResponse: (details) {
      // Handle notification click
    },
  );

  runApp(const ProviderScope(child: NotifyMeApp()));
}

const NotificationsModel notificationTypes = NotificationsModel(
  notifications: [
    NotificationModel(
      id: 'defaut',
      title: 'Notify Défaut',
      subtitle: 'Notification d\'état',
      body: 'Non défini(e)',
    ),
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

class NotifyMeApp extends ConsumerWidget {
  const NotifyMeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: appTitleConst,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8DAAFA),
          brightness: Brightness.dark,
          surface: const Color(0xFF1C1C1E),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 28,
          ),
        ),
      ),
      routerConfig: router,
    );
  }
}

class NotifyMeHome extends ConsumerStatefulWidget {
  const NotifyMeHome({super.key});

  @override
  ConsumerState<NotifyMeHome> createState() => _NotifyMeHomeState();
}

class _NotifyMeHomeState extends ConsumerState<NotifyMeHome> {
  bool _isInitialized = false;
  String _statusMessage = "En attente...";
  final QuickActions _quickActions = const QuickActions();

  @override
  void initState() {
    super.initState();
    _setup();
    _setupQuickActions();
  }

  void _setupQuickActions() {
    _quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(type: 'vrai', localizedTitle: 'Notify Vrai'),
      const ShortcutItem(type: 'faux', localizedTitle: 'Notify Faux'),
      const ShortcutItem(type: 'active', localizedTitle: 'Notify Activé'),
      const ShortcutItem(type: 'desactive', localizedTitle: 'Notify Désactivé'),
      const ShortcutItem(type: 'defaut', localizedTitle: 'Notify Défaut'),
    ]);

    _quickActions.initialize((String type) {
      try {
        final nType = notificationTypes.notifications.firstWhere(
          (e) => e.id == type,
        );
        _sendNotification(typeOverride: nType);
      } catch (e) {
        debugPrint("Error handling shortcut: $e");
      }
    });
  }

  Future<void> _setup() async {
    bool granted = false;

    try {
      var status = await Permission.notification.request();
      granted = status.isGranted || status.isProvisional;
    } catch (e) {
      debugPrint("Error requesting permissions: $e");
    }

    if (mounted) {
      setState(() {
        _isInitialized = granted;
        _statusMessage = granted ? "Prêt à notifier" : "Permissions requises";
      });
    }
  }

  Future<void> _sendNotification({NotificationModel? typeOverride}) async {
    final selectedId = ref.read(settingsProvider).selectedNotificationId;
    final type =
        typeOverride ??
        notificationTypes.notifications.firstWhere(
          (e) => e.id == selectedId,
          orElse: () => notificationTypes.notifications[0],
        );
    final id = DateTime.now().millisecond % 100000;

    final settings = ref.read(settingsProvider);
    final timeout = settings.autoDismissEnabled
        ? settings.dismissDurationMinutes * 60000
        : null;

    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'notifs_perso_channel',
          'Notifs Perso',
          channelDescription: 'Channel for Notifs Perso app triggers',
          importance: Importance.max,
          priority: Priority.high,
          timeoutAfter: timeout, // Suppression automatique native sur Android
        );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    try {
      await flutterLocalNotificationsPlugin.show(
        id: id,
        title: type.title,
        body: '${type.subtitle}\n${type.body}',
        notificationDetails: notificationDetails,
      );

      // Suppression manuelle après le délai (pour iOS et secours Android)
      if (timeout != null) {
        Future.delayed(Duration(milliseconds: timeout), () {
          flutterLocalNotificationsPlugin.cancel(id: id);
        });
      }
    } catch (e) {
      debugPrint("Error sending notification: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2C3E50), Color(0xFF000000)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.settings,
                        size: 24,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        context.pushNamed('settings');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Center(
                  child: SvgPicture.asset(
                    'assets/bell-ringing.svg',
                    height: 80,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF8DAAFA),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  "Notifs Personnelles",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.separated(
                    itemCount: notificationTypes.notifications.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final type = notificationTypes.notifications[index];
                      final selectedId = ref
                          .watch(settingsProvider)
                          .selectedNotificationId;
                      final isSelected = selectedId == type.id;

                      return GestureDetector(
                        onTap: () {
                          ref
                              .read(settingsProvider.notifier)
                              .setSelectedNotificationId(type.id);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF2C2C2E)
                                : const Color(0xFF1C1C1E),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(
                                      0xFF8DAAFA,
                                    ).withValues(alpha: 0.3)
                                  : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF8DAAFA),
                                    width: 2,
                                  ),
                                ),
                                child: isSelected
                                    ? Center(
                                        child: Container(
                                          width: 12,
                                          height: 12,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF8DAAFA),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      type.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      type.subtitle,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      type.body,
                                      style: const TextStyle(
                                        color: Colors.white60,
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF8DAAFA).withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: _isInitialized ? _sendNotification : null,
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: const Text(
                      "ENVOYER LA NOTIFICATION",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: const Color(0xFF8DAAFA),
                      foregroundColor: const Color(0xFF1C1C1E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isInitialized
                            ? Colors.greenAccent
                            : Colors.orangeAccent,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _statusMessage,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
