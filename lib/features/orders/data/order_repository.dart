import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order.dart';

class OrderRepository {
  // Mock In-Memory Store
  final List<Order> _orders = [];

  Future<void> createOrder(Order order) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate API
    _orders.add(order);
  }

  Future<List<Order>> fetchOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_orders); // Return copy
  }

  Stream<List<Order>> watchOrders() async* {
    while (true) {
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Faster updates for UI responsiveness
      yield List.from(_orders);
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(status: status);
    }
  }
}

final orderRepositoryProvider = Provider((ref) => OrderRepository());

final ordersProvider = StreamProvider<List<Order>>((ref) {
  return ref.watch(orderRepositoryProvider).watchOrders();
});
