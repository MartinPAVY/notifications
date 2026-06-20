#!/bin/bash

echo "🚀 Building App: Notify Météo Jour..."
flutter build apk --dart-define=APP_VARIANT=10 \
                  --dart-define=APP_TITLE="Notify Météo Jour" \
                  --dart-define=APP_LABEL="Notify Météo Jour" \
                  --dart-define=APP_ID="com.notifications.notify.meteo.jour" \
                  --release

echo "✅ Build completed!"
echo "📍 Renaming APK to build/app/outputs/flutter-apk/notify_meteo_jour.apk"
mv build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/notify_meteo_jour.apk
echo "💡 Vous trouverez l'APK ici : build/app/outputs/flutter-apk/notify_meteo_jour.apk"
