

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../FirebaseHelper/FirestoreHelpers/WasherHelpers/orderShifterHelper.dart';

washerRequestsOpener(BuildContext context, bool mounted) async {

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  DocumentSnapshot<Map<String, dynamic>> isWasherRef = await FirebaseFirestore
      .instance
      .collection('users').doc(user!.uid).get();
  var isWasher = isWasherRef.data()!["washer"];

  if (!isWasher){
    if(!mounted) return;
    return Navigator.of(context).pushReplacementNamed("/BecomeWasher");
  }

  //List addressAndActiveOrders = await FirestoreWashMeOrderShifterHelper.activeOrderLoader(); User Configuration
  List addressAndActiveOrders = await FirestoreWashMeOrderShifterHelper.activeOrderLoaderDEVELOPER(); // Developer Configuration

  DocumentSnapshot<Map<String, dynamic>> washerInformationsRef = await FirebaseFirestore
      .instance
      .collection('users').doc(user.uid).collection("washer").doc("washerInformations").get();
  String? washerName;
  if (washerInformationsRef.data() == null){
    return;
  } else {
    washerName = washerInformationsRef.data()!["nameAndAddress"]["name"];
  }

  if(!mounted) return;
  Navigator.of(context).pushReplacementNamed("/WasherRequests", arguments: {"addressAndActiveOrders": addressAndActiveOrders, "washerName": washerName});
}
