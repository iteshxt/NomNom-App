import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/index.dart';
import 'service_providers.dart';

// Selected Outlet Provider
final selectedOutletProvider = StateProvider<String?>((ref) {
  return null;
});

// Selected Category Provider
final selectedCategoryProvider = StateProvider<String>((ref) {
  return 'All';
});
final outletsProvider = FutureProvider<List<Outlet>>((ref) async {
  final outletService = ref.watch(outletServiceProvider);
  return await outletService.getOutlets();
});

// Specific Outlet Provider
final outletProvider =
    FutureProvider.family<Outlet?, String>((ref, outletId) async {
  final outletService = ref.watch(outletServiceProvider);
  return await outletService.getOutletById(outletId);
});

// Menu by Selected Outlet Provider
final menuProvider = FutureProvider<List<MenuItem>>((ref) async {
  final menuService = ref.watch(menuServiceProvider);
  final selectedOutletId = ref.watch(selectedOutletProvider);

  if (selectedOutletId == null) return [];

  return await menuService.getMenuByOutlet(selectedOutletId);
});

// Categories for Selected Outlet Provider
final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final menuService = ref.watch(menuServiceProvider);
  final selectedOutletId = ref.watch(selectedOutletProvider);

  if (selectedOutletId == null) return [];

  return await menuService.getCategoriesByOutlet(selectedOutletId);
});

// Items by Category Provider
final itemsByCategoryProvider =
    FutureProvider.family<List<MenuItem>, String>((ref, category) async {
  final menuService = ref.watch(menuServiceProvider);
  final selectedOutletId = ref.watch(selectedOutletProvider);

  if (selectedOutletId == null) return [];

  return await menuService.filterByCategory(selectedOutletId, category);
});

// Search Menu Provider
final searchMenuProvider =
    FutureProvider.family<List<MenuItem>, String>((ref, query) async {
  final menuService = ref.watch(menuServiceProvider);
  final selectedOutletId = ref.watch(selectedOutletProvider);

  if (selectedOutletId == null || query.isEmpty) return [];

  return await menuService.searchItems(selectedOutletId, query);
});

// Item Detail Provider
final itemDetailProvider =
    FutureProvider.family<MenuItem?, String>((ref, itemId) async {
  final menuService = ref.watch(menuServiceProvider);
  final selectedOutletId = ref.watch(selectedOutletProvider);

  if (selectedOutletId == null) return null;

  return await menuService.getItemDetail(selectedOutletId, itemId);
});
