
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../Models/Users/userInformations.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class FirestoreUserInformationsHelper {
  static User? user = _auth.currentUser;

  static userInformationsAdder(UserInformations userInformations, UserInformations addedInformationFormData) async {
    if(user != null ){
      return await FirebaseFirestore.instance
          .collection('users')
        .doc(user!.uid)
        .update({
      "fullName" : addedInformationFormData.fullName.toString().trim() == "" ? userInformations.fullName.toString() : addedInformationFormData.fullName.toString().trim(),
      "surname" : addedInformationFormData.surname.toString().trim() == "" ? userInformations.surname.toString() : addedInformationFormData.surname.toString().trim(),
      "phoneNumber" : addedInformationFormData.phoneNumber.toString().trim() == "" ? userInformations.phoneNumber.toString() : addedInformationFormData.phoneNumber.toString().trim(),
      "contactEmail" : addedInformationFormData.contactEmail.toString().trim() == "" ? userInformations.contactEmail.toString() : addedInformationFormData.contactEmail.toString().trim(),
      "birthDate" : DateTime(userInformations.birthDayYear ?? 2022, userInformations.birthDayMonth ?? 1, userInformations.birthDayDay ?? 1),
      "gender" : addedInformationFormData.gender.toString().trim() == "" ? userInformations.gender.toString() : addedInformationFormData.gender.toString().trim(),
      "photoFile" : addedInformationFormData.photoFile.toString().trim() == "" ? userInformations.photoFile.toString() : addedInformationFormData.photoFile.toString().trim(),
    });
    } else {
      print("not loged in");
    }
  }

}
