// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_tracking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderStatusHistory _$OrderStatusHistoryFromJson(Map<String, dynamic> json) =>
    OrderStatusHistory(
      status: json['status'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$OrderStatusHistoryToJson(OrderStatusHistory instance) =>
    <String, dynamic>{
      'status': instance.status,
      'timestamp': instance.timestamp.toIso8601String(),
    };

OrderTracking _$OrderTrackingFromJson(Map<String, dynamic> json) =>
    OrderTracking(
      orderId: json['orderId'] as String,
      orderNumber: json['orderNumber'] as String,
      outletName: json['outletName'] as String,
      outletLocation: json['outletLocation'] as String,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      currentStatus: json['currentStatus'] as String,
      statusHistory: (json['statusHistory'] as List<dynamic>)
          .map((e) => OrderStatusHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
      estimatedPickupDateTime:
          DateTime.parse(json['estimatedPickupDateTime'] as String),
      estimatedPickupTime: (json['estimatedPickupTime'] as num).toInt(),
      actualPickupTime: json['actualPickupTime'] == null
          ? null
          : DateTime.parse(json['actualPickupTime'] as String),
      lastUpdate: DateTime.parse(json['lastUpdate'] as String),
    );

Map<String, dynamic> _$OrderTrackingToJson(OrderTracking instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'orderNumber': instance.orderNumber,
      'outletName': instance.outletName,
      'outletLocation': instance.outletLocation,
      'items': instance.items,
      'totalAmount': instance.totalAmount,
      'currentStatus': instance.currentStatus,
      'statusHistory': instance.statusHistory,
      'estimatedPickupDateTime':
          instance.estimatedPickupDateTime.toIso8601String(),
      'estimatedPickupTime': instance.estimatedPickupTime,
      'actualPickupTime': instance.actualPickupTime?.toIso8601String(),
      'lastUpdate': instance.lastUpdate.toIso8601String(),
    };
