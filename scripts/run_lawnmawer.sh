#!/bin/bash

echo "🚀 Lancement de Notify Tondeuse sur l'appareil connecté..."
flutter run --dart-define=APP_VARIANT=6 \
            --dart-define=APP_TITLE="Notify Tondeuse" \
            --dart-define=NOTIF_LABEL_PREFIX=Tondeuse \
            --dart-define=NOTIF_1_SUBTITLE="Message 1" \
            --dart-define=NOTIF_2_SUBTITLE="Message 2" \
            --dart-define=NOTIF_3_SUBTITLE="Message 3" \
            --dart-define=NOTIF_4_SUBTITLE="Message 4" \
            -PAPP_LABEL="Notify Tondeuse" \
            -PAPP_ID="com.notifications.notify.perso6"
