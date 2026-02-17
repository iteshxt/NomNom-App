import 'package:json_annotation/json_annotation.dart';
import 'order_item.dart';

part 'order.g.dart';

enum OrderStatus { pending, confirmed, preparing, ready, pickedUp }

@JsonSerializable()
class Order {
  final String id;
  final String userId;
  final String outletId;
  final String outletName;
  final List<OrderItem> items;
  final OrderStatus status;
  final double total;
  final DateTime createdAt;
  final String orderNumber; // Display number like '#1247'
  final int estimatedPickupTime; // minutes
  final String paymentMethod; // 'mock', 'card', etc.
  final String? orderNotes;
  final DateTime? pickedUpAt;

  Order({
    required this.id,
    required this.userId,
    required this.outletId,
    required this.outletName,
    required this.items,
    required this.status,
    required this.total,
    required this.createdAt,
    required this.orderNumber,
    required this.estimatedPickupTime,
    this.paymentMethod = 'mock',
    this.orderNotes,
    this.pickedUpAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);

  Order copyWith({
    String? id,
    String? userId,
    String? outletId,
    String? outletName,
    List<OrderItem>? items,
    OrderStatus? status,
    double? total,
    DateTime? createdAt,
    String? orderNumber,
    int? estimatedPickupTime,
    String? paymentMethod,
    String? orderNotes,
    DateTime? pickedUpAt,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      outletId: outletId ?? this.outletId,
      outletName: outletName ?? this.outletName,
      items: items ?? this.items,
      status: status ?? this.status,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
      orderNumber: orderNumber ?? this.orderNumber,
      estimatedPickupTime: estimatedPickupTime ?? this.estimatedPickupTime,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      orderNotes: orderNotes ?? this.orderNotes,
      pickedUpAt: pickedUpAt ?? this.pickedUpAt,
    );
  }
}
