import 'package:geo/geo.dart';
import 'package:how_far_from_metide/domain/entities/country.dart';

/// A [[[Country]] model.
class CountryModel extends Country {
  /// [[CountryModel]] constructor.
  const CountryModel(id, enabled, code3l, code2l, name, officialName, flagUrl,
      location, zoom, distance)
      : super(id, enabled, code3l, code2l, name, officialName, flagUrl,
            location, zoom, distance);

  /// It constructs a new [[CountryModel]] from a JSON object.
  factory CountryModel.fromJson(Map<String, dynamic> data) {
    double? lat =
        data["latitude"] != null ? double.tryParse(data["latitude"]!) : null;
    double? lng =
        data["longitude"] != null ? double.tryParse(data["longitude"]!) : null;
    LatLng? location = lat != null && lng != null ? LatLng(lat, lng) : null;
    double? distance = location != null
        ? computeDistanceBetween(location, zeroLocation).toDouble() / 1000.0
        : null;
    return CountryModel(
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

  /// It return a JSON object representing this [[CountryModel]].
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
}
