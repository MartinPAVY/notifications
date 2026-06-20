#!/bin/bash

echo "🚀 Building App: Notify Tondeuse..."
flutter build apk --dart-define=APP_VARIANT=6 \
                  --dart-define=APP_TITLE="Notify Tondeuse" \
                  --dart-define=APP_LABEL="Notify Tondeuse" \
                  --dart-define=APP_ID="com.notifications.notify.perso6" \
                  --dart-define=NOTIF_LABEL_PREFIX=Tondeuse \
                  --dart-define=NOTIF_1_SUBTITLE="Message 1" \
                  --dart-define=NOTIF_2_SUBTITLE="Message 2" \
                  --dart-define=NOTIF_3_SUBTITLE="Message 3" \
                  --dart-define=NOTIF_4_SUBTITLE="Message 4" \
                  --release

echo "✅ Build completed!"
echo "📍 Renaming APK to build/app/outputs/flutter-apk/notify_tondeuse.apk"
mv build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/notify_tondeuse.apk
echo "💡 Vous trouverez l'APK ici : build/app/outputs/flutter-apk/notify_tondeuse.apk"
