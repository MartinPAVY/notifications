#!/bin/bash

echo "🚀 Building App: Notification True..."
flutter build apk --dart-define=APP_TITLE="Notification True" \
                  --dart-define=NOTIFICATION_TEXT="true" \
                  --dart-define=TRIGGER_ON_START=true \
                  -PAPP_LABEL="Notify True" \
                  -PAPP_ID="com.notifications.notify.true" \
                  --release

echo "✅ Build completed!"
echo "📍 APK available at: build/app/outputs/flutter-apk/app-release.apk"
echo "💡 Vous pouvez renommer le fichier si besoin : mv build/app/outputs/flutter-apk/app-release.apk notify_true.apk"
