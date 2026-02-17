import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/index.dart';

class MenuService {
  Map<String, List<MenuItem>> _menuByOutlet = {};
  bool _loaded = false;

  Future<void> loadMenus() async {
    if (_loaded) return;

    try {
      final jsonString = await rootBundle.loadString('assets/data/menu.json');
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;

      jsonData.forEach((outletId, items) {
        _menuByOutlet[outletId] = (items as List)
            .map((item) => MenuItem.fromJson(item as Map<String, dynamic>))
            .toList();
      });

      _loaded = true;
    } catch (e) {
      _menuByOutlet = {};
    }
  }

  Future<List<MenuItem>> getMenuByOutlet(String outletId) async {
    await loadMenus();
    return _menuByOutlet[outletId] ?? [];
  }

  Future<MenuItem?> getItemDetail(String outletId, String itemId) async {
    final menu = await getMenuByOutlet(outletId);
    try {
      return menu.firstWhere((item) => item.id == itemId);
    } catch (e) {
      return null;
    }
  }

  Future<List<MenuItem>> searchItems(String outletId, String query) async {
    final menu = await getMenuByOutlet(outletId);
    return menu
        .where((item) =>
            item.name.toLowerCase().contains(query.toLowerCase()) ||
            item.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<List<String>> getCategoriesByOutlet(String outletId) async {
    final menu = await getMenuByOutlet(outletId);
    final categories = <String>{};
    for (final item in menu) {
      categories.add(item.category);
    }
    return categories.toList();
  }

  Future<List<MenuItem>> filterByCategory(
      String outletId, String category) async {
    final menu = await getMenuByOutlet(outletId);
    return menu.where((item) => item.category == category).toList();
  }

  Future<List<MenuItem>> filterByTag(String outletId, String tag) async {
    final menu = await getMenuByOutlet(outletId);
    return menu.where((item) => item.tags.contains(tag)).toList();
  }
}
