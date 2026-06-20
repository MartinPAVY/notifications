#!/bin/bash

echo "🚀 Lancement de Notify Tomtom sur l'appareil connecté..."
flutter run --dart-define=APP_VARIANT=5 \
            --dart-define=APP_TITLE="Notify Tomtom" \
            --dart-define=NOTIF_LABEL_PREFIX=Tomtom \
            --dart-define=NOTIF_1_SUBTITLE="Message 1" \
            --dart-define=NOTIF_2_SUBTITLE="Message 2" \
            --dart-define=NOTIF_3_SUBTITLE="Message 3" \
            --dart-define=NOTIF_4_SUBTITLE="Message 4" \
            -PAPP_LABEL="Notify Tomtom" \
            -PAPP_ID="com.notifications.notify.perso5"
