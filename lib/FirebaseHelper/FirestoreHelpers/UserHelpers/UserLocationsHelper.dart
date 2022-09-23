
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../Models/Users/locationValuesType.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class FirestoreUserLocationsHelper {

  static userLocationsAdder(int id, LocationValues locationValue) async {
    User? user = _auth.currentUser;
    if(user != null ){
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection("locations")
          .doc("$id")
          .set({
        "lat": locationValue.lat,
        "long": locationValue.long,
        "state": locationValue.state,
        "adminArea": locationValue.adminArea,
        "streetNumberAndName": locationValue.streetNumberAndName,
        "zip": locationValue.zip,
      });
    } else {
      print("not loged in");
    }
  }

  static userLocationsDeleter(int id) async{
    User? user = _auth.currentUser;
    if(user != null ){
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection("locations")
          .doc("$id").delete();
    } else {
      print("not loged in");
    }
  }
}
