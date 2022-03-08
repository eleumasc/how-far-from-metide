import 'package:equatable/equatable.dart';
import 'package:geo/geo.dart';

/// The Metide HQ geographic location
const LatLng zeroLocation = LatLng(45.5106738, 12.2321666);

/// A class that represents a country, whose scheme reflects the one from the API
class Country extends Equatable {
  /// [[Country]] constructor.
  const Country(
    this.id,
    this.enabled,
    this.code3l,
    this.code2l,
    this.name,
    this.officialName,
    this.flagUrl,
    this.location,
    this.zoom,
    this.distance,
  );

  final int? id;
  final bool? enabled;
  final String? code3l;
  final String? code2l;
  final String? name;
  final String? officialName;
  final String? flagUrl;
  final LatLng? location;
  final int? zoom;
  final double? distance;

  /// It constructs a new [[Country]] from a JSON object.
  factory Country.fromJson(Map<String, dynamic> data) {
    double? lat =
    data["latitude"] != null ? double.tryParse(data["latitude"]!) : null;
    double? lng =
    data["longitude"] != null ? double.tryParse(data["longitude"]!) : null;
    LatLng? location = lat != null && lng != null ? LatLng(lat, lng) : null;
    double? distance = location != null
        ? computeDistanceBetween(location, zeroLocation).toDouble() / 1000.0
        : null;

    return Country(
        data["id"] is int ? data["id"] : int.parse(data["id"]),
        data["enabled"] == "1",
        data["code3l"],
        data["code2l"],
        data["name"],
        data["name_official"],
        data["flag"],
        location,
        int.parse(data["zoom"]),
        distance);
  }

  /// It return a JSON object representing this [[Country]].
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "enabled": enabled,
      "code3l": code3l,
      "code2l": code2l,
      "name": name,
      "name_official": officialName,
      "flag": flagUrl,
      "latitude": location?.lat.toString(),
      "longitude": location?.lng.toString(),
      "zoom": zoom.toString(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        enabled,
        code3l,
        code2l,
        name,
        officialName,
        flagUrl,
        location,
        zoom,
        distance,
      ];
}
