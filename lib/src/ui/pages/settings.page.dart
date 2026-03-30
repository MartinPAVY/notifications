import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notify_me/src/providers/settings_provider.dart';

const int _appVariant = int.fromEnvironment('APP_VARIANT', defaultValue: 1);

class NotifyMeSettings extends ConsumerStatefulWidget {
  const NotifyMeSettings({super.key});

  @override
  ConsumerState<NotifyMeSettings> createState() => _NotifyMeSettingsState();
}

class _NotifyMeSettingsState extends ConsumerState<NotifyMeSettings> {
  late TextEditingController _durationController;
  late TextEditingController _subtitleController;
  late TextEditingController _bodyController;
  late TextEditingController _subtitle2Controller;
  late TextEditingController _body2Controller;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider);
    _durationController = TextEditingController(
      text: settings.dismissDurationMinutes.toString(),
    );
    _subtitleController = TextEditingController(text: settings.defaultSubtitle);
    _bodyController = TextEditingController(text: settings.defaultBody);
    _subtitle2Controller = TextEditingController(text: settings.defaultSubtitle2);
    _body2Controller = TextEditingController(text: settings.defaultBody2);
  }

  @override
  void dispose() {
    _durationController.dispose();
    _subtitleController.dispose();
    _bodyController.dispose();
    _subtitle2Controller.dispose();
    _body2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    // Sync controller if settings change from elsewhere (though unlikely here)
    if (_durationController.text !=
        settings.dismissDurationMinutes.toString()) {
      _durationController.text = settings.dismissDurationMinutes.toString();
    }
    if (_subtitleController.text != settings.defaultSubtitle) {
      _subtitleController.text = settings.defaultSubtitle;
    }
    if (_bodyController.text != settings.defaultBody) {
      _bodyController.text = settings.defaultBody;
    }
    if (_subtitle2Controller.text != settings.defaultSubtitle2) {
      _subtitle2Controller.text = settings.defaultSubtitle2;
    }
    if (_body2Controller.text != settings.defaultBody2) {
      _body2Controller.text = settings.defaultBody2;
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF2C3E50),
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2C3E50), Color(0xFF000000)],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notifications',
                  style: TextStyle(
                    color: Color(0xFF8DAAFA),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Auto-effacement',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Effacer après un délai',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value: settings.autoDismissEnabled,
                            activeTrackColor: const Color(0xFF8DAAFA),
                            onChanged: (value) {
                              settingsNotifier.setAutoDismissEnabled(value);
                            },
                          ),
                        ],
                      ),
                      if (settings.autoDismissEnabled) ...[
                        const Divider(color: Colors.white12, height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Durée',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  '(minutes)',
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              width: 80,
                              child: TextField(
                                controller: _durationController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFF2C2C2E),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                onChanged: (value) {
                                  final minutes = int.tryParse(value);
                                  if (minutes != null) {
                                    if (minutes > 120) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'La durée maximale est de 120 minutes',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      );
                                      settingsNotifier
                                          .setDismissDurationMinutes(120);
                                    } else if (minutes < 1) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'La durée minimale est de 1 minute',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      );
                                      settingsNotifier
                                          .setDismissDurationMinutes(1);
                                    } else {
                                      settingsNotifier
                                          .setDismissDurationMinutes(minutes);
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (_appVariant == 2) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'Notification Texte 1',
                    style: TextStyle(
                      color: Color(0xFF8DAAFA),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildTextFieldColumn(
                          'Sous-titre',
                          _subtitleController,
                          settingsNotifier.setDefaultSubtitle,
                          50,
                        ),
                        const Divider(color: Colors.white12, height: 24),
                        _buildTextFieldColumn(
                          'Message',
                          _bodyController,
                          settingsNotifier.setDefaultBody,
                          100,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Notification Texte 2',
                    style: TextStyle(
                      color: Color(0xFF8DAAFA),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildTextFieldColumn(
                          'Sous-titre',
                          _subtitle2Controller,
                          settingsNotifier.setDefaultSubtitle2,
                          50,
                        ),
                        const Divider(color: Colors.white12, height: 24),
                        _buildTextFieldColumn(
                          'Message',
                          _body2Controller,
                          settingsNotifier.setDefaultBody2,
                          100,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldColumn(
    String label,
    TextEditingController controller,
    Function(String) onChanged,
    int maxLength,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLength: maxLength,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF2C2C2E),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
