#!/bin/bash

echo "🚀 Lancement de Notify Message sur l'appareil connecté..."
flutter run --dart-define=APP_VARIANT=2 \
            --dart-define=APP_TITLE="Notify Message" \
            --dart-define=NOTIF_LABEL_PREFIX=Message \
            -PAPP_LABEL="Notify Message" \
            -PAPP_ID="com.notifications.notify.perso3"
