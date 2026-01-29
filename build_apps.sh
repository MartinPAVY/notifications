#!/bin/bash

# This script builds two versions of the Notify Me app.
# One for "notification true" and one for "notification false".

# App 1: Notification True
echo "🚀 Building App: Notification True..."
flutter build apk --dart-define=APP_TITLE="Notification True" \
                  --dart-define=NOTIFICATION_TEXT="notification true" \
                  --dart-define=TRIGGER_ON_START=true \
                  -PAPP_LABEL="Notify True" \
                  -PAPP_ID="com.notifications.notify.true" \
                  --debug # Using debug for quick testing, remove for release

mv build/app/outputs/flutter-apk/app-debug.apk build/app/outputs/flutter-apk/notify_true.apk

# App 2: Notification False
echo "🚀 Building App: Notification False..."
flutter build apk --dart-define=APP_TITLE="Notification False" \
                  --dart-define=NOTIFICATION_TEXT="notification false" \
                  --dart-define=TRIGGER_ON_START=true \
                  -PAPP_LABEL="Notify False" \
                  -PAPP_ID="com.notifications.notify.false" \
                  --debug # Using debug for quick testing, remove for release

mv build/app/outputs/flutter-apk/app-debug.apk build/app/outputs/flutter-apk/notify_false.apk

echo "✅ Android builds completed!"
echo "📍 APKs available at:"
echo "   - build/app/outputs/flutter-apk/notify_true.apk"
echo "   - build/app/outputs/flutter-apk/notify_false.apk"

echo ""
echo "💡 Pour iOS, vous pouvez tester avec ces commandes :"
echo "# App True"
echo "flutter run --dart-define=APP_TITLE=\"Notification True\" --dart-define=NOTIFICATION_TEXT=\"notification true\""
echo ""
echo "# App False"
echo "flutter run --dart-define=APP_TITLE=\"Notification False\" --dart-define=NOTIFICATION_TEXT=\"notification false\""
