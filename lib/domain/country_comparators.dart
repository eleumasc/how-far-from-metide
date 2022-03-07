import 'package:how_far_from_metide/domain/country.dart';

int byDistance(Country a, Country b) {
  if (a.distance != null && b.distance != null) {
    return a.distance!.compareTo(b.distance!);
  } else if (b.distance == null) {
    return -1;
  } else {
    return 1;
  }
}
