import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notify_me/src/providers/settings_provider.dart';

class NotifyMeSettings extends ConsumerStatefulWidget {
  const NotifyMeSettings({super.key});

  @override
  ConsumerState<NotifyMeSettings> createState() => _NotifyMeSettingsState();
}

class _NotifyMeSettingsState extends ConsumerState<NotifyMeSettings> {
  late TextEditingController _durationController;
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider);
    _durationController = TextEditingController(
      text: settings.dismissDurationMinutes.toString(),
    );
    _titleController = TextEditingController(text: settings.defaultTitle);
    _subtitleController = TextEditingController(text: settings.defaultSubtitle);
    _bodyController = TextEditingController(text: settings.defaultBody);
  }

  @override
  void dispose() {
    _durationController.dispose();
    _titleController.dispose();
    _subtitleController.dispose();
    _bodyController.dispose();
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
    if (_titleController.text != settings.defaultTitle) {
      _titleController.text = settings.defaultTitle;
    }
    if (_subtitleController.text != settings.defaultSubtitle) {
      _subtitleController.text = settings.defaultSubtitle;
    }
    if (_bodyController.text != settings.defaultBody) {
      _bodyController.text = settings.defaultBody;
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
                                  if (minutes != null && minutes > 0) {
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
                const SizedBox(height: 24),
                const Text(
                  'Notification par défaut',
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
                        'Titre',
                        _titleController,
                        settingsNotifier.setDefaultTitle,
                        30,
                      ),
                      const Divider(color: Colors.white12, height: 24),
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
