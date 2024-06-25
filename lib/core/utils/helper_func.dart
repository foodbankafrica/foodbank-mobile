import 'package:flutter/material.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<String> pickDateOfBirth(BuildContext context) async {
  final selectedDate = await showDatePicker(
    context: context,
    firstDate: DateTime.now().getPastDate(70),
    lastDate: DateTime.now().getPastDate(18),
    currentDate: DateTime.now().getPastDate(18),
  );
  if (selectedDate != null) {
    return selectedDate.dateOnly();
  }
  return "";
}

Future<(String, double, double)> useCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.',
    );
  }
  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  return (
    await _getAddressFromLatLng(position),
    position.latitude,
    position.longitude
  );
}

Future<String> _getAddressFromLatLng(Position position) async {
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemarks[0];

    print(placemarks.length);
    for (var p in placemarks) {
      print(
          "${p.street}, ${p.locality}, ${p.postalCode}, ${p.administrativeArea}, ${p.country}\n");
    }

    return "${place.street}, ${place.locality}, ${place.postalCode}, ${place.administrativeArea}, ${place.country}";
  } catch (e) {
    rethrow;
  }
}
