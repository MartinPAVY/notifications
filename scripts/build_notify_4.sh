#!/bin/bash

echo "🚀 Building App: Notify Tom..."
flutter build apk --dart-define=APP_VARIANT=2 \
                  --dart-define=APP_TITLE="Notify Tom" \
                  --dart-define=APP_LABEL="Notify Tom" \
                  --dart-define=APP_ID="com.notifications.notify.perso4" \
                  --dart-define=NOTIF_LABEL_PREFIX=Message \
                  --dart-define=NOTIF_1_TITLE=Zone-Radar \
                  --dart-define=NOTIF_1_SUBTITLE="Radar détecté" \
                  --dart-define=NOTIF_2_TITLE=Ralentissez \
                  --dart-define=NOTIF_2_SUBTITLE="Trafic ralenti" \
                  --dart-define=NOTIF_3_TITLE=Zone-Danger \
                  --dart-define=NOTIF_3_SUBTITLE="Danger sur la route" \
                  --dart-define=NOTIF_4_TITLE=Embouteillage \
                  --dart-define=NOTIF_4_SUBTITLE="Trafic bloqué" \
                  --release

echo "✅ Build completed!"
echo "📍 Renaming APK to build/app/outputs/flutter-apk/notify_tom.apk"
mv build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/notify_tom.apk
echo "💡 Vous trouverez l'APK ici : build/app/outputs/flutter-apk/notify_tom.apk"
