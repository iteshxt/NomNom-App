class Outlet {
  final String id;
  final String name;
  final String logo;
  final String campusLocation;
  final double rating;
  final int ratingCount;
  final bool isOpen;
  final String openingTime;
  final String closingTime;

  Outlet({
    required this.id,
    required this.name,
    required this.logo,
    required this.campusLocation,
    required this.rating,
    required this.ratingCount,
    required this.isOpen,
    required this.openingTime,
    required this.closingTime,
  });

  // Compatibility getters
  String get hoursOfOperation => '$openingTime - $closingTime';
  String get cuisineType => 'Campus Dining'; // Default value

  factory Outlet.fromJson(Map<String, dynamic> json) {
    try {
      return Outlet(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? 'Unknown Outlet',
        logo: json['logo']?.toString() ?? '',
        campusLocation: json['campusLocation']?.toString() ?? 'Campus',
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
        isOpen: json['isOpen'] as bool? ?? true,
        // Handle the case where openingTime/closingTime might be missing or inside hoursOfOperation
        openingTime: json['openingTime']?.toString() ?? '8:00 AM',
        closingTime: json['closingTime']?.toString() ?? '8:00 PM',
      );
    } catch (e) {
      print('Error parsing Outlet: $e JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'campusLocation': campusLocation,
      'rating': rating,
      'ratingCount': ratingCount,
      'isOpen': isOpen,
      'openingTime': openingTime,
      'closingTime': closingTime,
    };
  }
}
