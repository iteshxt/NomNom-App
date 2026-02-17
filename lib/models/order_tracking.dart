import 'package:json_annotation/json_annotation.dart';
import 'order_item.dart';

part 'order_tracking.g.dart';

@JsonSerializable()
class OrderStatusHistory {
  final String status; // 'confirmed', 'preparing', 'ready', 'pickedUp'
  final DateTime timestamp;

  OrderStatusHistory({required this.status, required this.timestamp});

  factory OrderStatusHistory.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$OrderStatusHistoryToJson(this);
}

@JsonSerializable()
class OrderTracking {
  final String orderId;
  final String orderNumber; // Display number like '#1247'
  final String outletName;
  final String outletLocation;
  final List<OrderItem>? items;
  final double totalAmount;
  final String currentStatus; // 'confirmed', 'preparing', 'ready', 'pickedUp'
  final List<OrderStatusHistory> statusHistory;
  final DateTime estimatedPickupDateTime;
  final int estimatedPickupTime; // minutes
  final DateTime? actualPickupTime;
  final DateTime lastUpdate;

  OrderTracking({
    required this.orderId,
    required this.orderNumber,
    required this.outletName,
    required this.outletLocation,
    this.items,
    required this.totalAmount,
    required this.currentStatus,
    required this.statusHistory,
    required this.estimatedPickupDateTime,
    required this.estimatedPickupTime,
    this.actualPickupTime,
    required this.lastUpdate,
  });

  factory OrderTracking.fromJson(Map<String, dynamic> json) =>
      _$OrderTrackingFromJson(json);
  Map<String, dynamic> toJson() => _$OrderTrackingToJson(this);

  // Utility: Get remaining time in minutes
  int get minutesRemaining {
    final remaining =
        estimatedPickupDateTime.difference(DateTime.now()).inMinutes;
    return remaining > 0 ? remaining : 0;
  }

  bool get isReady => currentStatus == 'ready';

  // Alias for compatibility
  String get id => orderId;
}
