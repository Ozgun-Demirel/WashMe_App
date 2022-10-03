

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../../InterfaceFunc/DatabaseHelpers/customerLocations.dart';
import '../../../InterfaceFunc/screenOpeners/CustomerSide/BLCurrentOrdersOpener.dart';
import '../../../InterfaceFunc/screenOpeners/showTransparentDialogOnLoad.dart';

class BLCurrentOrders extends StatefulWidget {
  static const routeName = "/BLCurrentOrders";
  const BLCurrentOrders({Key? key}) : super(key: key);

  @override
  State<BLCurrentOrders> createState() => _BLCurrentOrdersState();
}

class _BLCurrentOrdersState extends State<BLCurrentOrders> {
  int currentPage = 0;

  LatLng selectedCustomerLatLong = const LatLng(31.2, -99.6);

  GoogleMapController? mapController;
  GlobalKey<State<StatefulWidget>>? mapKey;
  Set<Marker> globalMarkers = {};
  CustomerLocation customerLocation = CustomerLocation();

  @override
  Widget build(BuildContext context) {
    final Map<String, List> arguments =
    (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{})
    as Map<String, List>;
    List<Map>? ordersInfo = arguments["ordersInfo"] as List<Map>;

    Map activeOrdersMap = ordersInfo[0];

    Map pendingOrdersMap = ordersInfo[1];

    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(deviceWidth / 45),
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: deviceHeight / 45,
            ),
            hamMenuAndTitle(deviceHeight, deviceWidth, context),
            SizedBox(
              height: deviceHeight / 45,
            ),
            navigatorButtonsBuilder(deviceWidth, deviceHeight, activeOrdersMap,
                pendingOrdersMap, {}),
            currentPage == 0
                ? _activeOrdersPage(
                deviceHeight, deviceWidth, activeOrdersMap, context)
                : pendingOrdersPage(
                deviceHeight, deviceWidth, pendingOrdersMap, context),
          ]),
        ),
      ),
    );
  }

  hamMenuAndTitle(
      double deviceHeight, double deviceWidth, BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: SizedBox(
              height: deviceHeight / 10,
              child: TextButton(
                child: Icon(
                  Icons.keyboard_backspace,
                  color: const Color(0xFF2D9BF0),
                  size: deviceWidth / 6.6,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )),
        Expanded(
            flex: 10,
            child: Center(
              child: Text(
                "WashMe",
                style: GoogleFonts.fredokaOne(
                    fontSize: deviceWidth / 9, color: const Color(0xFF2D9BF0)),
              ),
            )),
        const Expanded(flex: 1, child: SizedBox())
      ],
    );
  }

  navigatorButtonsBuilder(double deviceWidth, double deviceHeight,
      Map activeOrdersMap, Map pendingOrdersMap, Map ongoingOrdersMap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: currentPage == 0 ? Colors.lightBlueAccent : const Color(0xFF414BB2),
          ),
          onPressed: () {
            if (currentPage != 0) {
              setState(() {
                currentPage = 0;
              });
            }
          },
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    "Active",
                    style: GoogleFonts.openSans(
                        fontWeight: FontWeight.bold,
                        fontSize: deviceWidth / 28),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Requests",
                    style: GoogleFonts.openSans(
                        fontWeight: FontWeight.bold,
                        fontSize: deviceWidth / 28),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Text(
                "(${activeOrdersMap.length})",
                style: GoogleFonts.openSans(
                    fontWeight: FontWeight.bold, fontSize: deviceWidth / 28),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: currentPage == 1 ? Colors.lightBlueAccent : const Color(0xFF414BB2),
          ),
          onPressed: () {
            if (pendingOrdersMap.isEmpty) {
              return;
            } else {
              if (currentPage != 1) {
                setState(() {
                  currentPage = 1;
                });
              }
            }
          },
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    "Pending",
                    style: GoogleFonts.openSans(
                        fontWeight: FontWeight.bold,
                        fontSize: deviceWidth / 28),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Requests",
                    style: GoogleFonts.openSans(
                        fontWeight: FontWeight.bold,
                        fontSize: deviceWidth / 28),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Text(
                "(${pendingOrdersMap.length})",
                style: GoogleFonts.openSans(
                    fontWeight: FontWeight.bold, fontSize: deviceWidth / 28),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: currentPage == 2 ? Colors.lightBlueAccent : const Color(0xFF414BB2),),
          onPressed: () async {

            youNeedToLoginFirstDialog(deviceHeight, deviceWidth, context);

          },
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    "Ongoing",
                    style: GoogleFonts.openSans(
                        fontWeight: FontWeight.bold,
                        fontSize: deviceWidth / 28),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Requests",
                    style: GoogleFonts.openSans(
                        fontWeight: FontWeight.bold,
                        fontSize: deviceWidth / 28),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Text(
                "(${ongoingOrdersMap.length})",
                style: GoogleFonts.openSans(
                    fontWeight: FontWeight.bold, fontSize: deviceWidth / 28),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  _activeOrdersPage(double deviceHeight, double deviceWidth,
      Map activeOrdersMap, BuildContext context) {
    if (activeOrdersMap.isEmpty) {
      return Column(
        children: [
          SizedBox(
            height: deviceHeight / 45,
          ),
          Center(
            child: Text(
              "There is no order at the moment. Please add one from main page.",
              style: GoogleFonts.openSans(
                fontSize: deviceWidth / 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    } else {
      List ordersList = activeOrdersMap.values.toList();
      List ordersKeyList = activeOrdersMap.keys.toList();
      return activeOrdersBuilder(
          deviceHeight, deviceWidth, context, ordersList, ordersKeyList);
    }
  }

  pendingOrdersPage(double deviceHeight, double deviceWidth,
      Map pendingOrdersMap, BuildContext context) {
    List ordersKeyList = pendingOrdersMap.keys.toList();
    List ordersList = pendingOrdersMap.values.toList();

    return pendingOrdersBuilder(
        deviceHeight, deviceWidth, context, ordersList, ordersKeyList);
  }

  washerInformationsBuilder(double deviceHeight, double deviceWidth,
      BuildContext context, washerInfo) {
    Map<String, dynamic> data = washerInfo as Map<String, dynamic>;

    String surname = data["nameAndAddress"]["surname"].toString();
    surname = "${surname[0].toUpperCase()}.";

    var middleName = data["nameAndAddress"]["middleName"];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: deviceWidth / 4,
              child: Image.network(
                data["profilePhotoURL"],
                fit: BoxFit.cover,
              ),
            ),
            Visibility(
              visible: data["optionalPhotoURL"] != "null",
              child: SizedBox(
                width: deviceWidth / 8,
              ),
            ),
            Visibility(
                visible: data["optionalPhotoURL"] != "null",
                child: SizedBox(
                    width: deviceWidth / 4,
                    child: Image.network(
                      data["optionalPhotoURL"],
                      fit: BoxFit.cover,
                    ))),
          ],
        ),
        SizedBox(
          height: deviceHeight / 60,
        ),
        Text(
          "${data["nameAndAddress"]["name"]} ${middleName == "null" ? "" : middleName} $surname",
          style: GoogleFonts.openSans(
              fontWeight: FontWeight.bold, fontSize: deviceWidth / 18),
        ),
        Text(
          "(Rating X.X/5.0 Total Washes YYY)",
          style: GoogleFonts.openSans(fontSize: deviceWidth / 18),
        ),
        SizedBox(
          height: deviceHeight / 60,
        ),
      ],
    );
  }


  void animateMap(double lat, double long, {double? zoom}) => mapController!
      .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, long), zoom ?? 16));

  activeOrdersBuilder(
      double deviceHeight,
      double deviceWidth,
      BuildContext context,
      List<dynamic> ordersList,
      List<dynamic> ordersKeyList) {
    return Column(
      children: [
        SizedBox(height: deviceHeight/40,),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(icon: Icon(Icons.refresh, size: deviceWidth/8, color: Colors.blue,), onPressed: (){setState(() {});}, padding: EdgeInsets.zero, ),
            SizedBox(width: deviceWidth/28,),
          ],
        ),
        SizedBox(
          width: double.infinity,
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: ordersList.length,
              itemBuilder: (BuildContext context, int index) {
                var currentOrder = ordersList[index];

                final df = DateFormat('dd-MM-yyyy hh:mm a');
                String orderDate = df.format(
                    DateTime.fromMillisecondsSinceEpoch(
                        currentOrder["orderDate"].seconds * 1000));

                String extraWashTypes = "Extras: ";
                for (int extraLength = 0;
                extraLength < currentOrder["washType"]["extras"].length;
                extraLength++) {
                  extraWashTypes +=
                      currentOrder["washType"]["extras"][extraLength] + "/";
                }
                extraWashTypes = extraWashTypes.substring(
                    0,
                    extraWashTypes.length -
                        1); // deleted last character from string. which in this case removes excess /

                int orderInitiationDate =
                    currentOrder["orderInitiationDate"].seconds * 1000;
                int timeNow = DateTime.now().millisecondsSinceEpoch;

                int passedTime = timeNow - orderInitiationDate;
                int passedMin = int.parse(
                    ((passedTime - passedTime % 60000) / 60000)
                        .toStringAsFixed(0));
                int passedSec = int.parse(
                    ((passedTime - passedTime % 1000) / 1000)
                        .toStringAsFixed(0)) %
                    60;

                int secRemaining = 59 - passedSec;
                int minRemaining = 14 - passedMin;

                String remainingTimeString =
                    "${minRemaining > 10 ? minRemaining : "0$minRemaining"}:${secRemaining > 10 ? secRemaining : "0$secRemaining"}";

                return Column(
                  children: [
                    Card(
                      shadowColor: Colors.blueAccent,
                      elevation: 8,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(deviceWidth / 20)),

                      child: Container(
                        padding: EdgeInsets.all(deviceWidth / 40),
                        decoration: const BoxDecoration(
                            gradient: RadialGradient(
                                colors: [Colors.white, Colors.blueGrey],
                                center: Alignment.center,
                                radius: 2)),
                        child: Column(
                          children: [

                            SizedBox(
                              height: deviceHeight / 80,
                            ),

                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                currentOrder["carType"],
                                style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: deviceWidth / 18),
                                textAlign: TextAlign.left,
                              ),
                            ),

                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                currentOrder["washType"]["exterior"],
                                style: GoogleFonts.openSans(
                                    fontSize: deviceWidth / 18),
                                textAlign: TextAlign.left,
                              ),
                            ),

                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                currentOrder["washType"]["extras"].length == 0
                                    ? "No Extra"
                                    : extraWashTypes,
                                style: GoogleFonts.openSans(
                                    fontSize: deviceWidth / 18),
                                textAlign: TextAlign.left,
                              ),
                            ),

                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                currentOrder["streetNumberAndName"],
                                style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: deviceWidth / 18),
                                textAlign: TextAlign.left,
                              ),
                            ),

                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                orderDate,
                                style: GoogleFonts.openSans(
                                    fontSize: deviceWidth / 18),
                                textAlign: TextAlign.left,
                              ),
                            ),

                            SizedBox(
                              height: deviceHeight / 80,
                            ),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: passedTime - passedTime % 900000 != 0 ? Colors.grey : const Color(0xFF414BB2),),
                              onPressed: () async {
                                if (passedTime - passedTime % 900000 != 0) {
                                  return;
                                }

                                showTransparentDialogOnLoad(
                                    context, deviceHeight, deviceWidth);

                                FirebaseAuth auth = FirebaseAuth.instance;
                                User? user = auth.currentUser;
                                DocumentReference<Map<String, dynamic>>
                                documentRef = FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user!.uid)
                                    .collection("currentOrders")
                                    .doc("washMe");
                                DocumentSnapshot<Map<String, dynamic>>
                                querySnapshot = await documentRef.get();
                                Map<String, dynamic>? data =
                                querySnapshot.data();
                                data!.remove(ordersKeyList[index]);
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .collection("currentOrders")
                                    .doc("washMe")
                                    .set(data);

                                await FirebaseFirestore.instance
                                    .collection('jobs')
                                    .doc("washMe")
                                    .collection("cities")
                                    .doc(currentOrder["adminArea"])
                                    .collection("activeRequests")
                                    .doc(ordersKeyList[index])
                                    .delete();

                                if (!mounted) return;

                                BLCurrentOrdersOpener(
                                    deviceHeight, deviceWidth, context, mounted,
                                    replaced: true);
                              },
                              child: Text(passedTime - passedTime % 900000 == 0
                                  ? "Cancel remaining: $remainingTimeString"
                                  : "Cancel Unavailable"),
                            ), // "Cancel active Order"
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: deviceHeight / 60,
                    ),
                  ],
                );
              }),
        ),
      ],
    );
  }

  pendingOrdersBuilder(
      double deviceHeight,
      double deviceWidth,
      BuildContext context,
      List<dynamic> ordersList,
      List<dynamic> ordersKeyList) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: ordersList.length,
              itemBuilder: (BuildContext context, int index) {
                var currentOrder = ordersList[index];

                final df = DateFormat('dd-MM-yyyy hh:mm a');
                String orderDate = df.format(
                    DateTime.fromMillisecondsSinceEpoch(
                        currentOrder["orderDate"].seconds * 1000));

                String extraWashTypes = "Extras: ";
                for (int extraLength = 0;
                extraLength < currentOrder["washType"]["extras"].length;
                extraLength++) {
                  extraWashTypes +=
                      currentOrder["washType"]["extras"][extraLength] + "/";
                }
                extraWashTypes = extraWashTypes.substring(
                    0,
                    extraWashTypes.length -
                        1); // deleted last character from string. which in this case removes excess /

                return Column(
                  children: [
                    washerInformationsBuilder(deviceHeight, deviceWidth,
                        context, currentOrder["washerInfo"]),
                    Card(
                      shadowColor: Colors.blueAccent,
                      elevation: 8,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(deviceWidth / 20)),
                      child: Container(
                        padding: EdgeInsets.all(deviceWidth / 40),
                        decoration: const BoxDecoration(
                            gradient: RadialGradient(
                                colors: [Colors.white, Colors.blueGrey],
                                center: Alignment.center,
                                radius: 2)),
                        child: Column(
                          children: [
                            SizedBox(
                              height: deviceHeight / 80,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                currentOrder["carType"],
                                style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: deviceWidth / 18),
                                textAlign: TextAlign.left,
                              ),
                            ),

                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                currentOrder["washType"]["exterior"],
                                style: GoogleFonts.openSans(
                                    fontSize: deviceWidth / 18),
                                textAlign: TextAlign.left,
                              ),
                            ),

                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                currentOrder["washType"]["extras"].length == 0
                                    ? "No Extra"
                                    : extraWashTypes,
                                style: GoogleFonts.openSans(
                                    fontSize: deviceWidth / 18),
                                textAlign: TextAlign.left,
                              ),
                            ),

                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                currentOrder["streetNumberAndName"],
                                style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: deviceWidth / 18),
                                textAlign: TextAlign.left,
                              ),
                            ),

                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                orderDate,
                                style: GoogleFonts.openSans(
                                    fontSize: deviceWidth / 18),
                                textAlign: TextAlign.left,
                              ),
                            ),

                            SizedBox(
                              height: deviceHeight / 40,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                    onPressed: () async {
                                      showTransparentDialogOnLoad(
                                          context, deviceHeight, deviceWidth);

                                      FirebaseAuth auth = FirebaseAuth.instance;
                                      User? user = auth.currentUser;
                                      DocumentReference<Map<String, dynamic>>
                                      documentRef = FirebaseFirestore
                                          .instance
                                          .collection('users')
                                          .doc(user!.uid)
                                          .collection("currentOrders")
                                          .doc("washMe");
                                      DocumentSnapshot<Map<String, dynamic>>
                                      querySnapshot =
                                      await documentRef.get();
                                      Map<String, dynamic>? data =
                                      querySnapshot.data();
                                      data!.remove(ordersKeyList[index]);
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .collection("currentOrders")
                                          .doc("washMe")
                                          .set(data);

                                      await FirebaseFirestore.instance
                                          .collection('jobs')
                                          .doc("washMe")
                                          .collection("cities")
                                          .doc(currentOrder["adminArea"])
                                          .collection("pendingRequests")
                                          .doc(ordersKeyList[index])
                                          .delete();

                                      if (!mounted) return;

                                      BLCurrentOrdersOpener(deviceHeight,
                                          deviceWidth, context, mounted,
                                          replaced: true);
                                    },
                                    child: const Text("Cancel Order")),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: const Color(0xFF2D9BF0),
                                    ),
                                    onPressed: () async {

                                      youNeedToLoginFirstDialog(deviceHeight, deviceWidth, context);


                                    },
                                    child: const Text("Confirm Order"))
                              ],
                            ), // "Cancel active Order"
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: deviceHeight / 60,
                    ),
                  ],
                );
              }),
        ),
      ],
    );
  }

  void youNeedToLoginFirstDialog(double deviceHeight, double deviceWidth, BuildContext context) async {

    showDialog(context: context, builder: (BuildContext context){
      return SimpleDialog(
        children: [
          Padding(
            padding: EdgeInsets.all(deviceWidth/40),
            child: Column(
              children: [
                Text("You need to Login first.",
                  style: GoogleFonts.openSans(
                      fontSize: deviceWidth / 18),
                  textAlign: TextAlign.center,),

                SizedBox(height: deviceHeight/60,),

                ElevatedButton(onPressed: (){

                  Navigator.of(context).pushNamed("/LoginPage");

                }, child: const Text("Go To Login")),
              ],
            ),
          ),

        ],
      );
    });
  }

}
