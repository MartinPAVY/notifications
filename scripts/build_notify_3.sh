#!/bin/bash

echo "🚀 Building App: Notify Message..."
flutter build apk --dart-define=APP_VARIANT=2 \
                  --dart-define=APP_TITLE="Notify Message" \
                  --dart-define=APP_LABEL="Notify Message" \
                  --dart-define=APP_ID="com.notifications.notify.perso3" \
                  --dart-define=NOTIF_LABEL_PREFIX=Message \
                  --release

echo "✅ Build completed!"
echo "📍 Renaming APK to build/app/outputs/flutter-apk/notify_message.apk"
mv build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/notify_message.apk
echo "💡 Vous trouverez l'APK ici : build/app/outputs/flutter-apk/notify_message.apk"
