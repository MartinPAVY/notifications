#!/bin/bash

echo "🚀 Lancement de Notify personnelles 2 sur l'appareil connecté..."
flutter run --dart-define=APP_VARIANT=2 \
            --dart-define=APP_TITLE="Notify personnelles 2" \
            -PAPP_LABEL="Notify personnelles 2" \
            -PAPP_ID="com.notifications.notify.perso2"
