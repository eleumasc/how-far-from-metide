import 'package:how_far_from_metide/domain/entities/country.dart';

/// It returns an integer that represents the order between a and b with respect to their distance attribute, ascending.
/// In particular, it returns -1 if a is closer than b, 1 if a is further than b, and 0 if a and b are equidistant.
int byDistance(Country a, Country b) {
  if (a.distance != null && b.distance != null) {
    return a.distance!.compareTo(b.distance!);
  } else if (b.distance == null) {
    return -1;
  } else {
    return 1;
  }
}
