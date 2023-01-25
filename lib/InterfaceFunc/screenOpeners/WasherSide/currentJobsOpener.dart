

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../FirebaseHelper/FirestoreHelpers/WasherHelpers/orderShifterHelper.dart';

currentJobsOpener(BuildContext context, bool mounted) async {

  Future<Map> _getCurrentJobs() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    DocumentReference<Map<String, dynamic>> documentRef = FirebaseFirestore
        .instance
        .collection('users')
        .doc(user!.uid)
        .collection("washer")
        .doc("activeJobs");
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
    await documentRef.get();
    Map<String, dynamic>? data = querySnapshot.data();
    if (data == null) {
      return {};
    }
    return data;
  }

  Future<List<Map<String, Map>>?> _getCurrentJobs2() async {
    var data = await _getCurrentJobs();
    Map<String, Map> pendingJobsMap = {};
    Map<String, Map> ongoingRequestsMap = {};
    if (data.isEmpty) {
      return [{}, {}];
    } else {
      List eKeys = data.keys.toList(); // UniqueKey's of orders
      List eValues = data.values.toList(); // {"adminArea" : ... , "date" : ...}

      for (int index = 0; index < eKeys.length; index++) {

        int timeRemaining = eValues[index]["orderDate"].seconds * 1000;
        double minDifference = (timeRemaining - DateTime.now().millisecondsSinceEpoch)/(1000*60);

        bool orderExpired = minDifference < 0;
        bool orderExpired45 = minDifference < -45;

        DocumentReference<Map<String, dynamic>> pendingRequestsRef =
        FirebaseFirestore.instance
            .collection('jobs')
            .doc("washMe")
            .collection("cities")
            .doc(eValues[index]["adminArea"])
            .collection("pendingRequests")
            .doc(eKeys[index]);

        DocumentSnapshot<Map<String, dynamic>> pendingQuerySnapshot =
        await pendingRequestsRef.get();
        Map<String, dynamic>? pendingRequestsData = pendingQuerySnapshot.data();
        if (pendingRequestsData != null) {

          if (orderExpired){
            FirestoreWashMeOrderShifterHelper.completedOrderCreator(eValues[index], eKeys[index], false, washerPendingOrderExpire: true);

            var notCompletedOrderMap = eValues[index].addAll({"isCompleted" : false});
            FirebaseAuth auth = FirebaseAuth.instance;
            User? user = auth.currentUser;

            FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .collection("washerPreviousJobs").doc(eKeys[index]).set(notCompletedOrderMap);

          } else {
            pendingJobsMap[eKeys[index].toString()] = pendingRequestsData;
          }

        } else {
          DocumentReference<Map<String, dynamic>> ongoingRequestsRef =
          FirebaseFirestore.instance
              .collection('jobs')
              .doc("washMe")
              .collection("cities")
              .doc(eValues[index]["adminArea"])
              .collection("ongoingRequests")
              .doc(eKeys[index]);
          DocumentSnapshot<Map<String, dynamic>> ongoingQuerySnapshot =
          await ongoingRequestsRef.get();
          Map<String, dynamic>? ongoingRequestsData =
          ongoingQuerySnapshot.data();
          if (ongoingRequestsData != null) {

            if (orderExpired45){
              FirestoreWashMeOrderShifterHelper.completedOrderCreator(eValues[index], eKeys[index], false);

              var notCompletedOrderMap = eValues[index].addAll({"isCompleted" : false});
              FirebaseAuth auth = FirebaseAuth.instance;
              User? user = auth.currentUser;

              FirebaseFirestore.instance
                  .collection('users')
                  .doc(user!.uid)
                  .collection("washerPreviousJobs").doc(eKeys[index]).set(notCompletedOrderMap);

            } else {
              ongoingRequestsMap[eKeys[index].toString()] = ongoingRequestsData;
            }

          } else {



            FirebaseAuth auth = FirebaseAuth.instance;
            User? user = auth.currentUser;

            DocumentReference<Map<String, dynamic>> documentRef =
            FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .collection("washer")
                .doc("activeJobs");
            DocumentSnapshot<Map<String, dynamic>> querySnapshot =
            await documentRef.get();
            Map<String, dynamic>? data = querySnapshot.data();
            data!.remove(eKeys[index]);
            await documentRef.set(data);
          }
        }
      }
    }
    return [pendingJobsMap, ongoingRequestsMap];
  }

  List<Map<String, Map>>? ordersList = await _getCurrentJobs2();

  if (!mounted) return;
  Navigator.of(context).pop();
  Navigator.of(context).pushNamed("/CurrentJobs", arguments: {"ordersList": ordersList});


}