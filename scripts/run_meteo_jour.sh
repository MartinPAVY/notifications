#!/bin/bash

echo "🚀 Lancement de Notify Météo Jour sur l'appareil connecté..."
fvm flutter run --dart-define=APP_VARIANT=10 \
            --dart-define=APP_TITLE="Notify Météo Jour" \
            -PAPP_LABEL="Notify Météo Jour" \
            -PAPP_ID="com.notifications.notify.meteo.jour"
