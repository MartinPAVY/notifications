import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notify_me/main.dart';
import 'package:notify_me/src/ui/pages/settings.page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const NotifyMeHome()),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const NotifyMeSettings(),
      ),
    ],
  );
});
