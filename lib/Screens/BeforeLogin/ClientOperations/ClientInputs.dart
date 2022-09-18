import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:time_picker_widget/time_picker_widget.dart';

import '../../../FirebaseHelper/FirestoreHelpers/UserHelpers/UserLocationsHelper.dart';
import '../../../FirebaseHelper/FirestoreHelpers/WashMeOperationsHelper/washMeOrderAdder.dart';
import '../../../InterfaceFunc/DatabaseHelpers/SubHelpers/onLoginSQLHelper.dart';
import '../../../InterfaceFunc/DatabaseHelpers/SubHelpers/userLocationsHelper.dart';
import '../../../InterfaceFunc/DatabaseHelpers/customerLocations.dart';
import '../../../InterfaceFunc/screenOpeners/CustomerSide/BLCurrentOrdersOpener.dart';
import '../../../InterfaceFunc/screenOpeners/showTransparentDialogOnLoad.dart';
import '../../../Models/JobModels/WashMe/OrderValues.dart';
import '../../../Models/Users/locationValuesType.dart';
import '../../CommonScreens/ReferAFriend.dart';
import '../Drawer/NotLogedInDialog.dart';

class BLClientInputs extends StatefulWidget {
  static const routeName = "/BLClientInputs";
  const BLClientInputs({Key? key}) : super(key: key);

  @override
  State<BLClientInputs> createState() => _BLClientInputsState();
}

