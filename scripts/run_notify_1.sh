#!/bin/bash

echo "🚀 Lancement de Notify État sur l'appareil connecté..."
flutter run --dart-define=APP_VARIANT=1 \
            --dart-define=APP_TITLE="Notify État" \
            -PAPP_LABEL="Notify État" \
            -PAPP_ID="com.notifications.notify.perso1"
