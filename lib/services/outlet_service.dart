import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/index.dart';

class OutletService {
  List<Outlet> _outlets = [];
  bool _loaded = false;

  Future<void> loadOutlets() async {
    if (_loaded) return;

    try {
      final jsonString =
          await rootBundle.loadString('assets/data/outlets.json');
      final jsonData = jsonDecode(jsonString) as List;

      _outlets = jsonData
          .map((item) => Outlet.fromJson(item as Map<String, dynamic>))
          .toList();

      _loaded = true;
    } catch (e) {
      _outlets = [];
    }
  }

  Future<List<Outlet>> getOutlets() async {
    await loadOutlets();
    return _outlets;
  }

  Future<Outlet?> getOutletById(String id) async {
    await loadOutlets();
    try {
      return _outlets.firstWhere((outlet) => outlet.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Outlet> searchOutlets(String query) {
    return _outlets
        .where((outlet) =>
            outlet.name.toLowerCase().contains(query.toLowerCase()) ||
            outlet.cuisineType.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