class _BLClientInputsState extends State<BLClientInputs> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _mapKey = GlobalKey();
  GoogleMapController? _mapController;
  Set<Marker> globalMarkers = {};
  CameraPosition? _cameraPosition;

  int? selectedLocationId;
  LocationValues? _currentLocationValues = LocationValues();
  var customerLocation = CustomerLocation();

  OrderValues _orderValue = OrderValues();
  // List of items in our dropdown menu
  var dayItems = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  var hourItems = [
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
  ];
  var minuteItems = [
    '00',
    '15',
    '30',
    '45',
  ];
  var clockItems = [
    'A.M.',
    'P.M.',
  ];

  @override
  initState() {
    super.initState();
    getLocations();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        width: _deviceWidth * 5 / 8,
        child: drawerItems(_deviceHeight, _deviceWidth),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.all(_deviceWidth / 50),
          child: Column(
            children: [
              SizedBox(
                height: _deviceHeight / 45,
              ),
              _hamMenuAndTitle(_deviceWidth),
              _introduction(_deviceHeight),
              _loginRegister(_deviceHeight, _deviceWidth),
              SizedBox(
                height: _deviceHeight / 45,
              ),
              _location(_deviceHeight, _deviceWidth),
              SizedBox(
                height: _deviceHeight / 20,
              ),
              _washTime(_deviceHeight, _deviceWidth),
              SizedBox(
                height: _deviceHeight / 40,
              ),
              _carType(_deviceHeight, _deviceWidth),
              SizedBox(
                height: _deviceHeight / 40,
              ),
              _washType(_deviceHeight, _deviceWidth),
              SizedBox(
                height: _deviceHeight / 40,
              ),
              _findWasher(_deviceHeight, _deviceWidth),
            ],
          ),
        ),
      ),
    );
  }

  void getLocations() async {
    _currentLocationValues = await customerLocation.returnAllValues();
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(double.parse(_currentLocationValues!.lat.toString()),
            double.parse(_currentLocationValues!.long.toString())),
        17));
    setState(() {});
  }

  _hamMenuAndTitle(double deviceWidth) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextButton(
            onPressed: () {
              scaffoldKey.currentState!.openDrawer();
            },
            child: Icon(
              Icons.menu_rounded,
              color: Color(0xFF414BB2),
              size: deviceWidth / 6.6,
            ),
          ),
        ),
        Expanded(
            flex: 10,
            child: Center(
              child: Text(
                "WashMe",
                style: GoogleFonts.fredokaOne(
                    fontSize: deviceWidth / 9, color: Color(0xFF2D9BF0)),
              ),
            )),
        Expanded(flex: 1, child: SizedBox())
      ],
    );
  }

  _introduction(double deviceHeight) {
    return Container(
        margin: EdgeInsets.only(top: 5),
        child: Column(
          children: [
            Text(
              "Our washers",
              style: GoogleFonts.fredokaOne(
                  fontSize: deviceHeight / 30, color: Color(0xFF414BB2)),
            ),
            Text(
              "are waiting for",
              style: GoogleFonts.fredokaOne(
                  fontSize: deviceHeight / 30, color: Color(0xFF414BB2)),
            ),
            Text(
              "your wash orders",
              style: GoogleFonts.fredokaOne(
                  fontSize: deviceHeight / 30, color: Color(0xFF414BB2)),
            ),
            Text(
              "with our",
              style: GoogleFonts.fredokaOne(
                  fontSize: deviceHeight / 30, color: Color(0xFF414BB2)),
            ),
            Text(
              "most competitive prices",
              style: GoogleFonts.fredokaOne(
                  fontSize: deviceHeight / 30, color: Color(0xFF414BB2)),
            ),
          ],
        ));
  }

  _loginRegister(double deviceHeight, double deviceWidth) {
    return Container(
      margin: EdgeInsets.only(top: deviceHeight / 50),
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.only(bottom: deviceHeight / 50),
              child: Text(
                "Log in to benefit from many privileges like discounts and free washes",
                style: GoogleFonts.notoSans(
                    fontSize: deviceWidth / 21,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/LoginPage");
              },
              child: Container(
                width: deviceWidth * 0.8,
                margin: EdgeInsets.only(
                  top: deviceHeight / 42,
                  bottom: deviceHeight / 42,
                ),
                child: Text(
                  "Log in",
                  style: GoogleFonts.notoSans(fontSize: deviceHeight / 35),
                  textAlign: TextAlign.center,
                ),
              )),
        ],
      ),
    );
  }

  Column _location(double deviceHeight, double deviceWidth) {
    CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(31.2, -99.6),
      zoom: 6,
    );
    return Column(
      children: [
        Text(
          "Set wash location on map or",
          style: GoogleFonts.notoSans(
              fontSize: deviceWidth / 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        TextButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return FutureBuilder(
                      future: enterOrSelectWashAddressDialog(
                          deviceHeight, deviceWidth),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return snapshot.data as Widget;
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      });
                });
          },
          child: Text(
            "Enter or Select wash Address",
            style: GoogleFonts.notoSans(
              fontSize: deviceWidth / 21,
              color: Color(0xFF414BB2),
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: deviceHeight * (2 / 5),
          width: double.infinity,
          child: GoogleMap(
            // Because the map is in SingleChildScrollView, it is not possible to drag the map.
            // By adding the line below, it becomes possible by setting google map unscrollable.
            gestureRecognizers: Set()
              ..add(Factory<EagerGestureRecognizer>(
                  () => EagerGestureRecognizer())),

            onCameraIdle: () async {
              if (_cameraPosition != null) {
                _currentLocationValues = await customerLocation.returnAllValues(
                    lat: _cameraPosition!.target.latitude,
                    long: _cameraPosition!.target.longitude);
                setState(() {
                  _currentLocationValues;
                });
              } else {
                return;
              }
            },
            onCameraMove: (cameraPosition) async {
              setState(() {
                _cameraPosition = cameraPosition;
                globalMarkers = {
                  Marker(
                      markerId: MarkerId("You"),
                      position: cameraPosition.target)
                };
              });
            },
            onMapCreated: (controller) {
              setState(() {
                _mapController = controller;
              });
            },
            markers: globalMarkers,
            myLocationEnabled: true,
            key: _mapKey,
            myLocationButtonEnabled: true,
            initialCameraPosition: initialCameraPosition,
          ),
        ),
        Text(
          "Your pinned address is",
          style: GoogleFonts.notoSans(
            fontSize: deviceWidth / 21,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Container(
          margin: EdgeInsets.only(top: deviceHeight / 160),
          child: Row(
            children: [
              Expanded(
                flex: 8,
                child: Container(
                  child: Column(
                    children: [
                      Text(
                        _currentLocationValues?.streetNumberAndName ??
                            "null" +
                                ", " +
                                (_currentLocationValues?.adminArea ?? "null ") +
                                ", ",
                        style: GoogleFonts.openSans(
                          fontSize: deviceWidth / 28,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        (_currentLocationValues?.state ?? "null") +
                            ", " +
                            (_currentLocationValues?.zip.toString() ?? "null"),
                        style: GoogleFonts.openSans(
                          fontSize: deviceWidth / 28,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(flex: 1, child: SizedBox()),
              Expanded(
                flex: 4,
                child: Container(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentLocationValues?.streetNumberAndName == null) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SimpleDialog(
                                children: [
                                  Container(
                                    child: Text(
                                      "Your location is empty.\n\nYou either did not allow location services or you are observing a bug.",
                                      style: GoogleFonts.openSans(
                                          fontSize: deviceWidth / 21,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              );
                            });
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return addressDialog(deviceHeight, deviceWidth);
                            });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          top: deviceHeight / 84,
                          bottom: deviceHeight / 84,
                          left: deviceWidth / 40,
                          right: deviceWidth / 40),
                      child: Text(
                        "Accept",
                        style: GoogleFonts.openSans(
                          fontSize: deviceWidth / 21,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _washTime(double deviceHeight, double deviceWidth) {
    String timePickerString = "";

    if (_orderValue.timeValue == null) {
      timePickerString = "Time Picker";
    } else if (_orderValue.timeValue!.hour > 12) {
      timePickerString =
          "${_orderValue.timeValue!.hour - 12}:${_orderValue.timeValue!.minute} P.M.";
    } else {
      timePickerString =
          "${_orderValue.timeValue!.hour}:${_orderValue.timeValue!.minute} A.M.";
    }

    return Column(
      children: [
        Text(
          "Select Wash Time",
          style: GoogleFonts.openSans(
            fontSize: deviceWidth / 21,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Row(
          children: [
            Expanded(
              flex: 5,
              child: TextButton(
                  onPressed: () {
                    var now = DateTime.now();
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: now,
                        maxTime: DateTime(now.year, now.month, now.day + 6),
                        onChanged: (date) {
                      setState(() {
                        _orderValue.dateValue = date;
                      });
                    }, onConfirm: (date) {
                      setState(() {
                        _orderValue.dateValue = date;
                      });
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Container(
                    width: deviceWidth * (3 / 8),
                    padding: EdgeInsets.symmetric(
                        horizontal: deviceWidth / 20,
                        vertical: deviceHeight / 100),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.all(
                            Radius.circular(deviceWidth / 30))),
                    child: Text(
                      _orderValue.dateValue == null
                          ? "Date Picker"
                          : _orderValue.dateValue!.month.toString() +
                              "/" +
                              _orderValue.dateValue!.day.toString() +
                              "/" +
                              _orderValue.dateValue!.year.toString(),
                      style: GoogleFonts.openSans(
                          fontSize: deviceWidth / 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  )),
            ),
            Expanded(
              flex: 5,
              child: TextButton(
                  onPressed: () {
                    showCustomTimePicker(
                        context: context,
                        // It is a must if you provide selectableTimePredicate
                        onFailValidation: (context) =>
                            print('Unavailable selection'),
                        initialTime: TimeOfDay(hour: 0, minute: 0),
                        selectableTimePredicate: (time) =>
                            time!.minute % 15 == 0).then((time) {
                      if (time != null) {
                        var now = DateTime.now();
                        _orderValue.timeValue = DateTime(now.year, now.month,
                            now.day, time.hour, time.minute);
                        setState(() {});
                      } else {
                        return;
                      }
                    });
                  },
                  child: Container(
                    width: deviceWidth * (3 / 8),
                    padding: EdgeInsets.symmetric(
                        horizontal: deviceWidth / 20,
                        vertical: deviceHeight / 100),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.all(
                            Radius.circular(deviceWidth / 30))),
                    child: Text(
                      timePickerString,
                      style: GoogleFonts.openSans(
                          fontSize: deviceWidth / 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  )),
            ),
          ],
        ),
      ],
    );
  }

  _carType(double deviceHeight, double deviceWidth) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Select your car type",
          style: GoogleFonts.openSans(
            fontSize: deviceWidth / 21,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Container(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Radio<String>(
                  value: "Sedan",
                  groupValue: _orderValue.carClass,
                  onChanged: (String? value) {
                    setState(() {
                      _orderValue.carClass = value;
                    });
                  },
                ),
              ),
              Expanded(
                flex: 4,
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        _orderValue.carClass = "Sedan";
                      });
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Small or medium size sedan",
                        style: GoogleFonts.openSans(
                          fontSize: deviceWidth / 21,
                          color: Colors.black,
                        ),
                      ),
                    )),
              )
            ],
          ),
        ),
        Container(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Radio<String>(
                  value: "SUV",
                  groupValue: _orderValue.carClass,
                  onChanged: (String? value) {
                    setState(() {
                      _orderValue.carClass = value;
                    });
                  },
                ),
              ),
              Expanded(
                  flex: 4,
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          _orderValue.carClass = "SUV";
                        });
                      },
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          "SUV or van",
                          style: GoogleFonts.openSans(
                            fontSize: deviceWidth / 21,
                            color: Colors.black,
                          ),
                        ),
                      )))
            ],
          ),
        ),
      ],
    );
  }

  _washType(double deviceHeight, double deviceWidth) {
    return Column(
      children: [
        Text(
          "Select wash type",
          style: GoogleFonts.openSans(
            fontSize: deviceWidth / 21,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(flex: 1, child: SizedBox()),
                  Expanded(
                    flex: 4,
                    child: Container(
                      child: Text(
                        "Exterior cleaning:",
                        style: GoogleFonts.openSans(
                          fontSize: deviceWidth / 21,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Radio<String>(
                        value: "Hand",
                        groupValue: _orderValue.exteriorWashType,
                        onChanged: (String? value) {
                          setState(() {
                            _orderValue.exteriorWashType = value;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _orderValue.exteriorWashType = "Hand";
                          });
                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            "With bucket and sponge",
                            style: GoogleFonts.openSans(
                              fontSize: deviceWidth / 21,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "\$25",
                          style: GoogleFonts.openSans(
                            fontSize: deviceWidth / 21,
                            color: Colors.black,
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Radio<String>(
                        value: "Machine",
                        groupValue: _orderValue.exteriorWashType,
                        onChanged: (String? value) {
                          setState(() {
                            _orderValue.exteriorWashType = value;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _orderValue.exteriorWashType = "Machine";
                          });
                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            "With waterjet or vapor",
                            style: GoogleFonts.openSans(
                              fontSize: deviceWidth / 21,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "\$25",
                          style: GoogleFonts.openSans(
                            fontSize: deviceWidth / 21,
                            color: Colors.black,
                          ),
                        )),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Checkbox(
                      side: MaterialStateBorderSide.resolveWith(
                        (states) => BorderSide(width: 2.0, color: Colors.grey),
                      ),
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.all(Color(0xFF2D9BF0)),
                      value: _orderValue.isInterior,
                      onChanged: (bool? value) {
                        setState(() {
                          _orderValue.isInterior = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _orderValue.isInterior =
                              _orderValue.isInterior == true ? false : true;
                        });
                      },
                      child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Interior",
                            style: GoogleFonts.openSans(
                              fontSize: deviceWidth / 21,
                              color: Colors.black,
                            ),
                          )),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text(
                        "\$10",
                        style: GoogleFonts.openSans(
                          fontSize: deviceWidth / 21,
                          color: Colors.black,
                        ),
                      )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Checkbox(
                      side: MaterialStateBorderSide.resolveWith(
                        (states) => BorderSide(width: 2.0, color: Colors.grey),
                      ),
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.all(Color(0xFF2D9BF0)),
                      value: _orderValue.isTruck,
                      onChanged: (bool? value) {
                        setState(() {
                          _orderValue.isTruck = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _orderValue.isTruck =
                              _orderValue.isTruck == true ? false : true;
                        });
                      },
                      child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Truck",
                            style: GoogleFonts.openSans(
                              fontSize: deviceWidth / 21,
                              color: Colors.black,
                            ),
                          )),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text(
                        "\$10",
                        style: GoogleFonts.openSans(
                          fontSize: deviceWidth / 21,
                          color: Colors.black,
                        ),
                      )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Checkbox(
                      side: MaterialStateBorderSide.resolveWith(
                        (states) => BorderSide(width: 2.0, color: Colors.grey),
                      ),
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.all(Color(0xFF2D9BF0)),
                      value: _orderValue.isEngine,
                      onChanged: (bool? value) {
                        setState(() {
                          _orderValue.isEngine = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _orderValue.isEngine =
                              _orderValue.isEngine == true ? false : true;
                        });
                      },
                      child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Engine",
                            style: GoogleFonts.openSans(
                              fontSize: deviceWidth / 21,
                              color: Colors.black,
                            ),
                          )),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text(
                        "\$10",
                        style: GoogleFonts.openSans(
                          fontSize: deviceWidth / 21,
                          color: Colors.black,
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  _findWasher(double deviceHeight, double deviceWidth) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: ElevatedButton(
          onPressed: () async {
            var locationsData = await LocationHelper.getLocationsData();

            if (selectedLocationId == null ||
                _orderValue.carClass == null ||
                _orderValue.exteriorWashType == null ||
                locationsData.isEmpty ||
                _orderValue.dateValue == null ||
                _orderValue.timeValue == null) {
             return showDialog(
                  context: context,
                  builder: (ctx) => SimpleDialog(
                    insetPadding: EdgeInsets.only(
                        left: deviceWidth / 20, right: deviceWidth / 20),
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            left: deviceWidth / 20, right: deviceWidth / 20),
                        child: Column(
                          children: [
                            Text(
                              "Your order is not complete.",
                              style: GoogleFonts.notoSans(fontSize: deviceWidth / 18),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: deviceHeight / 40,
                            ),
                            Text(
                              "Please select all necessary informations",
                              style: GoogleFonts.notoSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: deviceWidth / 18),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: deviceHeight / 60,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Address: ",
                                  style: GoogleFonts.notoSans(fontSize: deviceWidth / 18),
                                  textAlign: TextAlign.center,),
                                selectedLocationId == null ? Icon(Icons.do_not_disturb, color: Colors.red, size: deviceWidth/12,) : Icon(Icons.check, color: Colors.green, size: deviceWidth/12,),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Car Type: ",
                                  style: GoogleFonts.notoSans(fontSize: deviceWidth / 18),
                                  textAlign: TextAlign.center,),
                                _orderValue.carClass == null ? Icon(Icons.do_not_disturb, color: Colors.red, size: deviceWidth/12,) : Icon(Icons.check, color: Colors.green, size: deviceWidth/12,),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Exterior Wash Type: ",
                                  style: GoogleFonts.notoSans(fontSize: deviceWidth / 18),
                                  textAlign: TextAlign.center,),
                                _orderValue.exteriorWashType == null ? Icon(Icons.do_not_disturb, color: Colors.red, size: deviceWidth/12,) : Icon(Icons.check, color: Colors.green, size: deviceWidth/12,),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Day: ",
                                  style: GoogleFonts.notoSans(fontSize: deviceWidth / 18),
                                  textAlign: TextAlign.center,),
                                _orderValue.dateValue == null ? Icon(Icons.do_not_disturb, color: Colors.red, size: deviceWidth/12,) : Icon(Icons.check, color: Colors.green, size: deviceWidth/12,),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Time: ",
                                  style: GoogleFonts.notoSans(fontSize: deviceWidth / 18),
                                  textAlign: TextAlign.center,),
                                _orderValue.timeValue == null ? Icon(Icons.do_not_disturb, color: Colors.red, size: deviceWidth/12,) : Icon(Icons.check, color: Colors.green, size: deviceWidth/12,),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Saved Addresses: ",
                                  style: GoogleFonts.notoSans(fontSize: deviceWidth / 18),
                                  textAlign: TextAlign.center,),
                                locationsData.isEmpty ? Icon(Icons.do_not_disturb, color: Colors.red, size: deviceWidth/12,) : Icon(Icons.check, color: Colors.green, size: deviceWidth/12,),
                              ],
                            ),

                          ],
                        ),
                      )
                    ],
                  ));
            }

            DateTime now = DateTime.now();

            var orderDate = DateTime(
                _orderValue.dateValue!.year,
                _orderValue.dateValue!.month,
                _orderValue.dateValue!.day,
                _orderValue.timeValue!.hour,
                _orderValue.timeValue!.minute);

            if (now.millisecondsSinceEpoch > orderDate.millisecondsSinceEpoch) {
              return _showErrorDialogs(deviceHeight, deviceWidth,
                  firstLine:
                      "Please make sure the time you selected is in the future.");
            }

            LocationValues selectedLocation;
            for (int i = 0; i < locationsData.length; i++) {
              if (locationsData[i]["id"] == selectedLocationId) {
                selectedLocation = LocationValues.fromMap(locationsData[i]);
                User? user = FirebaseAuth.instance.currentUser;
                DocumentSnapshot<Map<String, dynamic>> ordersDataSnapshot =
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .collection("currentOrders")
                        .doc("washMe")
                        .get();
                if (ordersDataSnapshot.data() == null) {
                  await FirestoreWashMeOrderHelper.washMeOrderAdder(
                      _orderValue, selectedLocation);
                  return showDialog(
                      context: context,
                      builder: (ctx) => yourOrderHasBeenTakenDialog(
                          deviceHeight, deviceWidth));
                } else if (ordersDataSnapshot.data()!.keys.length >= 3) {
                  return _showErrorDialogs(deviceHeight, deviceWidth,
                      firstLine:
                          "You already have more than 3 orders. Please wait or cancel them to give more wash orders.");
                }
                List tempCityList = [];
                for (var element in ordersDataSnapshot.data()!.values) {
                  if (tempCityList.contains(element["adminArea"])) {
                    if (selectedLocation.adminArea == element["adminArea"]) {
                      return _showErrorDialogs(deviceHeight, deviceWidth,
                          firstLine:
                              "You already have 2 orders in this city. Other orders must be terminated first to give more orders.");
                    }
                  } else {
                    tempCityList.add(element["adminArea"]);
                  }
                }
                await FirestoreWashMeOrderHelper.washMeOrderAdder(
                    _orderValue, selectedLocation);
                return showDialog(
                    context: context,
                    builder: (ctx) =>
                        yourOrderHasBeenTakenDialog(deviceHeight, deviceWidth));
              }
            }
          },
          child: Container(
            margin: EdgeInsets.only(
                top: deviceHeight / 42,
                bottom: deviceHeight / 42,
                left: deviceWidth / 10,
                right: deviceWidth / 10),
            child: Text(
              "Continue to find the best washer",
              style: GoogleFonts.notoSans(fontSize: deviceWidth / 26.5),
              textAlign: TextAlign.center,
            ),
          )),
    );
  }

  drawerItems(double deviceHeight, double deviceWidth) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        SizedBox(
          height: deviceHeight / 20,
        ),
        Container(
          height: deviceHeight / 10,
          child: Text(
            "WashMe",
            textAlign: TextAlign.center,
            style: GoogleFonts.fredokaOne(
                fontSize: deviceWidth / 9, color: Color(0xFF2D9BF0)),
          ),
        ),
        ListTile(
          title: Text('Current Order'),
          visualDensity: VisualDensity(vertical: -3),
          onTap: () {
            showTransparentDialogOnLoad(context, deviceHeight, deviceWidth);

            BLCurrentOrdersOpener(deviceHeight, deviceWidth, context, mounted,
                replaced: false);
          },
        ),
        ListTile(
          title: Text('Previous Orders'),
          visualDensity: VisualDensity(vertical: -3),
          onTap: () async {

            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return notLoggedInDialog(deviceHeight, deviceWidth, context);
                });

          },
        ),
        const ListTile(
          title: Divider(color: Colors.grey, thickness: 1),
          visualDensity: VisualDensity(vertical: -3),
        ),
        ListTile(
          title: const Text('Personal Information'),
          visualDensity: VisualDensity(vertical: -3),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return notLoggedInDialog(deviceHeight, deviceWidth, context);
                });
          },
        ),
        ListTile(
          title: Text('Refer a Friend'),
          visualDensity: VisualDensity(vertical: -3),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ReferAFriend(deviceHeight, deviceWidth, context);
                });
          },
        ),
        ListTile(
          title: Text('WashMe Washer'),
          visualDensity: VisualDensity(vertical: -3),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return notLoggedInDialog(deviceHeight, deviceWidth, context,
                      displayText:
                          "You must login first to reach WashMe Washer Screen.");
                });
          },
        ),
        ListTile(
          title: Divider(color: Colors.grey, thickness: 1),
          visualDensity: VisualDensity(vertical: -3),
        ),
        ListTile(
          title: Text('About Us'),
          visualDensity: VisualDensity(vertical: -3),
          onTap: () {
            Navigator.of(context).pushNamed("/AboutUs");
          },
        ),
        ListTile(
          title: Text('Contact Us'),
          visualDensity: VisualDensity(vertical: -3),
          onTap: () {
            Navigator.of(context).pushNamed("/ContactUs");
          },
        ),
        ListTile(
          title: Text('Disclaimer'),
          visualDensity: VisualDensity(vertical: -3),
          onTap: () {
            Navigator.of(context).pushNamed("/Disclaimer");
          },
        ),
      ],
    );
  }

  Widget addressDialog(double deviceHeight, double deviceWidth) {
    return SimpleDialog(
      insetPadding: EdgeInsets.all(deviceWidth / 40),
      children: [
        Container(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  child: locationInfo(
                      deviceHeight, deviceWidth, _currentLocationValues)),
              SizedBox(
                height: deviceHeight / 30,
              ),
              Container(
                height: deviceHeight / 8,
                width: double.infinity,
                padding: EdgeInsets.all(deviceWidth / 40),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_currentLocationValues?.isNotNull()) {
                      int insertResult = await LocationHelper.insertLocation(
                          _currentLocationValues!.toMap());
                      if (insertResult != -1) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 3),
                            content: Text(
                              "Location is inserted with id : $insertResult",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: deviceWidth / 20),
                            ),
                          ),
                        );
                        FirestoreUserLocationsHelper.userLocationsAdder(
                            insertResult, _currentLocationValues!);
                        selectedLocationId = insertResult;
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 5),
                            content: Text(
                              "Location can not be saved. It is either already saved or the address is not sufficient.",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: deviceWidth / 20),
                            ),
                          ),
                        );
                      }
                      setState(() {});
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 5),
                          content: Text(
                            "There are missing address informations",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: deviceWidth / 20),
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Add This Address to Your Addresses",
                    style: GoogleFonts.notoSans(
                      fontSize: deviceWidth / 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget locationInfo(
    double deviceHeight,
    double deviceWidth,
    LocationValues? dialogLocationValues,
  ) {
    return Column(
      children: [
        SizedBox(
          height: deviceHeight / 40,
        ),
        Column(
          children: [
            Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                    left: deviceWidth / 30, right: deviceWidth / 20),
                child: Text(
                  "${dialogLocationValues?.streetNumberAndName}",
                  style: GoogleFonts.openSans(
                    fontSize: deviceWidth / 24,
                  ),
                )),
            Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                    left: deviceWidth / 30, right: deviceWidth / 20),
                child: Divider(thickness: 2, color: Colors.black)),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                  left: deviceWidth / 30, right: deviceWidth / 20),
              child: Text(
                "Street Number and Name",
                style: GoogleFonts.openSans(
                  fontSize: deviceWidth / 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: deviceHeight / 24,
        ),
        Container(
          width: double.infinity,
          padding:
              EdgeInsets.only(left: deviceWidth / 30, right: deviceWidth / 20),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Container(
                        width: double.infinity,
                        child: Text(
                          "${dialogLocationValues?.adminArea}",
                          style: GoogleFonts.openSans(
                            fontSize: deviceWidth / 24,
                          ),
                        )),
                    Divider(thickness: 2, color: Colors.black),
                    Container(
                      width: double.infinity,
                      child: Text(
                        "City",
                        style: GoogleFonts.openSans(
                          fontSize: deviceWidth / 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: deviceWidth / 32,
              ),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Container(
                        width: double.infinity,
                        child: Text(
                          "${dialogLocationValues?.state}",
                          style: GoogleFonts.openSans(
                            fontSize: deviceWidth / 24,
                          ),
                        )),
                    Divider(thickness: 2, color: Colors.black),
                    Container(
                      width: double.infinity,
                      child: Text(
                        "State",
                        style: GoogleFonts.openSans(
                          fontSize: deviceWidth / 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: deviceWidth / 32,
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Container(
                        width: double.infinity,
                        child: Text(
                          "${dialogLocationValues?.zip}",
                          style: GoogleFonts.openSans(
                            fontSize: deviceWidth / 24,
                          ),
                        )),
                    Divider(thickness: 2, color: Colors.black),
                    Container(
                      width: double.infinity,
                      child: Text(
                        "Zip",
                        style: GoogleFonts.openSans(
                          fontSize: deviceWidth / 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<Widget> enterOrSelectWashAddressDialog(
      double deviceHeight, double deviceWidth) async {
    OnLoginHelper.placingOnlineData();

    return SimpleDialog(
      insetPadding: EdgeInsets.all(deviceWidth / 40),
      children: [
        Container(
          height: deviceHeight * (3 / 4),
          width: deviceWidth * (11 / 12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        padding: EdgeInsets.only(left: deviceWidth / 30),
                        child: Text(
                          "Your Addresses",
                          style: GoogleFonts.notoSans(
                              fontSize: deviceWidth / 21,
                              fontWeight: FontWeight.bold),
                        )),
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: IconButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true)
                                .pop('dialog');
                          },
                          icon: Icon(Icons.close)),
                    ),
                  ],
                ),
                SizedBox(
                  height: deviceHeight / 40,
                ),
                SizedBox(
                  height: deviceHeight * (5 / 8),
                  child: FutureBuilder(
                      future: LocationHelper.getLocationsData(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Text('Loading....');
                          default:
                            if (snapshot.hasError)
                              return Text('Error');
                            else {
                              var dataList = snapshot.data as List;
                              if (dataList.length == 0) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: deviceHeight / 8,
                                    ),
                                    Text(
                                        "You do not have any addresses yet.\n\nPlease add an address via map!",
                                        style: GoogleFonts.notoSans(
                                            fontSize: deviceWidth / 24,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      height: deviceHeight / 16,
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Icon(
                                        Icons.map_outlined,
                                        size: deviceHeight / 8,
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return ListView.builder(
                                    itemCount: dataList.length,
                                    itemBuilder: (context, index) {
                                      var locationInstance = dataList[index];
                                      return Column(children: [
                                        locationInfo(
                                            deviceHeight,
                                            deviceWidth,
                                            LocationValues.fromMap(
                                                locationInstance)),
                                        SizedBox(
                                          height: deviceHeight / 40,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: deviceWidth / 30,
                                              right: deviceWidth / 20),
                                          height: deviceHeight / 12,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  flex: 4,
                                                  child: Container(
                                                      height: deviceHeight / 12,
                                                      width: double.infinity,
                                                      child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              primary: locationInstance[
                                                                          "id"] ==
                                                                      selectedLocationId
                                                                  ? Colors.blue
                                                                  : Color(
                                                                      0xFF414BB2)),
                                                          onPressed: () {
                                                            selectedLocationId =
                                                                locationInstance[
                                                                    "id"];
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                              locationInstance[
                                                                          "id"] ==
                                                                      selectedLocationId
                                                                  ? "Selected"
                                                                  : "Select",
                                                              style: GoogleFonts.notoSans(
                                                                  fontSize:
                                                                      deviceWidth /
                                                                          24))))),
                                              SizedBox(
                                                width: deviceWidth / 20,
                                              ),
                                              Expanded(
                                                  flex: 4,
                                                  child: Container(
                                                      height: deviceHeight / 12,
                                                      width: double.infinity,
                                                      child: ElevatedButton(
                                                          onPressed: () {
                                                            print("$index");
                                                          },
                                                          child: Text("Update",
                                                              style: GoogleFonts.notoSans(
                                                                  fontSize:
                                                                      deviceWidth /
                                                                          24))))),
                                              Expanded(
                                                flex: 4,
                                                child: Container(
                                                  height: deviceHeight / 8,
                                                  width: double.infinity,
                                                  padding: EdgeInsets.only(
                                                      left: deviceWidth / 30),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      LocationHelper.deleteLocations(
                                                          "id = ${locationInstance["id"]}");
                                                      FirestoreUserLocationsHelper
                                                          .userLocationsDeleter(
                                                              locationInstance[
                                                                  "id"]);
                                                      Navigator.pop(context);
                                                    },
                                                    child: Image.asset(
                                                      "lib/Assets/WashMe/bin.png",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: deviceHeight / 32,
                                        ),
                                      ]);
                                    });
                              }
                            }
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget yourOrderHasBeenTakenDialog(double deviceHeight, double deviceWidth) {
    return SimpleDialog(
      insetPadding:
          EdgeInsets.only(left: deviceWidth / 20, right: deviceWidth / 20),
      children: [
        Container(
          padding:
              EdgeInsets.only(left: deviceWidth / 20, right: deviceWidth / 20),
          child: Column(
            children: [
              Text(
                "Your order has been taken!",
                style: GoogleFonts.notoSans(fontSize: deviceWidth / 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: deviceHeight / 40,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    showTransparentDialogOnLoad(
                        context, deviceHeight, deviceWidth);

                    BLCurrentOrdersOpener(
                        deviceHeight, deviceWidth, context, mounted,
                        replaced: false);
                  },
                  child: Text(
                    "Go to Current Orders!",
                    style: GoogleFonts.notoSans(fontSize: deviceWidth / 26.5),
                    textAlign: TextAlign.center,
                  )),
            ],
          ),
        )
      ],
    );
  }

  _showErrorDialogs(double deviceHeight, double deviceWidth,
      {required String firstLine}) {
    return showDialog(
        context: context,
        builder: (ctx) => SimpleDialog(
              insetPadding: EdgeInsets.only(
                  left: deviceWidth / 20, right: deviceWidth / 20),
              children: [
                Container(
                  padding: EdgeInsets.only(
                      left: deviceWidth / 20, right: deviceWidth / 20),
                  child: Column(
                    children: [
                      Text(
                        "Your order is not complete.",
                        style: GoogleFonts.notoSans(fontSize: deviceWidth / 18),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: deviceHeight / 40,
                      ),
                      Text(
                        firstLine,
                        style: GoogleFonts.notoSans(
                            fontWeight: FontWeight.bold,
                            fontSize: deviceWidth / 18),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: deviceHeight / 60,
                      ),
                    ],
                  ),
                )
              ],
            ));
  }
}
