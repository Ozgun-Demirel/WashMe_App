

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../FirebaseHelper/FirestoreHelpers/WasherHelpers/orderShifterHelper.dart';

currentOrdersOpener(BuildContext context, double deviceHeight, double deviceWidth, bool mounted,
    {required bool replaced}) async {

  List<Map<String, Map>> ordersInfo = await getOrdersInfo();

  if (!mounted) return;
  Navigator.of(context).pop();
  replaced ? Navigator.of(context).pushReplacementNamed("/ALCurrentOrder", arguments: {"ordersInfo" : ordersInfo }) : Navigator.of(context).pushNamed("/ALCurrentOrder", arguments: {"ordersInfo" : ordersInfo });

}

Future<Map<String, dynamic>> getCityCurrentOrders() async {

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  DocumentReference<Map<String, dynamic>> documentRef = FirebaseFirestore
      .instance
      .collection('users')
      .doc(user!.uid)
      .collection("currentOrders")
      .doc("washMe");
  DocumentSnapshot<Map<String, dynamic>> querySnapshot =
  await documentRef.get();
  Map<String, dynamic>? data = querySnapshot.data();
  if (data == null) {
    return {};
  }
  return data;
}

getOrdersInfo() async {

  Map<String, dynamic> data = await getCityCurrentOrders();
  Map<String, Map> activeOrdersMap = {};
  Map<String, Map> pendingOrdersMap = {};
  Map<String, Map> ongoingOrdersMap = {};
  List eKeys = data.keys.toList(); // UniqueKey's of orders
  List eValues =
  data.values.toList(); // {"adminArea" : ... , "date" : ...}
  for (int index = 0; index < eKeys.length; index++) {

    //is Order Completed:
    int timeRemaining = eValues[index]["orderDate"].seconds * 1000;
    double minDifference = (timeRemaining - DateTime.now().millisecondsSinceEpoch)/(1000*60);

    bool orderExpired = minDifference < 0;
    bool orderExpired45 = minDifference < -45;

    DocumentReference<Map<String, dynamic>> activeRequestsRef =
    FirebaseFirestore.instance
        .collection('jobs')
        .doc("washMe")
        .collection("cities")
        .doc(eValues[index]["adminArea"])
        .collection("activeRequests")
        .doc(eKeys[index]);
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
    await activeRequestsRef.get();
    Map<String, dynamic>? activeRequestsData = querySnapshot.data();
    if (activeRequestsData != null) {

      if (orderExpired){
        await FirebaseFirestore.instance
            .collection('jobs')
            .doc("washMe")
            .collection("cities")
            .doc(eValues[index]["adminArea"])
            .collection("activeRequests").doc(eKeys[index]).delete();

        User? user = FirebaseAuth.instance.currentUser;
        DocumentReference<Map<String, dynamic>> documentRef = FirebaseFirestore.instance.collection('users')
            .doc(user!.uid)
            .collection("currentOrders")
            .doc("washMe");
        DocumentSnapshot<Map<String, dynamic>> querySnapshot = await documentRef.get();
        Map<String, dynamic>? data = querySnapshot.data();
        data!.remove(eKeys[index]);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection("currentOrders")
            .doc("washMe").set(data);
      } else {
        DocumentSnapshot<Map<String, dynamic>> washerInformationsRef = await FirebaseFirestore
            .instance
            .collection('washerInformations').doc(activeRequestsData["washerID"]).get();
        var washerInfo = washerInformationsRef.data();
        activeRequestsData["washerInfo"] = washerInfo;

        activeOrdersMap[eKeys[index].toString()] = activeRequestsData ;
      }
    } else {
      DocumentReference<Map<String, dynamic>> pendingRequestsRef =
      FirebaseFirestore.instance
          .collection('jobs')
          .doc("washMe")
          .collection("cities")
          .doc(eValues[index]["adminArea"])
          .collection("pendingRequests")
          .doc(eKeys[index]);
      DocumentSnapshot<Map<String, dynamic>> querySnapshot =
      await pendingRequestsRef.get();
      Map<String, dynamic>? pendingRequestsData = querySnapshot.data();
      if (pendingRequestsData != null) {

        if (orderExpired){
          await FirebaseFirestore.instance
              .collection('jobs')
              .doc("washMe")
              .collection("cities")
              .doc(eValues[index]["adminArea"])
              .collection("pendingRequests").doc(eKeys[index]).delete();

          User? user = FirebaseAuth.instance.currentUser;
          DocumentReference<Map<String, dynamic>> documentRef = FirebaseFirestore.instance.collection('users')
              .doc(user!.uid)
              .collection("currentOrders")
              .doc("washMe");
          DocumentSnapshot<Map<String, dynamic>> querySnapshot = await documentRef.get();
          Map<String, dynamic>? data = querySnapshot.data();
          data!.remove(eKeys[index]);
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection("currentOrders")
              .doc("washMe").set(data);
        } else {
          DocumentSnapshot<Map<String, dynamic>> washerInformationsRef = await FirebaseFirestore
              .instance
              .collection('washerInformations').doc(pendingRequestsData["washerID"]).get();
          var washerInfo = washerInformationsRef.data();
          pendingRequestsData["washerInfo"] = washerInfo;

          pendingOrdersMap[eKeys[index].toString()] = pendingRequestsData;
        }


      } else {
        DocumentReference<Map<String, dynamic>> onGoingRequestsRef =
        FirebaseFirestore.instance
            .collection('jobs')
            .doc("washMe")
            .collection("cities")
            .doc(eValues[index]["adminArea"])
            .collection("ongoingRequests")
            .doc(eKeys[index]);
        DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await onGoingRequestsRef.get();
        Map<String, dynamic>? onGoingRequestsData = querySnapshot.data();

        FirebaseAuth auth = FirebaseAuth.instance;
        User? user = auth.currentUser;

        if (onGoingRequestsData != null) {

          if (orderExpired45){
            FirestoreWashMeOrderShifterHelper.completedOrderCreator(eValues[index], eKeys[index], false);

            var notCompletedOrderMap = eValues[index].addAll({"isCompleted" : false});
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .collection("currentOrders").doc(eKeys[index]).set(notCompletedOrderMap);
          } else {
            DocumentSnapshot<Map<String, dynamic>> washerInformationsRef = await FirebaseFirestore
                .instance
                .collection('washerInformations').doc(onGoingRequestsData["washerID"]).get();
            var washerInfo = washerInformationsRef.data();
            onGoingRequestsData["washerInfo"] = washerInfo;

            ongoingOrdersMap[eKeys[index].toString()] = onGoingRequestsData;
          }
        } else {

          DocumentSnapshot<Map<String, dynamic>> lastPreviousOrderRef = await FirebaseFirestore
              .instance
              .collection('washerInformations').doc(eValues[index]["washerID"]).collection("previousJobs").doc(eKeys[index]).get();
          Map<String, dynamic> lastPreviousOrderData = lastPreviousOrderRef.data() as Map<String, dynamic>;

          await FirebaseFirestore
              .instance
              .collection('users').doc(user!.uid).collection("previousOrders").doc(eKeys[index]).set(lastPreviousOrderData);


          DocumentSnapshot<Map<String, dynamic>> gonnaDeleteRef = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection("currentOrders")
              .doc("washMe").get();

          Map<String, dynamic>? gonnaDeleteData = gonnaDeleteRef.data();

          gonnaDeleteData!.remove(eKeys[index]);

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection("currentOrders")
              .doc("washMe").set(gonnaDeleteData);

        }
      }
    }
  }
  return [activeOrdersMap, pendingOrdersMap, ongoingOrdersMap];
}