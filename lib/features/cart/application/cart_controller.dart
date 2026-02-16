import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../menu/models/menu_item.dart';
import '../models/cart.dart';
import '../models/cart_item.dart';

class CartNotifier extends Notifier<Cart> {
  @override
  Cart build() {
    return const Cart();
  }

  void addItem(MenuItem item) {
    // If cart has items from another outlet, clear it first (or warn, here we auto-clear for simplicity MVP)
    if (state.outletId != null && state.outletId != item.outletId) {
      state = Cart(outletId: item.outletId, items: []);
    }

    final currentItems = List<CartItem>.from(state.items);
    final index = currentItems.indexWhere((i) => i.menuItem.id == item.id);

    if (index >= 0) {
      currentItems[index] = currentItems[index].copyWith(
        quantity: currentItems[index].quantity + 1,
      );
    } else {
      currentItems.add(CartItem(menuItem: item));
    }

    state = state.copyWith(outletId: item.outletId, items: currentItems);
  }

  void removeItem(String itemId) {
    final currentItems = List<CartItem>.from(state.items);
    final index = currentItems.indexWhere((i) => i.menuItem.id == itemId);

    if (index >= 0) {
      if (currentItems[index].quantity > 1) {
        currentItems[index] = currentItems[index].copyWith(
          quantity: currentItems[index].quantity - 1,
        );
      } else {
        currentItems.removeAt(index);
      }
      state = state.copyWith(items: currentItems);

      if (currentItems.isEmpty) {
        state = const Cart();
      }
    }
  }

  void clear() {
    state = const Cart();
  }
}

final cartProvider = NotifierProvider<CartNotifier, Cart>(CartNotifier.new);
