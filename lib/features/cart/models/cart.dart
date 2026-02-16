import 'cart_item.dart';

class Cart {
  final String? outletId;
  final List<CartItem> items;

  const Cart({this.outletId, this.items = const []});

  double get totalAmount => items.fold(0, (sum, item) => sum + item.totalPrice);
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  Cart copyWith({String? outletId, List<CartItem>? items}) {
    return Cart(
      outletId: outletId ?? this.outletId,
      items: items ?? this.items,
    );
  }
}
