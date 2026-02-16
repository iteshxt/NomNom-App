import '../../menu/models/menu_item.dart';

class CartItem {
  final MenuItem menuItem;
  final int quantity;

  const CartItem({required this.menuItem, this.quantity = 1});

  double get totalPrice => menuItem.price * quantity;

  CartItem copyWith({MenuItem? menuItem, int? quantity}) {
    return CartItem(
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
    );
  }
}
