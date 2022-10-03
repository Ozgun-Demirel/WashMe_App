

import 'package:WashMe/InterfaceFunc/screenOpeners/showTransparentDialogOnLoad.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../Models/Users/userInformations.dart';
import '../../../DatabaseHelpers/SubHelpers/userMyInformationHelper.dart';


myInformationsOpener(BuildContext context, double deviceHeight, double deviceWidth, bool mounted, bool replaced, ) async {

  showTransparentDialogOnLoad(context, deviceHeight, deviceWidth);

  UserInformations? userInformations = await getMyInformations();

  if(!mounted) return;
  Navigator.of(context).pop();

  replaced ? Navigator.of(context).pushReplacementNamed("/MyInformation", arguments: {"userInformations" : userInformations}) : Navigator.of(context).pushNamed("/MyInformation", arguments: {"userInformations" : userInformations});

}


Future<UserInformations?> getMyInformations() async {
  User? user = FirebaseAuth.instance.currentUser;
  var informationData = await InformationHelper.getInformationsData();
  if (informationData.isNotEmpty) {
    return UserInformations.fromMap(informationData[0]);
  }
  DocumentSnapshot<Map<String, dynamic>> documentRef = await
  FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
  return UserInformations.fromMap(documentRef.data() as Map<String, dynamic>);
}


