import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class OnLoginHelper {

  static User? user = _auth.currentUser;

  static placingOnlineData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users')
        .doc(user!.uid)
        .collection("locations").get();

  }

  static onLogin() async {
    await OnLoginHelper.placingOnlineData();
  }

}