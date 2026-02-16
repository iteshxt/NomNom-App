import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingRepository {
  static const String _onboardingSeenKey = 'onboarding_seen';

  Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingSeenKey, true);
  }

  Future<bool> isOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingSeenKey) ?? false;
  }
}

final onboardingRepositoryProvider = Provider((ref) => OnboardingRepository());

final onboardingSeenProvider = FutureProvider<bool>((ref) async {
  return ref.watch(onboardingRepositoryProvider).isOnboardingSeen();
});
