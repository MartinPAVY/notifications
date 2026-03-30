#!/bin/bash

echo "🚀 Building App: Notify personnelles 1..."
flutter build apk --dart-define=APP_VARIANT=1 \
                  --dart-define=APP_TITLE="Notify personnelles 1" \
                  --dart-define=APP_LABEL="Notify personnelles 1" \
                  --dart-define=APP_ID="com.notifications.notify.perso1" \
                  --release

echo "✅ Build completed!"
echo "📍 Renaming APK to build/app/outputs/flutter-apk/notify_personnelles_1.apk"
mv build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/notify_personnelles_1.apk
echo "💡 Vous trouverez l'APK ici : build/app/outputs/flutter-apk/notify_personnelles_1.apk"
