import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/index.dart';
import 'outlet_service.dart';

class OrderService {
  List<Order> _orders = [];
  final Map<String, OrderTracking> _orderTracking = {};
  final OutletService _outletService;

  OrderService(this._outletService);

  Future<void> loadMockData() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/orders.json');
      final jsonData = jsonDecode(jsonString) as List;

      _orders = jsonData
          .map((item) => Order.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _orders = [];
    }
  }

  Future<Order> createOrder({
    required String userId,
    required String outletId,
    required List<OrderItem> items,
    required double total,
    required int estimatedPickupTime,
    String? orderNotes,
  }) async {
    final orderNumber =
        '#${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}';

    // Get outlet details
    final outlet = await _outletService.getOutletById(outletId);

    final order = Order(
      id: 'order_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      outletId: outletId,
      outletName: outlet?.name ?? 'Unknown Outlet',
      items: items,
      status: OrderStatus.confirmed,
      total: total,
      createdAt: DateTime.now(),
      orderNumber: orderNumber,
      estimatedPickupTime: estimatedPickupTime,
      paymentMethod: 'mock',
      orderNotes: orderNotes,
    );

    _orders.add(order);

    // Initialize tracking with full details
    _orderTracking[order.id] = OrderTracking(
      orderId: order.id,
      orderNumber: orderNumber,
      outletName: outlet?.name ?? 'Unknown Outlet',
      outletLocation: outlet?.campusLocation ?? 'Unknown Location',
      items: items,
      totalAmount: total,
      currentStatus: 'confirmed',
      statusHistory: [
        OrderStatusHistory(
          status: 'confirmed',
          timestamp: DateTime.now(),
        ),
      ],
      estimatedPickupDateTime: DateTime.now().add(
        Duration(minutes: estimatedPickupTime),
      ),
      estimatedPickupTime: estimatedPickupTime,
      lastUpdate: DateTime.now(),
    );

    return order;
  }

  Future<Order?> getOrderById(String orderId) async {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  Future<List<Order>> getOrderHistory(String userId) async {
    return _orders.where((order) => order.userId == userId).toList();
  }

  Future<OrderTracking?> getOrderTracking(String orderId) async {
    return _orderTracking[orderId];
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    final orderIndex = _orders.indexWhere((o) => o.id == orderId);
    if (orderIndex != -1) {
      final updatedOrder = _orders[orderIndex].copyWith(status: status);
      _orders[orderIndex] = updatedOrder;

      // Update tracking
      final tracking = _orderTracking[orderId];
      if (tracking != null) {
        _orderTracking[orderId] = tracking.copyWith(
          currentStatus: status.toString().split('.').last,
          statusHistory: [
            ...tracking.statusHistory,
            OrderStatusHistory(
              status: status.toString().split('.').last,
              timestamp: DateTime.now(),
            ),
          ],
          lastUpdate: DateTime.now(),
          actualPickupTime:
              status == OrderStatus.pickedUp ? DateTime.now() : null,
        );
      }
    }
  }

  Future<void> markAsPickedUp(String orderId) async {
    await updateOrderStatus(orderId, OrderStatus.pickedUp);
  }

  // Extension on OrderTracking for copyWith
}

extension OrderTrackingCopyWith on OrderTracking {
  OrderTracking copyWith({
    String? orderId,
    String? orderNumber,
    String? outletName,
    String? outletLocation,
    List<OrderItem>? items,
    double? totalAmount,
    String? currentStatus,
    List<OrderStatusHistory>? statusHistory,
    DateTime? estimatedPickupDateTime,
    int? estimatedPickupTime,
    DateTime? actualPickupTime,
    DateTime? lastUpdate,
  }) {
    return OrderTracking(
      orderId: orderId ?? this.orderId,
      orderNumber: orderNumber ?? this.orderNumber,
      outletName: outletName ?? this.outletName,
      outletLocation: outletLocation ?? this.outletLocation,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      currentStatus: currentStatus ?? this.currentStatus,
      statusHistory: statusHistory ?? this.statusHistory,
      estimatedPickupDateTime:
          estimatedPickupDateTime ?? this.estimatedPickupDateTime,
      estimatedPickupTime: estimatedPickupTime ?? this.estimatedPickupTime,
      actualPickupTime: actualPickupTime ?? this.actualPickupTime,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}
