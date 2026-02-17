import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/index.dart';

class CurrentOrderState {
  final List<OrderItem> items;
  final String? outletId;

  const CurrentOrderState({
    this.items = const [],
    this.outletId,
  });

  CurrentOrderState copyWith({
    List<OrderItem>? items,
    String? outletId,
  }) {
    return CurrentOrderState(
      items: items ?? this.items,
      outletId: outletId ?? this.outletId,
    );
  }

  double get totalAmount => items.fold(0, (sum, item) => sum + item.totalPrice);
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}

class CurrentOrderNotifier extends StateNotifier<CurrentOrderState> {
  CurrentOrderNotifier() : super(const CurrentOrderState());

  void addItem(OrderItem item, String outletId) {
    if (state.outletId != null && state.outletId != outletId) {
      // Different outlet, clear previous items? Or warn user?
      // For now, let's clear and start fresh for simplicity, or handle elsewhere.
      // Assuming single outlet ordering for now.
      state = CurrentOrderState(items: [item], outletId: outletId);
    } else {
      final currentItems = List<OrderItem>.from(state.items);
      // Check if item already exists (same ID and instructions)
      final existingIndex = currentItems.indexWhere((i) =>
          i.itemId == item.itemId &&
          i.specialInstructions == item.specialInstructions);

      if (existingIndex >= 0) {
        final existingItem = currentItems[existingIndex];
        currentItems[existingIndex] = existingItem.copyWith(
          quantity: existingItem.quantity + item.quantity,
        );
      } else {
        currentItems.add(item);
      }
      state = state.copyWith(items: currentItems, outletId: outletId);
    }
  }

  void removeItem(OrderItem item) {
    final currentItems = List<OrderItem>.from(state.items);
    currentItems.remove(item);
    if (currentItems.isEmpty) {
      state = const CurrentOrderState(); // Clear outlet if empty
    } else {
      state = state.copyWith(items: currentItems);
    }
  }

  void updateQuantity(OrderItem item, int quantity) {
    if (quantity <= 0) {
      removeItem(item);
      return;
    }

    final currentItems = List<OrderItem>.from(state.items);
    final index = currentItems.indexOf(item);
    if (index >= 0) {
      currentItems[index] = item.copyWith(quantity: quantity);
      state = state.copyWith(items: currentItems);
    }
  }

  void clearOrder() {
    state = const CurrentOrderState();
  }
}

final currentOrderProvider =
    StateNotifierProvider<CurrentOrderNotifier, CurrentOrderState>((ref) {
  return CurrentOrderNotifier();
});
