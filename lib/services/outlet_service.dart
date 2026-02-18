import 'package:flutter/foundation.dart';
import 'database_service.dart';
import '../models/index.dart';

class OutletService {
  Future<List<Outlet>> getOutlets() async {
    int retries = 0;
    while (retries < 2) {
      try {
        debugPrint(
            'OutletService: Fetching outlets (Attempt ${retries + 1})...');
        final db = await DatabaseService.db;
        final collection = db.collection(DatabaseService.outletsCollection);
        final list = await collection.find().toList();

        if (list.isNotEmpty) {
          final outlets = list.map((item) => Outlet.fromJson(item)).toList();
          debugPrint(
              'OutletService: Found and parsed ${outlets.length} outlets');
          return outlets;
        }

        debugPrint('OutletService: No outlets found on attempt ${retries + 1}');
        if (retries == 0) {
          debugPrint('OutletService: Retrying in 500ms...');
          await Future.delayed(const Duration(milliseconds: 500));
        }
        retries++;
      } catch (e, stackTrace) {
        debugPrint('OutletService Error: $e');
        debugPrint('StackTrace: $stackTrace');
        if (retries >= 1) rethrow; // Rethrow on second error
        await Future.delayed(const Duration(milliseconds: 500));
        retries++;
      }
    }
    return []; // Return empty if all retries failed to find data
  }

  Future<Outlet?> getOutletById(String id) async {
    try {
      final db = await DatabaseService.db;
      final collection = db.collection(DatabaseService.outletsCollection);
      final item = await collection.findOne({'id': id});
      if (item != null) {
        return Outlet.fromJson(item);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Outlet>> searchOutlets(String query) async {
    try {
      final db = await DatabaseService.db;
      final collection = db.collection(DatabaseService.outletsCollection);
      final list = await collection.find({
        '\$or': [
          {
            'name': {'\$regex': query, '\$options': 'i'}
          },
          {
            'cuisineType': {'\$regex': query, '\$options': 'i'}
          },
        ]
      }).toList();
      return list.map((item) => Outlet.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
