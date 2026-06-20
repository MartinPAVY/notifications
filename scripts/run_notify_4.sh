#!/bin/bash

echo "🚀 Lancement de Notify Tom sur l'appareil connecté..."
flutter run --dart-define=APP_VARIANT=2 \
            --dart-define=APP_TITLE="Notify Tom" \
            --dart-define=NOTIF_LABEL_PREFIX=Message \
            --dart-define=NOTIF_1_TITLE=Zone-Radar \
            --dart-define=NOTIF_1_SUBTITLE="Radar détecté" \
            --dart-define=NOTIF_2_TITLE=Ralentissez \
            --dart-define=NOTIF_2_SUBTITLE="Trafic ralenti" \
            --dart-define=NOTIF_3_TITLE=Zone-Danger \
            --dart-define=NOTIF_3_SUBTITLE="Danger sur la route" \
            --dart-define=NOTIF_4_TITLE=Embouteillage \
            --dart-define=NOTIF_4_SUBTITLE="Trafic bloqué" \
            -PAPP_LABEL="Notify Tom" \
            -PAPP_ID="com.notifications.notify.perso4"
