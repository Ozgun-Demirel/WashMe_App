import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../Models/Users/vehicleValuesType.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class FirestoreUserVehiclesHelper {
  static User? user = _auth.currentUser;

  static userVehiclesAdder(int id, VehicleValues vehicleValues) async {
    if (user != null) {
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection("vehicles")
          .doc("$id")
          .set({
        "licensePlateNumber": vehicleValues.licensePlateNumber,
        "brand": vehicleValues.brand,
        "model": vehicleValues.model,
        "color": vehicleValues.color,
        "photoFile": vehicleValues.photoFile,
        "classType": vehicleValues.classType,
      });
    } else {
      print("not loged in");
    }
  }

  static userVehiclesDeleter(int id) async {
    if (user != null) {
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection("vehicles")
          .doc("$id")
          .delete();
    } else {
      print("not loged in");
    }
  }
}
