import 'package:flutter/material.dart';

class NotifyMeSettings extends StatelessWidget {
  const NotifyMeSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Page')),
    );
  }
}
