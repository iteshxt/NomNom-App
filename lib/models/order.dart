import 'order_item.dart';

enum OrderStatus { confirmed, preparing, ready, fulfilled }

class OrderStatusHistory {
  final String status;
  final DateTime timestamp;

  OrderStatusHistory({
    required this.status,
    required this.timestamp,
  });

  factory OrderStatusHistory.fromJson(Map<String, dynamic> json) {
    return OrderStatusHistory(
      status: json['status'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class Order {
  final String id;
  final String userId;
  final String outletId;
  final String outletName;
  final String? outletLocation;
  final List<OrderItem> items;
  final OrderStatus status;
  final double total;
  final DateTime createdAt;
  final String orderNumber;
  final int estimatedPickupTime;
  final String paymentMethod;
  final String? orderNotes;
  final DateTime? pickedUpAt;
  final List<OrderStatusHistory>? statusHistory;
  final DateTime? lastUpdate;

  Order({
    required this.id,
    required this.userId,
    required this.outletId,
    required this.outletName,
    this.outletLocation,
    required this.items,
    required this.status,
    required this.total,
    required this.createdAt,
    required this.orderNumber,
    required this.estimatedPickupTime,
    this.paymentMethod = 'mock',
    this.orderNotes,
    this.pickedUpAt,
    this.statusHistory,
    this.lastUpdate,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      userId: json['userId'] as String,
      outletId: json['outletId'] as String,
      outletName: json['outletName'] as String,
      outletLocation: json['outletLocation'] as String?,
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => OrderStatus.confirmed,
      ),
      total: (json['total'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      orderNumber: json['orderNumber'] as String,
      estimatedPickupTime: json['estimatedPickupTime'] as int,
      paymentMethod: json['paymentMethod'] as String? ?? 'mock',
      orderNotes: json['orderNotes'] as String?,
      pickedUpAt: json['pickedUpAt'] != null
          ? DateTime.parse(json['pickedUpAt'] as String)
          : null,
      statusHistory: (json['statusHistory'] as List?)
          ?.map((item) =>
              OrderStatusHistory.fromJson(item as Map<String, dynamic>))
          .toList(),
      lastUpdate: json['lastUpdate'] != null
          ? DateTime.parse(json['lastUpdate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'outletId': outletId,
      'outletName': outletName,
      'outletLocation': outletLocation,
      'items': items.map((item) => item.toJson()).toList(),
      'status': status.toString().split('.').last,
      'total': total,
      'createdAt': createdAt.toIso8601String(),
      'orderNumber': orderNumber,
      'estimatedPickupTime': estimatedPickupTime,
      'paymentMethod': paymentMethod,
      'orderNotes': orderNotes,
      'pickedUpAt': pickedUpAt?.toIso8601String(),
      'statusHistory': statusHistory?.map((h) => h.toJson()).toList(),
      'lastUpdate': lastUpdate?.toIso8601String(),
    };
  }

  // Utility getters
  DateTime get estimatedPickupDateTime =>
      createdAt.add(Duration(minutes: estimatedPickupTime));

  int get minutesRemaining {
    final remaining =
        estimatedPickupDateTime.difference(DateTime.now()).inMinutes;
    return remaining > 0 ? remaining : 0;
  }

  bool get isReady => status == OrderStatus.ready;

  // Compatibility getters
  String get currentStatus => status.toString().split('.').last;
  double get totalAmount => total;

  Order copyWith({
    String? id,
    String? userId,
    String? outletId,
    String? outletName,
    String? outletLocation,
    List<OrderItem>? items,
    OrderStatus? status,
    double? total,
    DateTime? createdAt,
    String? orderNumber,
    int? estimatedPickupTime,
    String? paymentMethod,
    String? orderNotes,
    DateTime? pickedUpAt,
    List<OrderStatusHistory>? statusHistory,
    DateTime? lastUpdate,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      outletId: outletId ?? this.outletId,
      outletName: outletName ?? this.outletName,
      outletLocation: outletLocation ?? this.outletLocation,
      items: items ?? this.items,
      status: status ?? this.status,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
      orderNumber: orderNumber ?? this.orderNumber,
      estimatedPickupTime: estimatedPickupTime ?? this.estimatedPickupTime,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      orderNotes: orderNotes ?? this.orderNotes,
      pickedUpAt: pickedUpAt ?? this.pickedUpAt,
      statusHistory: statusHistory ?? this.statusHistory,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}
