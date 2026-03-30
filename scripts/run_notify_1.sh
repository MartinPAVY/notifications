#!/bin/bash

echo "🚀 Lancement de Notify personnelles 1 sur l'appareil connecté..."
flutter run --dart-define=APP_VARIANT=1 \
            --dart-define=APP_TITLE="Notify personnelles 1" \
            -PAPP_LABEL="Notify personnelles 1" \
            -PAPP_ID="com.notifications.notify.perso1"
