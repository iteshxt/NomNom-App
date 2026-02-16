import 'order_item.dart';

enum OrderStatus { pending, preparing, ready, completed, cancelled }

class Order {
  final String id;
  final String userId;
  final String outletId;
  final List<OrderItem> items;
  final double totalAmount;
  final OrderStatus status;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.userId,
    required this.outletId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  Order copyWith({OrderStatus? status}) {
    return Order(
      id: id,
      userId: userId,
      outletId: outletId,
      items: items,
      totalAmount: totalAmount,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}
