import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/index.dart';
import '../services/index.dart';
import 'service_providers.dart';
import 'auth_provider.dart';

// Order History Provider
final orderHistoryProvider = FutureProvider<List<Order>>((ref) async {
  final user = ref.watch(authStateProvider);
  final orderService = ref.read(orderServiceProvider);

  if (user == null) return [];

  return await orderService.getOrderHistory(user.id);
});

// Order Tracking Provider
final orderTrackingProvider =
    StateNotifierProvider<OrderTrackingNotifier, Map<String, OrderTracking>>(
        (ref) {
  final orderService = ref.watch(orderServiceProvider);
  return OrderTrackingNotifier(orderService);
});

// Specific Order Tracking Provider
final specificOrderTrackingProvider =
    StreamProvider.family<OrderTracking?, String>((ref, orderId) async* {
  final orderService = ref.watch(orderServiceProvider);

  // Polling every 3 seconds for order status updates
  while (true) {
    final tracking = await orderService.getOrderTracking(orderId);
    yield tracking;
    await Future.delayed(const Duration(seconds: 3));
  }
});

// Create Order Provider
class OrderTrackingNotifier extends StateNotifier<Map<String, OrderTracking>> {
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

  Future<OrderTracking?> getOrderTracking(String orderId) async {
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
