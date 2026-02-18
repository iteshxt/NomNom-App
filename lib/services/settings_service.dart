import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _onboardingCompleteKey = 'onboarding_complete';

  Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  Future<void> setOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, true);
  }
}
