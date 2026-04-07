#!/bin/bash

echo "🚀 Lancement de Notify Texte sur l'appareil connecté..."
flutter run --dart-define=APP_VARIANT=2 \
            --dart-define=APP_TITLE="Notify Texte" \
            -PAPP_LABEL="Notify Texte" \
            -PAPP_ID="com.notifications.notify.perso2"
