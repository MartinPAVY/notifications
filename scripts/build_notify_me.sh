#!/bin/bash

echo "🚀 Building App: Notify..."
flutter build apk --dart-define=APP_TITLE="Notify" \
                  -PAPP_LABEL="Notify" \
                  -PAPP_ID="com.notifications.notify.me" \
                  --release

echo "✅ Build completed!"
echo "📍 APK available at: build/app/outputs/flutter-apk/app-release.apk"
echo "💡 Vous pouvez renommer le fichier si besoin : mv build/app/outputs/flutter-apk/app-release.apk notify_true.apk"
