import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable {
  final String address;
  final double? latitude;
  final double? longitude;
  final String? city;
  final String? country;

  const LocationEntity({
    required this.address,
    this.latitude,
    this.longitude,
    this.city,
    this.country,
  });

  @override
  List<Object?> get props => [address, latitude, longitude, city, country];

  @override
  String toString() {
    return 'LocationEntity(address: $address, city: $city, country: $country)';
  }
}
