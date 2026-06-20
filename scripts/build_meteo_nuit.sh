#!/bin/bash

echo "🚀 Building App: Notify Météo Nuit..."
flutter build apk --dart-define=APP_VARIANT=11 \
                  --dart-define=APP_TITLE="Notify Météo Nuit" \
                  --dart-define=APP_LABEL="Notify Météo Nuit" \
                  --dart-define=APP_ID="com.notifications.notify.meteo.nuit" \
                  --release

echo "✅ Build completed!"
echo "📍 Renaming APK to build/app/outputs/flutter-apk/notify_meteo_nuit.apk"
mv build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/notify_meteo_nuit.apk
echo "💡 Vous trouverez l'APK ici : build/app/outputs/flutter-apk/notify_meteo_nuit.apk"
