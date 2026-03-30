import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:notify_me/main.dart' show flutterLocalNotificationsPlugin;
import 'package:notify_me/models/notifications/notification.dart';
import 'package:notify_me/src/app_config.dart';
import 'package:notify_me/src/providers/settings_provider.dart';
import 'package:notify_me/src/ui/widgets/notification_card.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quick_actions/quick_actions.dart';

class NotifyMeHome extends ConsumerStatefulWidget {
  const NotifyMeHome({super.key});

  @override
  ConsumerState<NotifyMeHome> createState() => _NotifyMeHomeState();
}

class _NotifyMeHomeState extends ConsumerState<NotifyMeHome> {
  bool _isInitialized = false;
  bool _quickActionsInitialized = false;
  String _statusMessage = "En attente...";
  final QuickActions _quickActions = const QuickActions();

  @override
  void initState() {
    super.initState();
    _setup();
    _setupQuickActions();
  }

  void _setupQuickActions() {
    _quickActions.setShortcutItems(
      appVariantConst == 1
          ? const <ShortcutItem>[
              ShortcutItem(type: 'vrai', localizedTitle: 'Notify Vrai'),
              ShortcutItem(type: 'faux', localizedTitle: 'Notify Faux'),
              ShortcutItem(type: 'active', localizedTitle: 'Notify Activé'),
              ShortcutItem(
                type: 'desactive',
                localizedTitle: 'Notify Désactivé',
              ),
            ]
          : const <ShortcutItem>[
              ShortcutItem(type: 'defaut_1', localizedTitle: 'Notify Texte 1'),
              ShortcutItem(type: 'defaut_2', localizedTitle: 'Notify Texte 2'),
            ],
    );

    if (_quickActionsInitialized) return;
    _quickActionsInitialized = true;

    _quickActions.initialize((String type) async {
      try {
        final settings = ref.read(settingsProvider);
        final nType = getDynamicNotifications(
          settings,
        ).firstWhere((e) => e.id == type);
        ref.read(settingsProvider.notifier).setSelectedNotificationId(nType.id);
        await _sendNotification(typeOverride: nType);

        // Fermer l'application après avoir lancé la notification via raccourci
        SystemNavigator.pop();
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
    final settings = ref.read(settingsProvider);
    final selectedId = settings.selectedNotificationId;
    final dynNotifs = getDynamicNotifications(settings);
    final type =
        typeOverride ??
        dynNotifs.firstWhere(
          (e) => e.id == selectedId,
          orElse: () => dynNotifs[0],
        );
    final id = type.id.hashCode;
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
          timeoutAfter: timeout,
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
                  appTitleConst,
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
                      final settings = ref.watch(settingsProvider);
                      final type = getDynamicNotifications(settings)[index];
                      final selectedId = settings.selectedNotificationId;

                      return NotificationCard(
                        type: type,
                        isSelected: selectedId == type.id,
                        onTap: () {
                          ref
                              .read(settingsProvider.notifier)
                              .setSelectedNotificationId(type.id);
                        },
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
