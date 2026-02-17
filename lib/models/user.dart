class User {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String? profilePhoto;
  final bool pushNotificationEnabled;
  final List<String>? dietaryPreferences;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.phone = '',
    this.profilePhoto,
    this.pushNotificationEnabled = true,
    this.dietaryPreferences,
  });

  // Compatibility getters
  bool get pushNotificationsEnabled => pushNotificationEnabled;
  bool get isGuest => false; // Users from Firebase are not guests

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String? ?? '',
      profilePhoto: json['profilePhoto'] as String?,
      pushNotificationEnabled: json['pushNotificationEnabled'] as bool? ?? true,
      dietaryPreferences: (json['dietaryPreferences'] as List?)?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'profilePhoto': profilePhoto,
      'pushNotificationEnabled': pushNotificationEnabled,
      'dietaryPreferences': dietaryPreferences,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? profilePhoto,
    bool? pushNotificationEnabled,
    List<String>? dietaryPreferences,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      pushNotificationEnabled:
          pushNotificationEnabled ?? this.pushNotificationEnabled,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
    );
  }
}
