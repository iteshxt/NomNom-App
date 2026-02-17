import 'database_service.dart';
import '../models/index.dart';

class MenuService {
  Future<List<MenuItem>> getMenuByOutlet(String outletId) async {
    try {
      final db = await DatabaseService.db;
      final collection = db.collection(DatabaseService.menuCollection);
      final list = await collection.find({'outletId': outletId}).toList();
      return list.map((item) => MenuItem.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<MenuItem?> getItemDetail(String outletId, String itemId) async {
    try {
      final db = await DatabaseService.db;
      final collection = db.collection(DatabaseService.menuCollection);
      final item = await collection.findOne({
        'outletId': outletId,
        'id': itemId,
      });
      if (item != null) {
        return MenuItem.fromJson(item);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MenuItem>> searchItems(String outletId, String query) async {
    try {
      final db = await DatabaseService.db;
      final collection = db.collection(DatabaseService.menuCollection);
      final list = await collection.find({
        'outletId': outletId,
        '\$or': [
          {
            'name': {'\$regex': query, '\$options': 'i'}
          },
          {
            'description': {'\$regex': query, '\$options': 'i'}
          },
        ]
      }).toList();
      return list.map((item) => MenuItem.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> getCategoriesByOutlet(String outletId) async {
    try {
      final db = await DatabaseService.db;
      final collection = db.collection(DatabaseService.menuCollection);
      final pipeline = [
        {
          '\$match': {'outletId': outletId}
        },
        {
          '\$group': {
            '_id': '\$category',
          }
        }
      ];
      final result = await collection.aggregateToStream(pipeline).toList();
      return result.map((item) => item['_id'] as String).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MenuItem>> filterByCategory(
      String outletId, String category) async {
    try {
      final db = await DatabaseService.db;
      final collection = db.collection(DatabaseService.menuCollection);
      final list = await collection.find({
        'outletId': outletId,
        'category': category,
      }).toList();
      return list.map((item) => MenuItem.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MenuItem>> filterByTag(String outletId, String tag) async {
    try {
      final db = await DatabaseService.db;
      final collection = db.collection(DatabaseService.menuCollection);
      final list = await collection.find({
        'outletId': outletId,
        'tags': tag,
      }).toList();
      return list.map((item) => MenuItem.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
