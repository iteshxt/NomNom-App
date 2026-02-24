import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/index.dart';
import '../services/index.dart';
import 'service_providers.dart';
import 'auth_provider.dart';

// Provider to manually trigger a refresh of order history
final orderHistoryTriggerProvider = StateProvider<int>((ref) => 0);

// Order History Provider
final orderHistoryProvider = StreamProvider<List<Order>>((ref) async* {
  ref.watch(orderHistoryTriggerProvider); // Watch for manual triggers
  final user = ref.watch(authStateProvider);
  final orderService = ref.watch(orderServiceProvider);

  if (user == null) {
    yield [];
    return;
  }

  // Polling every 10 seconds for history updates
  while (true) {
    try {
      final orders = await orderService.getOrderHistory(user.id);
      yield orders;
    } catch (e) {
      // Keep existing data on error
      // If no data yet, it stays in loading state (AsyncLoading)
      print('OrderHistoryProvider: Failed to fetch orders: $e');
    }
    await Future.delayed(const Duration(seconds: 10));
  }
});

// Order Tracking Provider
final orderTrackingProvider =
    StateNotifierProvider<OrderTrackingNotifier, Map<String, Order>>((ref) {
  final orderService = ref.watch(orderServiceProvider);
  return OrderTrackingNotifier(orderService);
});

// Specific Order Tracking Provider
final specificOrderTrackingProvider =
    StreamProvider.family<Order?, String>((ref, orderId) async* {
  final orderService = ref.watch(orderServiceProvider);

  // Polling every 3 seconds for order status updates
  while (true) {
    try {
      final tracking = await orderService.getOrderTracking(orderId);
      // Only yield if we got a result (tracking or explicit null for not found)
      // If it throws (Network error), we catch below and don't yield, preserving old state.
      yield tracking;
    } catch (e) {
      // Log error but keep previous state
      print('OrderTrackingProvider: Failed to track order $orderId: $e');
    }
    await Future.delayed(const Duration(seconds: 3));
  }
});

// Create Order Provider
class OrderTrackingNotifier extends StateNotifier<Map<String, Order>> {
  final OrderService _orderService;

  OrderTrackingNotifier(this._orderService) : super({});

  Future<Order> createOrder({
    required String userId,
    required String outletId,
    required List<OrderItem> items,
    required double total,
    required int estimatedPickupTime,
    String? orderNotes,
  }) async {
    return await _orderService.createOrder(
      userId: userId,
      outletId: outletId,
      items: items,
      total: total,
      estimatedPickupTime: estimatedPickupTime,
      orderNotes: orderNotes,
    );
  }

  Future<Order?> getOrderTracking(String orderId) async {
    return await _orderService.getOrderTracking(orderId);
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _orderService.updateOrderStatus(orderId, status);
    // Refresh tracking data
    final tracking = await _orderService.getOrderTracking(orderId);
    if (tracking != null) {
      state = {...state, orderId: tracking};
    }
  }

  Future<void> markAsPickedUp(String orderId) async {
    await _orderService.markAsPickedUp(orderId);
    // Refresh tracking data
    final tracking = await _orderService.getOrderTracking(orderId);
    if (tracking != null) {
      state = {...state, orderId: tracking};
    }
  }
}
