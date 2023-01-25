
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../Models/Users/userInformations.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class FirestoreUserInformationsHelper {
  static User? user = _auth.currentUser;

  static userInformationsAdder(UserInformations addedInformationFormData) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .update({
      "fullName" : addedInformationFormData.fullName,
      "surname" : addedInformationFormData.surname,
      "phoneNumber" : addedInformationFormData.phoneNumber,
      "contactEmail" : addedInformationFormData.contactEmail,
      "birthDate" : DateTime(addedInformationFormData.birthDayYear ?? 2022, addedInformationFormData.birthDayMonth ?? 1, addedInformationFormData.birthDayDay ?? 1),
      "gender" : addedInformationFormData.gender,
      "photoFilePath" : addedInformationFormData.photoFilePath.toString(),
    });
  }

}
