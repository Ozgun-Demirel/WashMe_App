
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../InterfaceFunc/DatabaseHelpers/customerLocations.dart';
import '../../../Models/Users/locationValuesType.dart';


class FirestoreWashMeOrderShifterHelper {


  static Future<List> activeOrderLoader() async {

    var customerLocation = CustomerLocation();
    LocationValues? userAddress =await customerLocation.returnAllValues();

    CollectionReference<Map<String, dynamic>> activeRequestsRef = FirebaseFirestore
        .instance
        .collection('jobs')
        .doc("washMe")
        .collection("cities")
        .doc(userAddress!.adminArea)
        .collection("activeRequests");
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await activeRequestsRef.get();

    return [userAddress ,querySnapshot.docs];
  }

  static pendingRequestCreator(Map<String, dynamic> currentOrder, String orderKey) async {

    await FirebaseFirestore.instance
        .collection('jobs')
        .doc("washMe")
        .collection("cities")
        .doc(currentOrder["adminArea"])
        .collection("pendingRequests")
        .doc(orderKey)
        .set(currentOrder);

    await FirebaseFirestore.instance
        .collection('jobs')
        .doc("washMe")
        .collection("cities")
        .doc(currentOrder["adminArea"])
        .collection("activeRequests")
        .doc(orderKey).delete();
  }

  static ongoingRequestCreator(Map<String, dynamic> currentOrder, String orderKey) async {

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    DocumentSnapshot<Map<String, dynamic>> currentOrdersRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection("currentOrders")
        .doc("washMe").get();

    Map<String, dynamic> currentOrdersData = currentOrdersRef.data() as Map<String,dynamic>;

    currentOrdersData.remove(orderKey);

    var currentOrdersNewRef = await FirebaseFirestore.instance
        .collection('jobs')
        .doc("washMe")
        .collection("cities")
        .doc(currentOrder["adminArea"]).collection("pendingRequests").doc(orderKey).get();

    currentOrdersData[orderKey] = currentOrdersNewRef.data();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection("currentOrders")
        .doc("washMe").set(currentOrdersData);


      await FirebaseFirestore.instance
          .collection('jobs')
          .doc("washMe")
          .collection("cities")
          .doc(currentOrder["adminArea"])
          .collection("ongoingRequests")
          .doc(orderKey)
          .set(currentOrder);

    await FirebaseFirestore.instance
        .collection('jobs')
        .doc("washMe")
        .collection("cities")
        .doc(currentOrder["adminArea"])
        .collection("pendingRequests")
        .doc(orderKey).delete();
  }

  static completedOrderCreator(Map<String, dynamic> currentOrder, String orderKey, bool isCompleted) async {

    currentOrder["isCompleted"] = isCompleted;

    await FirebaseFirestore.instance
        .collection('washerInformations')
        .doc(currentOrder["washerID"])
        .collection("previousJobs")
        .doc(orderKey)
        .set(currentOrder);

    await FirebaseFirestore.instance
        .collection('jobs')
        .doc("washMe")
        .collection("cities")
        .doc(currentOrder["adminArea"])
        .collection("ongoingRequests")
        .doc(orderKey).delete();

  }
}
