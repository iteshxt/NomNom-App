class OrderItem {
  final String menuItemId;
  final String name;
  final int quantity;
  final double price;
  final String? image;
  final String? specialInstructions;

  OrderItem({
    required this.menuItemId,
    required this.name,
    required this.quantity,
    required this.price,
    this.image,
    this.specialInstructions,
  });

  // Compatibility getters
  double get total => price * quantity;
  double get totalPrice => total;
  String get itemId => menuItemId;
  String get itemName => name;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      menuItemId: json['menuItemId'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String?,
      specialInstructions: json['specialInstructions'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuItemId': menuItemId,
      'name': name,
      'quantity': quantity,
      'price': price,
      'image': image,
      'specialInstructions': specialInstructions,
    };
  }

  OrderItem copyWith({
    String? menuItemId,
    String? name,
    int? quantity,
    double? price,
    String? image,
    String? specialInstructions,
  }) {
    return OrderItem(
      menuItemId: menuItemId ?? this.menuItemId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      image: image ?? this.image,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }
}
