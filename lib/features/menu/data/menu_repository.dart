import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/outlet.dart';
import '../models/menu_item.dart';

class MenuRepository {
  // Mock Data
  final List<Outlet> _outlets = [
    const Outlet(
      id: '1',
      name: 'Oven Express',
      imageUrl: 'https://placehold.co/600x400/png?text=Oven+Express',
      categories: ['Snacks', 'Meals', 'Beverages'],
    ),
    const Outlet(
      id: '2',
      name: 'Kitchenette',
      imageUrl: 'https://placehold.co/600x400/png?text=Kitchenette',
      categories: ['Breakfast', 'Lunch', 'Drinks'],
    ),
  ];

  final List<MenuItem> _menuItems = [
    const MenuItem(
      id: '101',
      outletId: '1',
      name: 'Chicken Burger',
      description: 'Crispy chicken patty with lettuce and mayo',
      price: 120,
      imageUrl: 'https://placehold.co/400x300/png?text=Burger',
      category: 'Snacks',
    ),
    const MenuItem(
      id: '102',
      outletId: '1',
      name: 'French Fries',
      description: 'Golden salted fries',
      price: 60,
      imageUrl: 'https://placehold.co/400x300/png?text=Fries',
      category: 'Snacks',
    ),
    const MenuItem(
      id: '103',
      outletId: '1',
      name: 'Cola',
      description: 'Chilled soft drink',
      price: 40,
      imageUrl: 'https://placehold.co/400x300/png?text=Cola',
      category: 'Beverages',
    ),
    const MenuItem(
      id: '201',
      outletId: '2',
      name: 'Aloo Paratha',
      description: 'Stuffed potato flatbread with curd',
      price: 80,
      imageUrl: 'https://placehold.co/400x300/png?text=Paratha',
      category: 'Breakfast',
    ),
  ];

  Future<List<Outlet>> fetchOutlets() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate net
    return _outlets;
  }

  Future<List<MenuItem>> fetchMenu(String outletId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _menuItems.where((item) => item.outletId == outletId).toList();
  }
}

final menuRepositoryProvider = Provider((ref) => MenuRepository());

final outletsProvider = FutureProvider<List<Outlet>>((ref) async {
  return ref.watch(menuRepositoryProvider).fetchOutlets();
});

final menuProvider = FutureProvider.family<List<MenuItem>, String>((
  ref,
  outletId,
) async {
  return ref.watch(menuRepositoryProvider).fetchMenu(outletId);
});
