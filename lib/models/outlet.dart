import 'package:json_annotation/json_annotation.dart';

part 'outlet.g.dart';

@JsonSerializable()
class HoursOfOperation {
  final String day; // 'Monday', 'Tuesday', etc.
  final String open; // '10:00 AM'
  final String close; // '7:00 PM'
  final bool isClosed;

  HoursOfOperation({
    required this.day,
    required this.open,
    required this.close,
    this.isClosed = false,
  });

  factory HoursOfOperation.fromJson(Map<String, dynamic> json) =>
      _$HoursOfOperationFromJson(json);
  Map<String, dynamic> toJson() => _$HoursOfOperationToJson(this);
}

@JsonSerializable()
class Outlet {
  final String id;
  final String name;
  final String logo;
  final double rating; // 0-5
  final int ratingCount;
  final bool isOpen;
  final List<HoursOfOperation> hoursOfOperation;
  final String cuisineType; // 'Italian, Fast Food'
  final String campusLocation; // 'Near Library'
  final double latitude;
  final double longitude;

  Outlet({
    required this.id,
    required this.name,
    required this.logo,
    required this.rating,
    required this.ratingCount,
    required this.isOpen,
    required this.hoursOfOperation,
    required this.cuisineType,
    required this.campusLocation,
    required this.latitude,
    required this.longitude,
  });

  factory Outlet.fromJson(Map<String, dynamic> json) => _$OutletFromJson(json);
  Map<String, dynamic> toJson() => _$OutletToJson(this);
}
