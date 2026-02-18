import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/settings_service.dart';

final settingsServiceProvider = Provider((ref) => SettingsService());

// Define a provider that will hold the onboarding completed state.
// We'll override this in main.dart with the actual value loaded from SharedPreferences.
final onboardingCompletedProvider = StateProvider<bool>((ref) {
  throw UnimplementedError('onboardingCompletedProvider must be overridden in main.dart');
});
