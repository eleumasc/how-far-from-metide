import 'package:equatable/equatable.dart';
import 'package:geo/geo.dart';

/// The Metide HQ geographic location.
const LatLng zeroLocation = LatLng(45.5106738, 12.2321666);

/// A class that represents a country, whose scheme reflects the one from the
/// remote API.
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
