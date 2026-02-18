import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'config/routes.dart';
import 'config/theme.dart';
import 'services/database_service.dart';
import 'providers/settings_provider.dart';
import 'services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load onboarding status
  final settingsService = SettingsService();
  final onboardingCompleted = await settingsService.isOnboardingComplete();

  // Initialize MongoDB in background
  DatabaseService.connect().catchError((e) {
    debugPrint('MongoDB initialization error: $e');
  });

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization skipped: $e');
  }

  runApp(
    ProviderScope(
      overrides: [
        onboardingCompletedProvider.overrideWith((ref) => onboardingCompleted),
      ],
      child: const UniBitesApp(),
    ),
  );
}

class UniBitesApp extends ConsumerWidget {
  const UniBitesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'UniBites',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
