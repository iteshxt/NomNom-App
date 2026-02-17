import 'database_service.dart';
import '../models/index.dart';

class OutletService {
  Future<List<Outlet>> getOutlets() async {
    try {
      print('OutletService: Fetching outlets...');
      final db = await DatabaseService.db;
      print('OutletService: Connected to DB: ${db.databaseName}');
      final collection = db.collection(DatabaseService.outletsCollection);
      print('OutletService: Collection: ${collection.collectionName}');
      final list = await collection.find().toList();
      print('OutletService: Found ${list.length} documents');
      final outlets = list.map((item) => Outlet.fromJson(item)).toList();
      print('OutletService: Parsed ${outlets.length} outlets');
      return outlets;
    } catch (e, stackTrace) {
      print('OutletService Error: $e');
      print('StackTrace: $stackTrace');
      rethrow; // Allow provider to handle the error state
    }
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
