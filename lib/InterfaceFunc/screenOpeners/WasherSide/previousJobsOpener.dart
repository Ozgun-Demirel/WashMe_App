



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

previousJobsOpener(BuildContext context, bool mounted) async {

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  QuerySnapshot<Map<String, dynamic>> previousJobsRef = await FirebaseFirestore.instance.collection("users").doc(user!.uid).collection("washerPreviousJobs").get();

  if(!mounted) return;

  Navigator.of(context).pop();
  Navigator.of(context).pushNamed("/PreviousJobs", arguments: {"previousJobs" : previousJobsRef.docs});


}