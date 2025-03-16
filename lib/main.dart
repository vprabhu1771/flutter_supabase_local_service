import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_local_service/screens/HomePage.dart';
import 'package:flutter_supabase_local_service/screens/auth/RegisterScreen.dart';
import 'services/UiProvider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPA_BASE_URL'] ?? "",
    anonKey: dotenv.env['SUPA_BASE_ANON_KEY'] ?? "",
  );

  runApp(
    const ProviderScope( // Required for Riverpod
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(uiProvider); // Get theme state
    final uiNotifier = ref.read(uiProvider.notifier); // Access notifier

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dark Theme',
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: isDark ? uiNotifier.darkTheme : uiNotifier.greenTheme, // FIXED LINE
      darkTheme: uiNotifier.darkTheme,
      home: const RegisterScreen(title: 'Register'),
    );
  }
}
