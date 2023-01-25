
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Models/JobModels/WashMe/OrderValues.dart';
import '../../../Models/Users/locationValuesType.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class FirestoreWashMeOrderHelper {
  static User? user = _auth.currentUser;

  static washMeOrderAdder(OrderValues orderValues, LocationValues locationValues) async {
    var extraWashType = [];
    if (orderValues.isInterior == true){
      extraWashType.add("Interior");
    }
    if (orderValues.isEngine == true){
      extraWashType.add("Engine");
    }
    if (orderValues.isTruck == true){
      extraWashType.add("Truck");
    }
    DateTime currentTime = DateTime.now();
    String orderKey = UniqueKey().toString();
    try {
      DocumentReference<Map<String, dynamic>> documentRef = FirebaseFirestore.instance.collection('users')
          .doc(user!.uid)
          .collection("currentOrders")
          .doc("washMe");
      DocumentSnapshot<Map<String, dynamic>> querySnapshot = await documentRef.get();
      Map<String, dynamic>? data = querySnapshot.data();
      if (data != null){
        data.addAll({
          orderKey : {
            "adminArea" : locationValues.adminArea.toString(),
            "orderDate" : DateTime(orderValues.dateValue!.year, orderValues.dateValue!.month, orderValues.dateValue!.day, orderValues.timeValue!.hour, orderValues.timeValue!.minute),
            "orderInitiationDate" : currentTime,
          }
        });
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection("currentOrders")
            .doc("washMe").set(data);
      } else {

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection("currentOrders")
            .doc("washMe").set({
          orderKey : {
            "adminArea" : locationValues.adminArea.toString(),
            "orderDate" : DateTime(orderValues.dateValue!.year, orderValues.dateValue!.month, orderValues.dateValue!.day, orderValues.timeValue!.hour, orderValues.timeValue!.minute),
            "orderInitiationDate" : currentTime,
          }
        });
      }


    } catch (err){
      print(err);
      return;
    }

    DocumentReference<Map<String, dynamic>> washMeRef = FirebaseFirestore.instance
        .collection('jobs')
        .doc("washMe");

    DocumentSnapshot<Map<String, dynamic>> washMeData = await washMeRef.get();

    List previousCities = washMeData.get("allCities") as List;

    if (!previousCities.contains(locationValues.adminArea.toString())){
      previousCities.add(locationValues.adminArea.toString());
      await FirebaseFirestore.instance
          .collection('jobs')
          .doc("washMe").update({"allCities": previousCities});
    }



    return await FirebaseFirestore.instance
        .collection('jobs')
        .doc("washMe")
        .collection("cities")
        .doc(locationValues.adminArea)
        .collection("activeRequests")
        .doc(orderKey)
        .set({
      "adminArea": locationValues.adminArea.toString(),
      "acceptedPrice" :"52",
      "carType" : orderValues.carClass,
      "orderDate" : DateTime(orderValues.dateValue!.year, orderValues.dateValue!.month, orderValues.dateValue!.day, orderValues.timeValue!.hour, orderValues.timeValue!.minute),
      "latitude" : locationValues.lat,
      "longitude" : locationValues.long,
      "streetNumberAndName" : locationValues.streetNumberAndName,
      "washType" : {"exterior" : orderValues.exteriorWashType, "extras" : extraWashType},
      "orderInitiationDate" : currentTime,
    });
  }

}
