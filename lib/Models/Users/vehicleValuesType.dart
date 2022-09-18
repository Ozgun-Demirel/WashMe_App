

// this class sets location values type to be used in all project
class VehicleValues {
  String? licensePlateNumber, brand, model, color, photoFile, classType;

  VehicleValues();

  VehicleValues.withAllInfo(this.licensePlateNumber, this.brand, this.model, this.color,
      this.photoFile, this.classType);

  factory VehicleValues.fromMap(Map dataMap) {
    return VehicleValues.withAllInfo(
        dataMap["licensePlateNumber"],
        dataMap["brand"],
        dataMap["model"],
        dataMap["color"],
        dataMap["photoFile"],
        dataMap["classType"]);
  }

}