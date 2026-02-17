// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      profilePhoto: json['profilePhoto'] as String?,
      dietaryPreferences: (json['dietaryPreferences'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      pushNotificationEnabled: json['pushNotificationEnabled'] as bool? ?? true,
      lastOrderId: json['lastOrderId'] as String?,
      isGuest: json['isGuest'] as bool? ?? false,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'phone': instance.phone,
      'profilePhoto': instance.profilePhoto,
      'dietaryPreferences': instance.dietaryPreferences,
      'pushNotificationEnabled': instance.pushNotificationEnabled,
      'lastOrderId': instance.lastOrderId,
      'isGuest': instance.isGuest,
    };
