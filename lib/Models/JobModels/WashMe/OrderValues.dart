class OrderValues {
  String? exteriorWashType,
      carClass;
  DateTime? dateValue;
  DateTime? timeValue;
      bool? isInterior = false;
  bool? isTruck = false;
  bool? isEngine = false;

  OrderValues();

  isNull() {
    if (exteriorWashType != null &&
        carClass != null &&
        dateValue != null &&
    timeValue != null) {
      return false;
    } else {
      return true;
    }
  }

}
