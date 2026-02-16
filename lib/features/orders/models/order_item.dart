import '../../menu/models/menu_item.dart';

class OrderItem {
  final MenuItem menuItem;
  final int quantity;
  final double priceAtOrder; // Store price at time of order

  const OrderItem({
    required this.menuItem,
    required this.quantity,
    required this.priceAtOrder,
  });

  double get totalPrice => priceAtOrder * quantity;

  Map<String, dynamic> toMap() {
    return {
      'menuItem': menuItem
          .id, // Only ID in full DB, but for now we might need full obj if not normalized
      // For mock simplicity, we keep it simple.
      'quantity': quantity,
      'priceAtOrder': priceAtOrder,
    };
  }
}
