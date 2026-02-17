import '../models/index.dart';

class UserService {
  User? _user;

  UserService({User? user}) : _user = user;

  Future<User?> updateProfile({
    required String userId,
    String? name,
    String? phone,
    String? profilePhoto,
  }) async {
    if (_user == null) return null;

    _user = _user!.copyWith(
      name: name ?? _user!.name,
      phone: phone ?? _user!.phone,
      profilePhoto: profilePhoto ?? _user!.profilePhoto,
    );

    return _user;
  }

  Future<void> setDietaryPreferences(List<String> preferences) async {
    if (_user == null) return;

    _user = _user!.copyWith(dietaryPreferences: preferences);
  }

  Future<void> setPushNotificationPreferences(bool enabled) async {
    if (_user == null) return;

    _user = _user!.copyWith(pushNotificationEnabled: enabled);
  }

  User? getUser() => _user;

  Future<void> setUser(User user) async {
    _user = user;
  }
}
