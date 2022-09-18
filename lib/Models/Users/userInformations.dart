
import '../../InterfaceFunc/DatabaseHelpers/SubHelpers/userMyInformationHelper.dart';

class UserInformations {
  String? id;
  String? fullName;
  String? surname;
  String? phoneNumber;
  String? contactEmail;
  int? birthDayMonth;
  int? birthDayDay;
  int? birthDayYear;
  String? gender;
  String? photoFile;

  UserInformations();

  UserInformations.free({
    this.id,
    this.fullName,
    this.surname,
    this.phoneNumber,
    this.contactEmail,
    this.birthDayMonth,
    this.birthDayDay,
    this.birthDayYear,
    this.gender,
    this.photoFile,
  });

  UserInformations.withAllInfo(
    this.id,
    this.fullName,
    this.surname,
    this.phoneNumber,
    this.contactEmail,
    this.birthDayMonth,
    this.birthDayDay,
    this.birthDayYear,
    this.gender,
    this.photoFile,
  );

  factory UserInformations.fromMap(Map dataMap) {
    return UserInformations.withAllInfo(
        dataMap["id"],
        dataMap["fullName"],
        dataMap["surname"],
        dataMap["phoneNumber"],
        dataMap["contactEmail"],
        dataMap["birthDayMonth"],
        dataMap["birthDayDay"],
        dataMap["birthDayYear"],
        dataMap["gender"],
        dataMap["photoFile"]);
  }

  static Future<UserInformations> returnAllInfo(String id) async {
    var info = await InformationHelper.getInformationsData();
    Map<String, dynamic> data = {};
    for (int i = 0; i < info.length; i++) {
      if (info[i]["id"] == id) {
        data = info[i];
      }
    }
    return UserInformations.fromMap(data);
  }

  Map<String, String> toMap() {
    return {
      "id": id.toString(),
      "fullName": fullName.toString(),
      "surname": surname.toString(),
      "phoneNumber": phoneNumber.toString(),
      "email": contactEmail.toString(),
      "birthDate":
          DateTime(birthDayYear ?? 2022, birthDayMonth ?? 1, birthDayDay ?? 1)
              .toString(),
      "gender": gender.toString(),
      "photoFile": photoFile.toString(),
    };
  }
}
