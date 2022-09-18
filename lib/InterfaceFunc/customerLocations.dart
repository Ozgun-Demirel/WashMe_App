
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;

import '../Models/Users/locationValuesType.dart';

Map statesDict = {'35004,36925': ['ALABAMA', 'AL'], '99501,99950': ['ALASKA', 'AK'], '85001,86556': ['ARIZONA', 'AZ'], '71601,72959': ['ARKANSAS', 'AR'], '90001,96162': ['CALIFORNIA', 'CA'], '80001,81658': ['COLORADO', 'CO'], '06001,06928': ['CONNECTICUT', 'CT'], '19701,19980': ['DELAWARE', 'DE'], '32003,34997': ['FLORIDA', 'FL'], '30002,39901': ['GEORGIA', 'GA'], '96701,96898': ['HAWAII', 'HI'], '83201,83877': ['IDAHO', 'ID'], '60001,62999': ['ILLINOIS', 'IL'], '46001,47997': ['INDIANA', 'IN'], '50001,52809': ['IOWA', 'IA'], '66002,67954': ['KANSAS', 'KS'], '40003,42788': ['KENTUCKY', 'KY'], '70001,71497': ['LOUISIANA', 'LA'], '03901,04992': ['MAINE', 'ME'], '20588,21930': ['MARYLAND', 'MD'], '01001,0554': ['MASSACHUSETTS', 'MA'], '48001,49971': ['MICHIGAN', 'MI'], '55001,56763': ['MINNESOTA', 'MN'], '38601,39776': ['MISSISSIPPI', 'MS'], '63001,7264': ['MISSOURI', 'MO'], '59001,59937': ['MONTANA', 'MT'], '68001,69367': ['NEBRASKA', 'NE'], '88901,89883': ['NEVADA', 'NE'], '03031,03897': ['NEW HAMPSHIRE', 'NH'], '07001,08989': ['NEW JERSEY', 'NJ'], '87001,88439': ['NEW MEXICO', 'NM'], '00501,14925': ['NEW YORK', 'NY'], '27006,28909': ['NORTH CAROLINA', 'NC'], '58001,58856': ['NORTH DAKOTA', 'ND'], '43001,45999': ['OHIO', 'OH'], '73001,74966': ['OKLAHOMA', 'OK'], '97001,97920': ['OREGON', 'OR'], '15001,19640': ['PENNSYLVANIA', 'PA'], '02801,02940': ['RHODE ISLAND', 'RI'], '29001,29945': ['SOUTH CAROLINA', 'SC'], '57001,57799': ['SOUTH DAKOTA', 'SD'], '37010,38589': ['TENNESSEE', 'TN'], '73301,88595': ['TEXAS', 'TX'], '84001,84791': ['UTAH', 'UT'], '05001,05907': ['VERMONT', 'VT'], '20101,24658': ['VIRGINIA', 'VA'], '98001,99403': ['WASHINGTON', 'WA'], '24701,26886': ['WEST VIRGINIA', 'WV'], '53001,54990': ['WISCONSIN', 'WI'], '82001,83414': ['WYOMING', 'WY']};
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
      final locationData = location.getLocation();
      return locationData;
    }
    return;
  }

  getPlaceMark({required LocationData locationData}) async {
    final placeMarks = await geo.placemarkFromCoordinates(
        locationData.latitude!, locationData.longitude!);
    if (placeMarks.isNotEmpty) {
      return placeMarks[0];
    }
    return null;
  }

  Future<LocationValues?> returnAllValues() async {
    var locationData = await getLocation();
    LocationValues? locationValues;
    if (await locationData != null) {
      var placeMark = await getPlaceMark(locationData: locationData);
      locationValues = LocationValues.withAllInfo(
        locationData.latitude.toString(),
        locationData.longitude!.toString(),
        findStateFromZip(int.parse(placeMark.postalCode)) ?? placeMark.administrativeArea ?? "could not get admin area",
        (placeMark.administrativeArea ?? "could not get admin area"),
        (placeMark.street ?? "Loading"),
        (placeMark.postalCode ?? "Loading"),
      );
    }
    return locationValues;
    }
    
    String? findStateFromZip(int currentZip){
    for (var element in statesDict.keys){
      var elementList = element.split(",");
      if (currentZip > int.parse(elementList[0]) && currentZip < int.parse(elementList[1])){
        return statesDict[element][1];
      }
      else {
        return null;
      }
    }
    }
    
  }
