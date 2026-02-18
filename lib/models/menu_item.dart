class MenuItem {
  final String id;
  final String outletId;
  final String name;
  final String description;
  final double price;
  final String image;
  final String category;
  final List<String> tags;
  final bool isAvailable;

  MenuItem({
    required this.id,
    required this.outletId,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    required this.tags,
    this.isAvailable = true,
  });

  // Compatibility getter
  bool get availability => isAvailable;

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: (json['id'] ?? json['itemId']) as String,
      outletId: json['outletId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
      category: json['category'] as String,
      tags: (json['tags'] as List).cast<String>(),
      isAvailable:
          (json['isAvailable'] ?? json['availability']) as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'outletId': outletId,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
      'tags': tags,
      'isAvailable': isAvailable,
    };
  }
}
