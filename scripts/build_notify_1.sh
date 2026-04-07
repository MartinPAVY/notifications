#!/bin/bash

echo "🚀 Building App: Notify État..."
flutter build apk --dart-define=APP_VARIANT=1 \
                  --dart-define=APP_TITLE="Notify État" \
                  --dart-define=APP_LABEL="Notify État" \
                  --dart-define=APP_ID="com.notifications.notify.perso1" \
                  --release

echo "✅ Build completed!"
echo "📍 Renaming APK to build/app/outputs/flutter-apk/notify_etat.apk"
mv build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/notify_etat.apk
echo "💡 Vous trouverez l'APK ici : build/app/outputs/flutter-apk/notify_etat.apk"
