import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/UiProvider.dart';

class SettingScreen extends ConsumerWidget {
  final String title;

  const SettingScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(uiProvider); // Get the current theme state
    final uiNotifier = ref.read(uiProvider.notifier); // Get the notifier

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text("Dark Theme"),
            trailing: Switch(
              value: isDark,
              onChanged: (value) {
                uiNotifier.toggleTheme(); // Use `toggleTheme()` instead of `changeTheme()`
              },
            ),
          ),
        ],
      ),
    );
  }
}
