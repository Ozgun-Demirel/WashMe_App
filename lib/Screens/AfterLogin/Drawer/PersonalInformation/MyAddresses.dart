import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../FirebaseHelper/FirestoreHelpers/UserHelpers/UserLocationsHelper.dart';
import '../../../../InterfaceFunc/DatabaseHelpers/SubHelpers/userLocationsHelper.dart';
import '../../../../InterfaceFunc/DatabaseHelpers/customerLocations.dart';
import '../../../../Models/Users/locationValuesType.dart';

class MyAddresses extends StatefulWidget {
  static const routeName = "/MyAddresses";
  const MyAddresses({Key? key}) : super(key: key);

  @override
  State<MyAddresses> createState() => _MyAddressesState();
}

class _MyAddressesState extends State<MyAddresses> {
  @override
  Widget build(BuildContext context) {
    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "My Addresses",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: _deviceWidth / 21),
                ),
                IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return addressAdderDialog(
                                context, _deviceHeight, _deviceWidth);
                          });
                    },
                    iconSize: _deviceWidth / 6),
              ],
            ),
            addressesBuilder(context, _deviceHeight, _deviceWidth),
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
                  Navigator.of(context).pop();
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

  Widget addressesBuilder(
      BuildContext context, double deviceHeight, double deviceWidth) {
    return SizedBox(
      height: deviceHeight * (5 / 6),
      child: FutureBuilder(
          future: LocationHelper.getLocationsData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Text('Loading....');
              default:
                if (snapshot.hasError) {
                  return const Text('Error');
                } else {
                  List dataList = snapshot.data as List;
                  if (dataList.isEmpty) {
                    return Column(
                      children: [
                        SizedBox(
                          height: deviceHeight / 8,
                        ),
                        Text(
                            "You do not have any addresses yet.\n\nPlease add an address via plus icon!",
                            style: GoogleFonts.notoSans(
                                fontSize: deviceWidth / 24,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: deviceHeight / 16,
                        ),
                        IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return addressAdderDialog(
                                        context, deviceHeight, deviceWidth);
                                  });
                            },
                            iconSize: deviceWidth / 6),
                      ],
                    );
                  } else {
                    return ListView.builder(
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          var locationInstance = dataList[index];
                          return Column(
                            children: [
                              ListTile(
                                leading: Text(
                                  "${index + 1}",
                                  style: GoogleFonts.fredokaOne(
                                      fontSize: deviceHeight / 20),
                                ),
                                title: Text(
                                    locationInstance["streetNumberAndName"]),
                                subtitle: Text(locationInstance["adminArea"] +
                                    " " +
                                    locationInstance["zip"]),
                                trailing: TextButton(
                                  child: Image.asset(
                                    "lib/Assets/WashMe/bin.png",
                                    height: (deviceHeight / 10),
                                  ),
                                  onPressed: () {
                                    LocationHelper.deleteLocations(
                                        "id = ${locationInstance["id"]}");
                                    FirestoreUserLocationsHelper.userLocationsDeleter(
                                        locationInstance["id"]);
                                    setState(() {});
                                  },
                                ),
                              ),
                              const Divider(thickness: 2, color: Colors.grey),
                            ],
                          );
                        });
                  }
                }
            }
          }),
    );
  }

  Widget addressAdderDialog(BuildContext context, deviceHeight, deviceWidth) {
    var customerLocation = CustomerLocation();
    return SimpleDialog(
      insetPadding: EdgeInsets.all(deviceWidth / 40),
      children: [
        FutureBuilder(
            future: customerLocation.returnAllValues(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  if (snapshot.hasError) {
                    return const Text('Error');
                  } else {
                    var data = snapshot.data as LocationValues;
                    return SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          SizedBox(
                              width: double.infinity,
                              child: locationInfo(
                                  deviceHeight, deviceWidth, data)),
                          SizedBox(
                            height: deviceHeight / 30,
                          ),
                          Container(
                            height: deviceHeight / 8,
                            width: double.infinity,
                            padding: EdgeInsets.all(deviceWidth / 40),
                            child: ElevatedButton(
                              onPressed: () async {
                                int insertResult =
                                    await LocationHelper.insertLocation({
                                  "lat": data.lat.toString(),
                                  "long": data.long.toString(),
                                  "state": data.state.toString(),
                                  "adminArea": data.adminArea.toString(),
                                  "streetNumberAndName":
                                      data.streetNumberAndName.toString(),
                                  "zip": data.zip.toString(),
                                });
                                if (insertResult >= 1) {
                                  setState(() {});
                                  FirestoreUserLocationsHelper.userLocationsAdder(
                                      insertResult, data);
                                }
                                if(!mounted) return;
                                Navigator.of(context).pop();
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
                    );
                  }
              }
            })
      ],
    );
  }

  locationInfo(
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
                child: const Divider(thickness: 2, color: Colors.black)),
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
                    SizedBox(
                        width: double.infinity,
                        child: Text(
                          "${dialogLocationValues?.adminArea}",
                          style: GoogleFonts.openSans(
                            fontSize: deviceWidth / 24,
                          ),
                        )),
                    const Divider(thickness: 2, color: Colors.black),
                    SizedBox(
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
                    SizedBox(
                        width: double.infinity,
                        child: Text(
                          "${dialogLocationValues?.state}",
                          style: GoogleFonts.openSans(
                            fontSize: deviceWidth / 24,
                          ),
                        )),
                    const Divider(thickness: 2, color: Colors.black),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "state",
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
                    SizedBox(
                        width: double.infinity,
                        child: Text(
                          "${dialogLocationValues?.zip}",
                          style: GoogleFonts.openSans(
                            fontSize: deviceWidth / 24,
                          ),
                        )),
                    const Divider(thickness: 2, color: Colors.black),
                    SizedBox(
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
}
