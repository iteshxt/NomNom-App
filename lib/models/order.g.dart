// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      id: json['id'] as String,
      userId: json['userId'] as String,
      outletId: json['outletId'] as String,
      outletName: json['outletName'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: $enumDecode(_$OrderStatusEnumMap, json['status']),
      total: (json['total'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      orderNumber: json['orderNumber'] as String,
      estimatedPickupTime: (json['estimatedPickupTime'] as num).toInt(),
      paymentMethod: json['paymentMethod'] as String? ?? 'mock',
      orderNotes: json['orderNotes'] as String?,
      pickedUpAt: json['pickedUpAt'] == null
          ? null
          : DateTime.parse(json['pickedUpAt'] as String),
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'outletId': instance.outletId,
      'outletName': instance.outletName,
      'items': instance.items,
      'status': _$OrderStatusEnumMap[instance.status]!,
      'total': instance.total,
      'createdAt': instance.createdAt.toIso8601String(),
      'orderNumber': instance.orderNumber,
      'estimatedPickupTime': instance.estimatedPickupTime,
      'paymentMethod': instance.paymentMethod,
      'orderNotes': instance.orderNotes,
      'pickedUpAt': instance.pickedUpAt?.toIso8601String(),
    };

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.confirmed: 'confirmed',
  OrderStatus.preparing: 'preparing',
  OrderStatus.ready: 'ready',
  OrderStatus.pickedUp: 'pickedUp',
};
