import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

// Configuration from environment variables
// These can be set during build using: --dart-define=APP_TITLE="Custom Name"
const String appTitle = String.fromEnvironment(
  'APP_TITLE',
  defaultValue: 'Notify Me',
);
const String notificationBody = String.fromEnvironment(
  'NOTIFICATION_TEXT',
  defaultValue: 'Notification Triggered',
);
const bool triggerOnStart = bool.fromEnvironment(
  'TRIGGER_ON_START',
  defaultValue: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(
    settings: initializationSettings,
    onDidReceiveNotificationResponse: (details) {
      // Handle notification click if needed
    },
  );

  runApp(const NotifyMeApp());
}

class NotifyMeApp extends StatelessWidget {
  const NotifyMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      home: const NotifyMeHome(),
    );
  }
}

class NotifyMeHome extends StatefulWidget {
  const NotifyMeHome({super.key});

  @override
  State<NotifyMeHome> createState() => _NotifyMeHomeState();
}

class _NotifyMeHomeState extends State<NotifyMeHome> {
  bool _isInitialized = false;
  String _statusMessage = "En attente des permissions...";

  @override
  void initState() {
    super.initState();
    _setup();
  }

  Future<void> _setup() async {
    bool granted = false;

    try {
      debugPrint("Starting permission request...");
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        // Specifically for iOS, use the plugin's implementation to ensure native delegate is happy
        final iosPlugin = flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              DarwinFlutterLocalNotificationsPlugin
            >();
        if (iosPlugin != null) {
          debugPrint("Requesting iOS permissions via plugin native method...");
          final result = await iosPlugin.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
          granted = result ?? false;
          debugPrint("iOS native request result: $granted");
        }
      } else {
        debugPrint("Requesting Android permissions via permission_handler...");
        var status = await Permission.notification.request();
        granted = status.isGranted;
        debugPrint("Android request result: $granted");
      }
    } catch (e) {
      debugPrint("Error requesting permissions: $e");
    }

    if (granted) {
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _statusMessage = "Prêt à notifier";
        });
      }

      if (triggerOnStart) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _sendNotification();
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _statusMessage = "Permissions refusées ou limitées";
        });
      }
    }
  }

  Future<void> _sendNotification() async {
    debugPrint(
      "Attempting to send notification: $appTitle - $notificationBody",
    );

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'notify_me_channel',
          'Notify Me Notifications',
          channelDescription: 'Channel for Notify Me app triggers',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    try {
      await flutterLocalNotificationsPlugin.show(
        id: DateTime.now().millisecond % 100000,
        title: appTitle,
        body: notificationBody,
        notificationDetails: notificationDetails,
      );
      debugPrint("Notification sent successfully");
    } catch (e) {
      debugPrint("Error sending notification: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(seconds: 1),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.scale(
                        scale: 0.5 + (0.5 * value),
                        child: child,
                      ),
                    );
                  },
                  child: Icon(
                    Icons.notifications_active,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  appTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 8,
                  shadowColor: Colors.black45,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                          Theme.of(context).colorScheme.surface,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.message,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Texte de la notification",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.1,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          notificationBody,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: _isInitialized ? _sendNotification : null,
                    icon: const Icon(Icons.send_rounded),
                    label: const Text(
                      "TESTER LA NOTIFICATION",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
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
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
