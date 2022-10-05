
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../../FirebaseHelper/FirestoreHelpers/WasherHelpers/orderShifterHelper.dart';
import '../../../../../InterfaceFunc/DatabaseHelpers/customerLocations.dart';
import '../../../../../InterfaceFunc/screenOpeners/WasherSide/currentJobsOpener.dart';
import '../../../../../InterfaceFunc/screenOpeners/WasherSide/previousJobsOpener.dart';
import '../../../../../InterfaceFunc/screenOpeners/WasherSide/washerRequestsOpener.dart';
import '../../../../../InterfaceFunc/screenOpeners/showTransparentDialogOnLoad.dart';
import '../../../../../Models/Users/locationValuesType.dart';

class WasherRequests extends StatefulWidget {
  static const routeName = "/WasherRequests";
  const WasherRequests({Key? key}) : super(key: key);

  @override
  State<WasherRequests> createState() => _WasherRequestsState();
}

class _WasherRequestsState extends State<WasherRequests> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool filtered = false;
  LatLng selectedCustomerLatLong =const LatLng(31.2, -99.6);

  GoogleMapController? mapController;
  GlobalKey<State<StatefulWidget>>? mapKey;
  Set<Marker> globalMarkers = {};
  CustomerLocation customerLocation = CustomerLocation();


  @override
  Widget build(BuildContext context) {

    final Map<String, dynamic> arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map<String, dynamic>;
    List? addressAndActiveOrders = arguments["addressAndActiveOrders"] as List;
    String washerName = arguments["washerName"] as String;

    List orderKeysList = [];
    List ordersList = [];
    for (var element in addressAndActiveOrders[1]) {
      orderKeysList.add(element.id);
      ordersList.add(element.data());
    }

    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        key: scaffoldKey,
        drawer: Drawer(
          child: drawerBuilder(_deviceHeight, _deviceWidth, context),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.only(top: _deviceWidth / 45, bottom: _deviceWidth / 45, left: _deviceWidth / 60, right: _deviceWidth / 60),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: _deviceHeight / 45,
                ),
                hamMenuAndTitle(_deviceWidth, context),
                welcomer(_deviceWidth, washerName),
                SizedBox(
                  height: _deviceHeight / 40,
                ),
                map(_deviceHeight, _deviceWidth),
                SizedBox(
                  height: _deviceHeight / 40,
                ),
                filter(_deviceWidth, context),
                SizedBox(height: _deviceHeight/60,),
                ordersBuilder(_deviceHeight, _deviceWidth, context,  orderKeysList, ordersList, addressAndActiveOrders[0]),
              ],
            ),
          ),
        ));
  }

  hamMenuAndTitle(double deviceWidth, BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextButton(
            onPressed: () {
              scaffoldKey.currentState!.openDrawer();
            },
            child: Icon(
              Icons.menu_rounded,
              color: const Color(0xFF414BB2),
              size: deviceWidth / 6.6,
            ),
          ),
        ),
        Expanded(
          flex: 12,
          child: Center(
            child: Text(
              "WashMe Washer",
              textAlign: TextAlign.center,
              style: GoogleFonts.fredokaOne(
                  fontSize: deviceWidth / 12, color: const Color(0xFF2D9BF0)),
            ),
          ),
        ),
        const Expanded(flex: 1, child: SizedBox())
      ],
    );
  }


  Widget drawerBuilder(
      double deviceHeight, double deviceWidth, BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        SizedBox(
          height: deviceHeight / 20,
        ),
        SizedBox(
          height: deviceHeight / 10,
          child: Text(
            "WashMe",
            textAlign: TextAlign.center,
            style: GoogleFonts.fredokaOne(
                fontSize: deviceWidth / 9, color: const Color(0xFF2D9BF0)),
          ),
        ),
        ListTile(
          title: const Text('Current Jobs'),
          visualDensity: const VisualDensity(vertical: -3),
          onTap: () async {

            showTransparentDialogOnLoad(context, deviceHeight, deviceWidth);

            currentJobsOpener(context, mounted);

          },
        ),
        ListTile(
          title: const Text('Previous Jobs'),
          visualDensity: const VisualDensity(vertical: -3),
          onTap: () {

            showTransparentDialogOnLoad(context, deviceHeight, deviceWidth);

            previousJobsOpener(context, mounted);

          },
        ),
        ListTile(
          title: const Text('Earnings and Payments'),
          visualDensity: const VisualDensity(vertical: -3),
          onTap: () {
            null;
          },
        ),
        const ListTile(
          title: Divider(color: Colors.grey, thickness: 1),
          visualDensity: VisualDensity(vertical: -3),
        ),
        ListTile(
          title: const Text('Washer Board'),
          visualDensity: const VisualDensity(vertical: -3),
          onTap: () {
            Navigator.of(context).pushNamed("/WasherBoard");
          },
        ),
        const ListTile(
          title: Divider(color: Colors.grey, thickness: 1),
          visualDensity: VisualDensity(vertical: -3),
        ),
        ListTile(
          title: const Text('Return to Customer Portal'),
          visualDensity: const VisualDensity(vertical: -3),
          onTap: () {
            Navigator.popUntil(
                context, ModalRoute.withName("/ALClientInputs"));
          },
        ),
      ],
    );
  }

  Widget welcomer(double deviceWidth, String washerName) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            "Hi $washerName,",
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSans(fontSize: deviceWidth / 16, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Text(
            "WashMe requests",
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSans(fontSize: deviceWidth / 16, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Text(
            "are waiting for you!",
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSans(fontSize: deviceWidth / 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget map(double deviceHeight, double deviceWidth) {
    CameraPosition initialCameraPosition = const CameraPosition(
      target: LatLng(31.2, -99.6),
      zoom: 6,
    );

    return SizedBox(
        width: double.infinity,
        height: deviceHeight * (2/5),
        child: GoogleMap(
          // Because the map is in SingleChildScrollView, it is not possible to drag the map.
          // By adding the line below, it becomes possible by setting google map unscrollable.
          gestureRecognizers: Set()..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),

          onMapCreated: (controller) async {
            var currentLocation = await customerLocation.returnAllValues();
            mapController = controller;

            globalMarkers = {
              Marker(
                  markerId: const MarkerId("You"),
                  position: LatLng(double.parse(currentLocation!.lat.toString()), double.parse(currentLocation.long.toString()) ))
            };

            setState(() {
              animateMap(double.parse(currentLocation.lat.toString()), double.parse(currentLocation.long.toString()), zoom: 16);
            });
          },
          markers: globalMarkers,
          myLocationEnabled: true,
          key: mapKey,
          myLocationButtonEnabled: true,
          initialCameraPosition: initialCameraPosition,
          // scrollGesturesEnabled: false,
        )
    );
  }

  Widget filter(double deviceWidth, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextButton(
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            onPressed: (){
              setState((){
                filtered = !filtered;
              });
            },
            child: Text(filtered == true ? "Reset filters" : "Filter requests", style: GoogleFonts.notoSans(decoration: TextDecoration.underline, fontWeight: FontWeight.bold, fontSize: deviceWidth/20, color: filtered == true ? Colors.deepOrangeAccent :  Colors.blue,), textAlign: TextAlign.left, ),
          ),
        ],
      ),
    );
  }


  Widget ordersBuilder(double deviceHeight, double deviceWidth, BuildContext context, List orderKeysList, List ordersList, LocationValues locationValues) {
    return SizedBox(
      width: double.infinity,
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero, itemCount: orderKeysList.length ,itemBuilder: (BuildContext context, int index){

        Map<String, dynamic> currentOrder = ordersList[index];
        String extraWashTypes = "Extras: ";
        for (int extraLength =0; extraLength< currentOrder["washType"]["extras"].length; extraLength++){
          extraWashTypes += currentOrder["washType"]["extras"][extraLength] + "/";
        }
        extraWashTypes = extraWashTypes.substring(0, extraWashTypes.length-1); // deleted last character from string. which in this case removes excess /

        double oneLongitudeDegreeToMiles = 54.6;
        int oneLatitudeDegreeToMiles = 69;
        int mileToYard = 1760;

        double latDistance = double.parse(locationValues.lat.toString()) - double.parse(currentOrder["latitude"]);
        double longDistance = double.parse(locationValues.long.toString()) - double.parse(currentOrder["longitude"]);
        double distanceMile = sqrt(pow(latDistance*oneLatitudeDegreeToMiles,2) + pow(longDistance*oneLongitudeDegreeToMiles, 2));

        String strDistance = distanceMile<1 ? "${(distanceMile* mileToYard).toStringAsFixed(2)} yard" : "${distanceMile.toStringAsFixed(2)} mile(s)";

        final df = DateFormat('dd-MM-yyyy hh:mm a');
        String orderDate = df.format(DateTime.fromMillisecondsSinceEpoch(currentOrder["orderDate"].seconds*1000));

        return Column(
          children: [
            Card(
              shadowColor: Colors.blueAccent,
              elevation: 8,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(deviceWidth / 20)),
              child: Container(
                decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      colors: [Colors.white, Colors.blueGrey],
                       center: Alignment.center,
                      radius: 2
                    )),
                child: Column(
                  children: [
                    SizedBox(height: deviceHeight/80,),
                    Row(
                      children: [
                        Expanded(flex: 1, child: Radio<LatLng>(
                          value: LatLng(double.parse(currentOrder["latitude"]),double.parse(currentOrder["longitude"])),
                          groupValue: selectedCustomerLatLong,
                          onChanged: (LatLng? value) {

                            try {
                              if(value != null){
                                selectedCustomerLatLong = value;
                                for (Marker element in globalMarkers){
                                  if (element.markerId == const MarkerId("customerMarker")){
                                    globalMarkers.remove(element);
                                  }
                                }
                                globalMarkers.add(Marker(markerId: const MarkerId("customerMarker"), position: selectedCustomerLatLong)) ;
                              }
                            } catch(err){
                              print(err);
                            }

                            setState(() {
                              animateMap(selectedCustomerLatLong.latitude, selectedCustomerLatLong.longitude, zoom: 15);
                            });
                          },
                        ),),
                        Expanded(
                          flex: 9,
                          child: GestureDetector(
                            onTap: () {

                              selectedCustomerLatLong= LatLng(double.parse(currentOrder["latitude"]),double.parse(currentOrder["longitude"]));

                              print(globalMarkers);


                              // this try-catch block handles the error behind but removing it releases it again. This error should be handled later.
                              try {
                                for (Marker element in globalMarkers){
                                  if (element.markerId == const MarkerId("customerMarker")){
                                    globalMarkers.remove(element);
                                  }
                                }
                              } catch (err) {
                                print(err);
                              }

                              globalMarkers.add(Marker(markerId: const MarkerId("customerMarker"), position: selectedCustomerLatLong)) ;

                              animateMap(selectedCustomerLatLong.latitude, selectedCustomerLatLong.longitude, zoom: 16);
                              setState((){});
                            },
                            child: Column(
                              children: [
                                SizedBox( width: double.infinity, child: Text(currentOrder["carType"].toString(), style: GoogleFonts.notoSans(fontSize: deviceWidth/20, fontWeight: FontWeight.bold), textAlign: TextAlign.left,)),
                                SizedBox( width: double.infinity, child: Text(currentOrder["washType"]["exterior"].toString(), style: GoogleFonts.notoSans(fontSize: deviceWidth/20,), textAlign: TextAlign.left,)),
                                SizedBox( width: double.infinity, child: Text(currentOrder["washType"]["extras"].length == 0 ? "No extra wash" : extraWashTypes, style: GoogleFonts.notoSans(fontSize: deviceWidth/20,), textAlign: TextAlign.left,)),
                                SizedBox( width: double.infinity, child: Text(currentOrder["streetNumberAndName"].toString(), style: GoogleFonts.notoSans(fontSize: deviceWidth/20,), textAlign: TextAlign.left,)),
                                SizedBox( width: double.infinity, child: Text("${currentOrder["adminArea"]}", style: GoogleFonts.notoSans(fontSize: deviceWidth/20,), textAlign: TextAlign.left,)),
                                SizedBox( width: double.infinity, child: Text(strDistance, style: GoogleFonts.notoSans(fontSize: deviceWidth/20, fontWeight: FontWeight.bold), textAlign: TextAlign.left,)),
                                SizedBox( width: double.infinity, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(orderDate, style: GoogleFonts.notoSans(fontSize: deviceWidth/20), textAlign: TextAlign.right,), Text("\$${int.parse(currentOrder["acceptedPrice"])-13}", style: GoogleFonts.notoSans(fontSize: deviceWidth/20, fontWeight: FontWeight.bold), textAlign: TextAlign.left,),],)),
                              ],
                            ),
                          ),),
                      ],
                    ),
                    SizedBox(height: deviceHeight/60,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () async {

                            showTransparentDialogOnLoad(context, deviceHeight, deviceWidth);

                            var auth = FirebaseAuth.instance;
                            var user = auth.currentUser;

                            DocumentReference<Map<String, dynamic>> washerDocumentRef = FirebaseFirestore.instance.collection('users')
                                .doc(user!.uid)
                                .collection("washer")
                                .doc("washerInformations");
                            DocumentSnapshot<Map<String, dynamic>> washerQuerySnapshot = await washerDocumentRef.get();
                            Map<String, dynamic>? washerData = washerQuerySnapshot.data();
                            currentOrder.addAll({"washerID": washerData!["washerID"]});

                            await FirestoreWashMeOrderShifterHelper.pendingRequestCreator(currentOrder, orderKeysList[index]);

                            Map<String, dynamic> activeJobsDict = {
                              orderKeysList[index].toString() : ordersList[index],
                            };

                            await FirebaseFirestore.instance
                                .collection('jobs')
                                .doc("washMe")
                                .collection("cities")
                                .doc(currentOrder["adminArea"])
                                .collection("activeRequests")
                                .doc(orderKeysList[index].toString()).delete();

                            DocumentReference<Map<String, dynamic>> documentRef = FirebaseFirestore.instance.collection('users')
                                .doc(user.uid)
                                .collection("washer")
                                .doc("activeJobs");
                            DocumentSnapshot<Map<String, dynamic>> querySnapshot = await documentRef.get();
                            Map<String, dynamic>? data = querySnapshot.data();
                            if (data != null){
                              data.addAll(activeJobsDict);
                              await documentRef.set(data);
                            } else {
                              await documentRef.set(activeJobsDict);
                            }


                            if (!mounted) return;
                            Navigator.of(context).pop();
                            washerRequestsOpener(context, mounted);

                          }, child: SizedBox(
                          width: deviceWidth * (3/10),
                          height: deviceHeight/15,
                          child: Center(child: Text("Accept", style: GoogleFonts.notoSans(fontSize: deviceWidth/20,), textAlign: TextAlign.center),),),),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blueGrey,
                            ),
                            onPressed: () async {

                              print(index);
                            },

                            child: SizedBox(
                                width: deviceWidth* (3/10),
                                height: deviceHeight/15,
                                child: Center(child: Text("Hide", style: GoogleFonts.notoSans(fontSize: deviceWidth/20,), textAlign: TextAlign.center)))),
                      ],
                    ),
                    SizedBox(height: deviceHeight/40,),
                  ],
                ),
              ),
            ),
            SizedBox(height: deviceHeight/40,),
          ],
        );
      }),
    );
  }

  animateMap(double lat, double long, {double? zoom})=> mapController!.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, long), zoom ?? 16));

}
