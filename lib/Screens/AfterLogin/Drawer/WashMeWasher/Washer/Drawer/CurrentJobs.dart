import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../../../FirebaseHelper/FirestoreHelpers/WashMeOperationsHelper/washMeOrderCompletion.dart';
import '../../../../../../InterfaceFunc/DatabaseHelpers/customerLocations.dart';
import '../../../../../../InterfaceFunc/screenOpeners/showTransparentDialogOnLoad.dart';

class CurrentJobs extends StatefulWidget {
  static const routeName = "/CurrentJobs";
  const CurrentJobs({Key? key}) : super(key: key);

  @override
  State<CurrentJobs> createState() => _CurrentJobsState();
}

int currentPage = 0;

class _CurrentJobsState extends State<CurrentJobs> {



  GoogleMapController? mapController;
  GlobalKey<State<StatefulWidget>>? mapKey;
  Set<Marker> globalMarkers = {};
  CustomerLocation customerLocation = CustomerLocation();

  LatLng selectedCustomerLatLong = const LatLng(31.2, -99.6);

  @override
  Widget build(BuildContext context) {

    final Map<String, dynamic> arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map<String, dynamic>;
    List? ordersList = arguments["ordersList"] as List;

    final double _deviceHeight = MediaQuery.of(context).size.height;
    final double _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(_deviceWidth / 45),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: _deviceHeight / 45,
            ),
            hamMenuAndTitle(_deviceWidth, context),
            SizedBox(
              height: _deviceHeight / 30,
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                "Current Jobs",
                style: GoogleFonts.openSans(
                    fontWeight: FontWeight.bold, fontSize: _deviceWidth / 21),
              ),
            ),
            SizedBox(
              height: _deviceHeight / 45,
            ),
            ordersBuilder(_deviceHeight, _deviceWidth, ordersList),
            SizedBox(
              height: _deviceHeight / 45,
            ),
            Visibility(
                visible: currentPage == 1,
                child: Column(
              children: [
                Text("If you have any problem in your order, please contact us",
                  style: GoogleFonts.openSans(
                      fontWeight: FontWeight.bold,
                      fontSize: _deviceWidth / 22),
                  textAlign: TextAlign.center,),
                TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap,),
                  onPressed: (){
                    null;
                  },
                  child: Text("here!",
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.bold,
                      fontSize: _deviceWidth / 22,
                      decoration: TextDecoration.underline,),
                    textAlign: TextAlign.center,),),
              ],
            )),

            SizedBox(height: _deviceHeight/40,),
          ],
        ),
      ),
    ));
  }

  hamMenuAndTitle(double deviceHeight, BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: SizedBox(
              height: deviceHeight / 6.6,
              child: TextButton(
                child: Icon(
                  Icons.keyboard_backspace,
                  color: const Color(0xFF2D9BF0),
                  size: deviceHeight / 6.6,
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
                    fontSize: deviceHeight / 9, color: const Color(0xFF2D9BF0)),
              ),
            )),
        const Expanded(flex: 1, child: SizedBox())
      ],
    );
  }

  Widget pendingJobsPage(double deviceHeight, double deviceWidth,
      Map pendingJobsMap, BuildContext context) {
    List pendingJobsKeys = pendingJobsMap.keys.toList();
    List pendingJobsValues = pendingJobsMap.values.toList();

    if (pendingJobsKeys.isEmpty) {
      return Column(
        children: [
          SizedBox(height: deviceHeight / 60,),
          Text(
            "There is no pending order right now. You have to accept some orders first.",
            style: GoogleFonts.openSans(
                fontWeight: FontWeight.bold,
                fontSize: deviceWidth / 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: deviceHeight / 40,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Go to orders page",
                  style: GoogleFonts.openSans(
                      fontWeight: FontWeight.bold, fontSize: deviceWidth / 20),
                  textAlign: TextAlign.center,
                ),
              )),
        ],
      );
    }
    return SizedBox(
      width: double.infinity,
      child: orderListViewBuilder(
          pendingJobsKeys, pendingJobsValues, deviceHeight, deviceWidth),
    );
  }

  Widget ongoingJobsPage(double deviceHeight, double deviceWidth,
      Map ongoingJobsMap, BuildContext context) {
    List ongoingJobsKeys = ongoingJobsMap.keys.toList();
    List ongoingJobsValues = ongoingJobsMap.values.toList();

    return SizedBox(
      width: double.infinity,
      child: orderListViewBuilder(
          ongoingJobsKeys, ongoingJobsValues, deviceHeight, deviceWidth),
    );

  }

  Widget _currentJobsMapBuilder(double deviceHeight, double deviceWidth) {
    CameraPosition initialCameraPosition = const CameraPosition(
      target: LatLng(31.2, -99.6),
      zoom: 6,
    );
    return GoogleMap(
      // Because the map is in SingleChildScrollView, it is not possible to drag the map.
      // By adding the line below, it becomes possible by setting google map unscrollable.
      gestureRecognizers: Set()
        ..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),

      onMapCreated: (controller) async {
        var currentLocation = await customerLocation.returnAllValues();
        mapController = controller;

        globalMarkers = {
          Marker(
              markerId: const MarkerId("You"),
              position: LatLng(double.parse(currentLocation!.lat.toString()),
                  double.parse(currentLocation.long.toString())))
        };

        setState(() {
          animateMap(double.parse(currentLocation.lat.toString()),
              double.parse(currentLocation.long.toString()),
              zoom: 16);
        });
      },
      markers: globalMarkers,
      myLocationEnabled: true,
      key: mapKey,
      myLocationButtonEnabled: true,
      initialCameraPosition: initialCameraPosition,
    );
  }

  Widget washInformationsBuilder(double deviceHeight, double deviceWidth,
      Map<String, dynamic> currentOrder, String date, int index, String extraWashTypes, minDifference, currentOrderKey) {
    return Column(
      children: [
        SizedBox(
          height: deviceHeight / 60,
        ),
        GestureDetector(
          onTap: () {

            if(currentPage == 0) null;

            if (selectedCustomerLatLong !=
                LatLng(double.parse(currentOrder["latitude"]),
                    double.parse(currentOrder["longitude"]))) {
              setState(() {
                selectedCustomerLatLong = LatLng(
                    double.parse(currentOrder["latitude"]),
                    double.parse(currentOrder["longitude"]));
              });
            }

            globalMarkers.remove(const MarkerId("customerMarker"));


            var customerBitMap = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);

            globalMarkers.add(Marker(markerId: const MarkerId("customerMarker"), position: selectedCustomerLatLong, icon: customerBitMap,alpha: 0.8,  )) ;


            setState(() {
              animateMap(selectedCustomerLatLong.latitude, selectedCustomerLatLong.longitude, zoom: 15);
            });
          },
          child: Card(
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
                  Row(
                    children: [
                      const Expanded(flex: 1, child: SizedBox()),
                      Visibility(
                        visible: currentPage == 1,
                        child: Expanded(
                          flex: 2,
                          child: Radio<LatLng>(
                            value: LatLng(double.parse(currentOrder["latitude"]),
                                double.parse(currentOrder["longitude"])),
                            groupValue: selectedCustomerLatLong,
                            onChanged: (LatLng? value) {

                              if(value != null){
                                selectedCustomerLatLong = value;
                                if(
                                globalMarkers.length != 1
                                ){
                                  for (Marker element in globalMarkers){
                                    if (element.markerId == const MarkerId("customerMarker")){
                                      globalMarkers.remove(element);
                                    }
                                  }
                                }
                              }
                              var customerBitMap = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);

                              globalMarkers.add(Marker(markerId: const MarkerId("customerMarker"), position: selectedCustomerLatLong, icon: customerBitMap,alpha: 0.8,  )) ;


                              setState(() {
                                animateMap(selectedCustomerLatLong.latitude, selectedCustomerLatLong.longitude, zoom: 15);
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "${index + 1}",
                          style: GoogleFonts.openSans(
                              fontWeight: FontWeight.bold,
                              fontSize: deviceWidth / 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 24,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  currentOrder["carType"],
                                  style: GoogleFonts.openSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: deviceWidth / 24),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  currentOrder["washType"]["exterior"],
                                  style: GoogleFonts.openSans(
                                      fontSize: deviceWidth / 24),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  extraWashTypes,
                                  style: GoogleFonts.openSans(
                                      fontSize: deviceWidth / 24),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  currentOrder["streetNumberAndName"],
                                  style: GoogleFonts.openSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: deviceWidth / 24),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  date,
                                  style: GoogleFonts.openSans(
                                      fontSize: deviceWidth / 24),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  "\$${int.parse(currentOrder["acceptedPrice"])-13}",
                                  style: GoogleFonts.openSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: deviceWidth / 24),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  Visibility(
                    visible: currentPage == 1,
                    child: ElevatedButton(onPressed: (){


                      if (minDifference >10 || minDifference < -45){
                        return;
                      }


                      showTransparentDialogOnLoad(context, deviceHeight, deviceWidth);


                      washMeOrderCompletion(mounted, context, currentOrder, currentOrderKey);


                    }, child: SizedBox(
                        width: deviceWidth * (5/8),
                        height: deviceHeight /16,
                        child: Center(child: Text(minDifference >10 || minDifference < -45 ? "Can Not Complete Yet" : "Complete Order (${(minDifference+45).toStringAsFixed(0)}min left)",
                          style: GoogleFonts.openSans(
                              fontSize: deviceWidth / 26),)))),
                  ),


                  SizedBox(height: deviceHeight/100,),

                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  orderListViewBuilder(
      List jobsKeys, List jobsValues, double deviceHeight, double deviceWidth) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: jobsKeys.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> currentOrder = jobsValues[index] as Map<String, dynamic>;

          String extraWashTypes = "Extras: ";
          if (currentOrder["washType"]["extras"].toString() == "[]") {
            extraWashTypes = "No Extras";
          } else {
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
          }

          int timeRemaining = currentOrder["orderDate"].seconds * 1000;

          double minDifference = (timeRemaining - DateTime.now().millisecondsSinceEpoch)/(1000*60);

          final df = DateFormat('dd-MM-yyyy hh:mm a');
          String date = df.format(DateTime.fromMillisecondsSinceEpoch(timeRemaining));

          return washInformationsBuilder(deviceHeight, deviceWidth,
              currentOrder, date, index, extraWashTypes, minDifference, jobsKeys[index]);
        });
  }

  Future<void> animateMap(double lat, double long, {double? zoom}) =>
      mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(lat, long), zoom ?? 16));

  ordersBuilder(double deviceHeight, double deviceWidth, List ordersList) {

    Map pendingJobsMap = ordersList[0];
    Map ongoingJobsMap = ordersList[1];
    return Column(
      children: [
        SizedBox(
          height: deviceHeight / 80,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: currentPage == 0
                    ? const Color(0xFF2D9BF0)
                    : const Color(0xFF414BB2),
              ),
              onPressed: () {
                if (currentPage != 0) {
                  setState(() {
                    currentPage = 0;
                  });
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: deviceWidth / 40),
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
                          "Jobs",
                          style: GoogleFonts.openSans(
                              fontWeight: FontWeight.bold,
                              fontSize: deviceWidth / 28),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                    SizedBox(
                      width: deviceWidth / 80,
                    ),
                    Text(
                      "(${pendingJobsMap.keys.length})",
                      style: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold,
                          fontSize: deviceWidth / 28),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: currentPage == 1
                    ? const Color(0xFF2D9BF0)
                    : ongoingJobsMap.isEmpty
                    ? Colors.grey
                    : const Color(0xFF414BB2),
              ),
              onPressed: () {
                if (ongoingJobsMap.isEmpty) {
                  return;
                } else {
                  if (currentPage != 1) {
                    setState(() {
                      currentPage = 1;
                    });
                  }
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: deviceWidth / 40),
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
                          "Jobs",
                          style: GoogleFonts.openSans(
                              fontWeight: FontWeight.bold,
                              fontSize: deviceWidth / 28),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                    SizedBox(
                      width: deviceWidth / 80,
                    ),
                    Text(
                      "(${ongoingJobsMap.keys.length})",
                      style: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold,
                          fontSize: deviceWidth / 28),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: deviceHeight / 60,
        ),
        Visibility(visible: currentPage == 1 ,child: Text(
          "You can track your jobs from below map",
          style: GoogleFonts.openSans(
              fontWeight: FontWeight.bold,
              fontSize: deviceWidth / 18),
          textAlign: TextAlign.center,
        ),),
        Visibility(visible: currentPage == 1,child: SizedBox(
          width: double.infinity,
          height: deviceHeight * (2 / 5),
          child: _currentJobsMapBuilder(deviceHeight, deviceWidth),
        ),),

        currentPage == 0
            ? pendingJobsPage(
            deviceHeight, deviceWidth, pendingJobsMap, context)
            : ongoingJobsPage(
            deviceHeight, deviceWidth, ongoingJobsMap, context),
      ],
    );
  }


}
