
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;

import '../../Models/Users/locationValuesType.dart';

Map statesDict = {'ALABAMA': 'AL', 'ALASKA': 'AK', 'ARIZONA': 'AZ', 'ARKANSAS': 'AR', 'AMERICAN SOME': 'AS','CALIFORNIA': 'CA', 'COLORADO': 'CO', 'CONNECTICUT': 'CT', 'DELAWARE': 'DE', 'DISTRICT OF COLUMBIA' : 'DC', 'FLORIDA': 'FL', 'GEORGIA': 'GA', 'GUAM':'GU', 'HAWAII': 'HI', 'IDAHO': 'ID', 'ILLINOIS': 'IL', 'INDIANA': 'IN', 'IOWA': 'IA', 'KANSAS': 'KS', 'KENTUCKY': 'KY', 'LOUISIANA': 'LA', 'MAINE': 'ME', 'MARYLAND': 'MD', 'MASSACHUSETTS': 'MA', 'MICHIGAN': 'MI', 'MINNESOTA': 'MN', 'MISSISSIPPI': 'MS', 'MISSOURI': 'MO', 'MONTANA': 'MT', 'NEBRASKA': 'NE', 'NEVADA': 'NE', 'NEW HAMPSHIRE': 'NH', 'NEW JERSEY': 'NJ', 'NEW MEXICO': 'NM', 'NEW YORK': 'NY', 'NORTH CAROLINA': 'NC', 'NORTH DAKOTA': 'ND', 'NORTHERN MARIANA ISLANDS': 'CM', 'OHIO': 'OH', 'OKLAHOMA': 'OK', 'OREGON': 'OR', 'PENNSYLVANIA': 'PA', 'PUERTO RICA': 'RI', 'RHODE ISLAND': 'RI', 'SOUTH CAROLINA': 'SC', 'SOUTH DAKOTA': 'SD', 'TENNESSEE': 'TN', 'TEXAS': 'TX', 'TRUST TERRITORIES' : 'TT', 'UTAH': 'UT', 'VERMONT': 'VT', 'VIRGINIA': 'VA', 'VIRGIN ISLANDS' : 'VI', 'WASHINGTON': 'WA', 'WEST VIRGINIA': 'WV', 'WISCONSIN': 'WI', 'WYOMING': 'WY'};
class CustomerLocation {
  var location = Location();

  CustomerLocation();

  checkService() async {
    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (serviceEnabled) {
        return;
      }
    }
  }

  Future<bool> checkPermission() async {
    var permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  getLocation() async {
    if (await checkPermission()) {
      final Future<LocationData> locationData = location.getLocation();
      return locationData;
    }
    return;
  }

  getPlaceMark({LocationData? locationData, LatLng? latLng}) async {

    if (locationData != null){
      final placeMarks = await geo.placemarkFromCoordinates(
          locationData.latitude!, locationData.longitude!);
      if (placeMarks.isNotEmpty) {
        return placeMarks[0];
      }
    } else if (latLng != null){
      final placeMarks = await geo.placemarkFromCoordinates(
          latLng.latitude, latLng.longitude);
      if (placeMarks.isNotEmpty) {
        return placeMarks[0];
      }
    }

    return null;
  }

  Future<LocationValues?> returnAllValues({double? lat, double? long}) async {

    late LocationData locationData;
    LocationValues? locationValues;

    if (lat != null && long != null){
      var placeMark = await getPlaceMark(latLng: LatLng(lat, long));
      locationValues = LocationValues.withAllInfo(
        lat.toString(),
        long.toString(),
        statesDict[placeMark.administrativeArea.toString().toUpperCase().trim()] ?? placeMark.administrativeArea ?? "could not get admin area",
        (placeMark.administrativeArea ?? "could not get admin area"),
        (placeMark.street ?? "Loading"),
        (placeMark.postalCode ?? "Loading"),
      );
    } else {

      locationData = await getLocation();
      var placeMark = await getPlaceMark(locationData: locationData);
      locationValues = LocationValues.withAllInfo(
        locationData.latitude.toString(),
        locationData.longitude!.toString(),
        statesDict[placeMark.administrativeArea.toString().toUpperCase().trim()] ?? placeMark.administrativeArea ?? "could not get admin area",
        (placeMark.administrativeArea ?? "could not get admin area"),
        (placeMark.street ?? "Loading"),
        (placeMark.postalCode ?? "Loading"),
      );

    }
    return locationValues;
    }

    
  }
