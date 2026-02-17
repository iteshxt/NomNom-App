import 'database_service.dart';
import '../models/index.dart';

class UserService {
  Future<User?> updateProfile({
    required String userId,
    String? name,
    String? phone,
    String? profilePhoto,
  }) async {
    try {
      final db = await DatabaseService.db;
      final collection = db.collection(DatabaseService.usersCollection);

      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (phone != null) updateData['phone'] = phone;
      if (profilePhoto != null) updateData['profilePhoto'] = profilePhoto;

      await collection.updateOne(
        {'id': userId},
        {'\$set': updateData},
        upsert: true,
      );

      final updatedUser = await collection.findOne({'id': userId});
      return updatedUser != null ? User.fromJson(updatedUser) : null;
    } catch (e) {
      return null;
    }
  }

  Future<void> setDietaryPreferences(
      String userId, List<String> preferences) async {
    try {
      final db = await DatabaseService.db;
      final collection = db.collection(DatabaseService.usersCollection);
      await collection.updateOne(
        {'id': userId},
        {
          '\$set': {'dietaryPreferences': preferences}
        },
        upsert: true,
      );
    } catch (e) {
      // Log error
    }
  }

  Future<void> setPushNotificationPreferences(
      String userId, bool enabled) async {
    try {
      final db = await DatabaseService.db;
      final collection = db.collection(DatabaseService.usersCollection);
      await collection.updateOne(
        {'id': userId},
        {
          '\$set': {'pushNotificationEnabled': enabled}
        },
        upsert: true,
      );
    } catch (e) {
      // Log error
    }
  }

  Future<User?> getUser(String userId) async {
    try {
      final db = await DatabaseService.db;
      final collection = db.collection(DatabaseService.usersCollection);
      final user = await collection.findOne({'id': userId});
      return user != null ? User.fromJson(user) : null;
    } catch (e) {
      return null;
    }
  }
}
