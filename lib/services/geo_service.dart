import 'package:geocoder/geocoder.dart';
import 'package:geocoder/services/local.dart';
import 'package:geolocator/geolocator.dart';

class GeoService {
  final Geolocator geolocator;
  final LocalGeocoding geocoding;

  GeoService(this.geolocator, this.geocoding);

  Future<List<Address>> fetchLocation() async {
    Position location = await geolocator
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.medium);
    final coordinates = new Coordinates(location.latitude, location.longitude);
    final addresses =
        await geocoding.findAddressesFromCoordinates(coordinates);

    return addresses;
  }
}
