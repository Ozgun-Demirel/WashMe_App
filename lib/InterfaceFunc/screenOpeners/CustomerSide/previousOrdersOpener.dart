

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

previousOrdersOpener(
  BuildContext context,
  double deviceHeight,
  double deviceWidth,
  bool mounted,
) async {

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  QuerySnapshot<Map<String, dynamic>> previousOrdersRef = await FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .collection("previousOrders").get();


  if(!mounted) return;

  Navigator.of(context).pop();
  Navigator.of(context).pushNamed("/ALPreviousOrders", arguments: {"previousOrdersDocs" : previousOrdersRef.docs});

}
