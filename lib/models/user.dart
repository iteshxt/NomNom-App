import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String? profilePhoto;
  final List<String> dietaryPreferences;
  final bool pushNotificationEnabled;
  final String? lastOrderId;
  final bool isGuest;

  // Alias for compatibility
  bool get pushNotificationsEnabled => pushNotificationEnabled;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    this.profilePhoto,
    this.dietaryPreferences = const [],
    this.pushNotificationEnabled = true,
    this.lastOrderId,
    this.isGuest = false,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? profilePhoto,
    List<String>? dietaryPreferences,
    bool? pushNotificationEnabled,
    String? lastOrderId,
    bool? isGuest,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      pushNotificationEnabled:
          pushNotificationEnabled ?? this.pushNotificationEnabled,
      lastOrderId: lastOrderId ?? this.lastOrderId,
      isGuest: isGuest ?? this.isGuest,
    );
  }
}
