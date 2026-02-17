// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outlet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HoursOfOperation _$HoursOfOperationFromJson(Map<String, dynamic> json) =>
    HoursOfOperation(
      day: json['day'] as String,
      open: json['open'] as String,
      close: json['close'] as String,
      isClosed: json['isClosed'] as bool? ?? false,
    );

Map<String, dynamic> _$HoursOfOperationToJson(HoursOfOperation instance) =>
    <String, dynamic>{
      'day': instance.day,
      'open': instance.open,
      'close': instance.close,
      'isClosed': instance.isClosed,
    };

Outlet _$OutletFromJson(Map<String, dynamic> json) => Outlet(
      id: json['id'] as String,
      name: json['name'] as String,
      logo: json['logo'] as String,
      rating: (json['rating'] as num).toDouble(),
      ratingCount: (json['ratingCount'] as num).toInt(),
      isOpen: json['isOpen'] as bool,
      hoursOfOperation: (json['hoursOfOperation'] as List<dynamic>)
          .map((e) => HoursOfOperation.fromJson(e as Map<String, dynamic>))
          .toList(),
      cuisineType: json['cuisineType'] as String,
      campusLocation: json['campusLocation'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$OutletToJson(Outlet instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'logo': instance.logo,
      'rating': instance.rating,
      'ratingCount': instance.ratingCount,
      'isOpen': instance.isOpen,
      'hoursOfOperation': instance.hoursOfOperation,
      'cuisineType': instance.cuisineType,
      'campusLocation': instance.campusLocation,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
