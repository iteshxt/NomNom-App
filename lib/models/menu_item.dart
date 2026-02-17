import 'package:json_annotation/json_annotation.dart';

part 'menu_item.g.dart';

@JsonSerializable()
class MenuItem {
  final String id;
  final String outletId;
  final String name;
  final String description;
  final double price;
  final String image;
  final String category; // 'Pizzas', 'Burgers', etc.
  final List<String> tags; // ['vegan', 'spicy', 'veg', etc.]
  final bool availability;
  final int prepTime; // minutes

  MenuItem({
    required this.id,
    required this.outletId,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    this.tags = const [],
    this.availability = true,
    this.prepTime = 15,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      _$MenuItemFromJson(json);
  Map<String, dynamic> toJson() => _$MenuItemToJson(this);
}
