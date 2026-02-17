// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
      itemId: json['itemId'] as String,
      itemName: json['itemName'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      specialInstructions: json['specialInstructions'] as String?,
      addedAt: DateTime.parse(json['addedAt'] as String),
    );

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'price': instance.price,
      'quantity': instance.quantity,
      'specialInstructions': instance.specialInstructions,
      'addedAt': instance.addedAt.toIso8601String(),
    };
