#!/bin/bash

echo "🚀 Building App: Notification False..."
flutter build apk --dart-define=APP_TITLE="Notification False" \
                  --dart-define=NOTIFICATION_TEXT="false" \
                  --dart-define=TRIGGER_ON_START=true \
                  -PAPP_LABEL="Notify False" \
                  -PAPP_ID="com.notifications.notify.false" \
                  --release

echo "✅ Build completed!"
echo "📍 APK available at: build/app/outputs/flutter-apk/app-release.apk"
echo "💡 Vous pouvez renommer le fichier si besoin : mv build/app/outputs/flutter-apk/app-release.apk notify_false.apk"
