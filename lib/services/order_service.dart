import 'package:mongo_dart/mongo_dart.dart' show where;
import 'database_service.dart';
import '../models/index.dart';
import 'outlet_service.dart';

class OrderService {
  final OutletService _outletService;

  OrderService(this._outletService);

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
      outletLocation: outlet?.campusLocation,
      items: items,
      status: OrderStatus.confirmed,
      total: total,
      createdAt: DateTime.now(),
      orderNumber: orderNumber,
      estimatedPickupTime: estimatedPickupTime,
      paymentMethod: 'mock',
      orderNotes: orderNotes,
      statusHistory: [
        OrderStatusHistory(
          status: 'confirmed',
          timestamp: DateTime.now(),
        ),
      ],
      lastUpdate: DateTime.now(),
    );

    try {
      final db = await DatabaseService.db;
      final ordersColl = db.collection(DatabaseService.ordersCollection);
      await ordersColl.insertOne(order.toJson());
    } catch (e) {
      // Log error or rethrow
    }

    return order;
  }

  Future<Order?> getOrderById(String orderId) async {
    try {
      final db = await DatabaseService.db;
      final collection = db.collection(DatabaseService.ordersCollection);
      final item = await collection.findOne({'id': orderId});
      if (item != null) {
        return Order.fromJson(item);
      }
      return null;
    } catch (e) {
      // Rethrow to let provider handle error (e.g. keep old data)
      rethrow;
    }
  }

  Future<List<Order>> getOrderHistory(String userId) async {
    try {
      final db = await DatabaseService.db;
      final collection = db.collection(DatabaseService.ordersCollection);
      final list = await collection
          .find(
              where.eq('userId', userId).sortBy('createdAt', descending: true))
          .toList();
      return list.map((item) => Order.fromJson(item)).toList();
    } catch (e) {
      // Don't return empty list on error, as it causes UI to show "No Orders"
      // instead of maintaining loading state or showing error.
      rethrow;
    }
  }

  Future<Order?> getOrderTracking(String orderId) async {
    // Now just returns the order itself since tracking is consolidated
    return getOrderById(orderId);
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      final db = await DatabaseService.db;
      final ordersColl = db.collection(DatabaseService.ordersCollection);

      // Get current order to update status history
      final currentOrder = await getOrderById(orderId);
      if (currentOrder == null) return;

      final statusStr = status.toString().split('.').last;
      final updatedHistory =
          List<OrderStatusHistory>.from(currentOrder.statusHistory ?? [])
            ..add(OrderStatusHistory(
              status: statusStr,
              timestamp: DateTime.now(),
            ));

      await ordersColl.updateOne(
        {'id': orderId},
        {
          '\$set': {
            'status': statusStr,
            'statusHistory': updatedHistory.map((h) => h.toJson()).toList(),
            'lastUpdate': DateTime.now().toIso8601String(),
            if (status == OrderStatus.fulfilled)
              'pickedUpAt': DateTime.now().toIso8601String(),
          }
        },
      );
    } catch (e) {
      // Log error
    }
  }

  Future<void> markAsPickedUp(String orderId) async {
    await updateOrderStatus(orderId, OrderStatus.fulfilled);
  }
}
