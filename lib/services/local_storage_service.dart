import 'dart:convert';
import 'package:hive/hive.dart';
import '../models/index.dart';

class LocalStorageService {
  static const String _guestCartKey = 'guest_cart';
  static const String _userPreferencesKey = 'user_preferences';
  static const String _boxName = 'unibites_storage';

  late Box<String> _box;

  Future<void> init() async {
    _box = await Hive.openBox<String>(_boxName);
  }

  // Guest Cart Methods
  Future<void> saveGuestCart(List<OrderItem> items) async {
    final jsonList = items.map((item) => jsonEncode(item.toJson())).toList();
    await _box.put(_guestCartKey, jsonEncode(jsonList));
  }

  Future<List<OrderItem>> loadGuestCart() async {
    final stored = _box.get(_guestCartKey);
    if (stored == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(stored);
      return jsonList
          .map((item) => OrderItem.fromJson(jsonDecode(item)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> clearGuestCart() async {
    await _box.delete(_guestCartKey);
  }

  // User Preferences
  Future<void> saveUserPreferences(Map<String, dynamic> preferences) async {
    await _box.put(_userPreferencesKey, jsonEncode(preferences));
  }

  Future<Map<String, dynamic>> loadUserPreferences() async {
    final stored = _box.get(_userPreferencesKey);
    if (stored == null) return {};

    try {
      return jsonDecode(stored) as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}
