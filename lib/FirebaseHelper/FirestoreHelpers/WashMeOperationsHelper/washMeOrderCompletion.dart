

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../InterfaceFunc/screenOpeners/WasherSide/currentJobsOpener.dart';
import '../WasherHelpers/orderShifterHelper.dart';

washMeOrderCompletion (bool mounted, BuildContext context, Map<String, dynamic> currentOrder, currentOrderKey) async {

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  Map<String, dynamic> tempCompletedOrder = currentOrder;
  tempCompletedOrder["isCompleted"] = true;

  FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .collection("washerPreviousJobs").doc(currentOrderKey).set(tempCompletedOrder);

  FirestoreWashMeOrderShifterHelper.completedOrderCreator(currentOrder, currentOrderKey, true);

  DocumentReference<Map<String, dynamic>> documentRef =
  FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection("washer")
      .doc("activeJobs");
  DocumentSnapshot<Map<String, dynamic>> querySnapshot =
  await documentRef.get();
  Map<String, dynamic>? data = querySnapshot.data();
  data!.remove(currentOrderKey);
  await documentRef.set(data);




  if(!mounted) return;

  Navigator.of(context).pop();

  currentJobsOpener(context, mounted);

}