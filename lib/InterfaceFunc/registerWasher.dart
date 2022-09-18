

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/SplashAndIntro/Splash.dart';

registerWasher(data, keys, BuildContext context, mounted) async {

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  if (keys.contains("photosURL") && keys.contains("SSN") && keys.contains("IDURL") && keys.contains("nameAndAddress")){
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .update({
      'washer': true,
    });
    FirebaseFirestore.instance.collection('washerInformations').doc(data["washerID"]).set({
      "nameAndAddress" : data["nameAndAddress"],
      "profilePhotoURL" : data["photosURL"]["profilePhotoURL"],
      "optionalPhotoURL" : data["photosURL"]["optionalPhotoURL"],
      "backOfIDFileURL" : data["IDURL"]["backOfIDFileURL"],
      "frontOfIDFileURL" : data["IDURL"]["frontOfIDFileURL"],
    });


    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? _showIntro = prefs.getBool("showIntro");

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Splash(showIntro: _showIntro)), (route) => false);
    return;
  }

}