import 'package:json_annotation/json_annotation.dart';

part 'order_item.g.dart';

@JsonSerializable()
class OrderItem {
  final String itemId;
  final String itemName;
  final double price;
  final int quantity;
  final String? specialInstructions;
  final DateTime addedAt;

  OrderItem({
    required this.itemId,
    required this.itemName,
    required this.price,
    required this.quantity,
    this.specialInstructions,
    required this.addedAt,
  });

  double get totalPrice => price * quantity;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);

  OrderItem copyWith({
    String? itemId,
    String? itemName,
    double? price,
    int? quantity,
    String? specialInstructions,
    DateTime? addedAt,
  }) {
    return OrderItem(
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}
