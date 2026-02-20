#!/bin/bash

echo "🚀 Building App: Notify..."
flutter build apk --dart-define=APP_TITLE="Notifs Perso" \
                  -PAPP_LABEL="Notifs Perso" \
                  -PAPP_ID="com.notifications.notifs.perso" \
                  --release

echo "✅ Build completed!"
echo "📍 APK available at: build/app/outputs/flutter-apk/app-release.apk"
echo "💡 Vous pouvez renommer le fichier si besoin : mv build/app/outputs/flutter-apk/app-release.apk notify_true.apk"
