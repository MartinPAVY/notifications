#!/bin/bash

echo "🚀 Building App: Notify Texte..."
flutter build apk --dart-define=APP_VARIANT=2 \
                  --dart-define=APP_TITLE="Notify Texte" \
                  --dart-define=APP_LABEL="Notify Texte" \
                  --dart-define=APP_ID="com.notifications.notify.perso2" \
                  --release

echo "✅ Build completed!"
echo "📍 Renaming APK to build/app/outputs/flutter-apk/notify_texte.apk"
mv build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/notify_texte.apk
echo "💡 Vous trouverez l'APK ici : build/app/outputs/flutter-apk/notify_texte.apk"
