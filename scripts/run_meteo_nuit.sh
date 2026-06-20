#!/bin/bash

echo "🚀 Lancement de Notify Météo Nuit sur l'appareil connecté..."
flutter run --dart-define=APP_VARIANT=11 \
            --dart-define=APP_TITLE="Notify Météo Nuit" \
            -PAPP_LABEL="Notify Météo Nuit" \
            -PAPP_ID="com.notifications.notify.meteo.nuit"
