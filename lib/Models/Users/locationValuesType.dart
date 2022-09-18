

// this class sets location values type to be used in all project
class LocationValues {
  String? lat, long, state, adminArea, streetNumberAndName, zip;

  LocationValues();

  LocationValues.withAllInfo(this.lat, this.long, this.state, this.adminArea,
      this.streetNumberAndName, this.zip);

  factory LocationValues.fromMap(Map dataMap) {
    return LocationValues.withAllInfo(
        dataMap["lat"],
        dataMap["long"],
        dataMap["state"],
        dataMap["adminArea"],
        dataMap["streetNumberAndName"],
        dataMap["zip"]);
  }

  toMap(){
    return {
      "lat": lat.toString(),
      "long": long.toString(),
      "state": state.toString(),
      "adminArea": adminArea.toString(),
      "streetNumberAndName":
          streetNumberAndName
          .toString(),
      "zip": zip.toString(),
    };
  }

  isNotNull() {
    if (lat != null &&
        long != null &&
        state != null &&
        adminArea != null &&
        streetNumberAndName != null &&
        zip != null) {
      return true;
    } else {
      return false;
    }
  }

}