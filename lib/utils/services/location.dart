import 'package:geolocator/geolocator.dart';

class Location {

  late double longitude ;
  late double latitude ;

  Future<void> getPosition () async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      permission = LocationPermission.always;
      Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
      longitude = pos.longitude;
      latitude = pos.latitude;
    } catch (e) {
      print(e);
    }
  }
}
