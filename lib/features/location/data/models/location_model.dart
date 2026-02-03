import 'package:hive/hive.dart';
import '../../domain/entities/location_entity.dart';

part 'location_model.g.dart'; // Generated file for Hive TypeAdapter

@HiveType(typeId: 1)
class LocationModel extends LocationEntity {
  @HiveField(0)
  final String addressField;

  @HiveField(1)
  final double? latitudeField;

  @HiveField(2)
  final double? longitudeField;

  @HiveField(3)
  final String? cityField;

  @HiveField(4)
  final String? countryField;

  @HiveField(5)
  final DateTime? timestamp;

  const LocationModel({
    required this.addressField,
    this.latitudeField,
    this.longitudeField,
    this.cityField,
    this.countryField,
    this.timestamp,
  }) : super(
         address: addressField,
         latitude: latitudeField,
         longitude: longitudeField,
         city: cityField,
         country: countryField,
       );

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      addressField: json['address'] as String,
      latitudeField: json['latitude'] as double?,
      longitudeField: json['longitude'] as double?,
      cityField: json['city'] as String?,
      countryField: json['country'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': addressField,
      'latitude': latitudeField,
      'longitude': longitudeField,
      'city': cityField,
      'country': countryField,
      'timestamp': timestamp?.toIso8601String(),
    };
  }

  factory LocationModel.fromEntity(LocationEntity entity) {
    return LocationModel(
      addressField: entity.address,
      latitudeField: entity.latitude,
      longitudeField: entity.longitude,
      cityField: entity.city,
      countryField: entity.country,
      timestamp: DateTime.now(),
    );
  }

  LocationModel copyWith({
    String? address,
    double? latitude,
    double? longitude,
    String? city,
    String? country,
    DateTime? timestamp,
  }) {
    return LocationModel(
      addressField: address ?? addressField,
      latitudeField: latitude ?? latitudeField,
      longitudeField: longitude ?? longitudeField,
      cityField: city ?? cityField,
      countryField: country ?? countryField,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
