import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ContinueWithoutRegistration extends StatefulWidget {
  static const routeName = "/ContinueWithoutRegistration";
  const ContinueWithoutRegistration({Key? key}) : super(key: key);

  @override
  State<ContinueWithoutRegistration> createState() =>
      _ContinueWithoutRegistrationState();
}

class _ContinueWithoutRegistrationState
    extends State<ContinueWithoutRegistration> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool filtered = false;
  LatLng selectedCustomerLatLong = LatLng(31.2, -99.6);

  @override
  Widget build(BuildContext context) {
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
          padding: EdgeInsets.only(
              top: _deviceWidth / 45,
              bottom: _deviceWidth / 45,
              left: _deviceWidth / 60,
              right: _deviceWidth / 60),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: _deviceHeight / 45,
                ),
                hamMenuAndTitle(_deviceWidth, context),
                welcomer(_deviceWidth),
                SizedBox(
                  height: _deviceHeight / 40,
                ),
                map(_deviceHeight, _deviceWidth),
                SizedBox(
                  height: _deviceHeight / 40,
                ),
                filter(_deviceWidth, context),
                ordersBuilder(_deviceHeight, _deviceWidth, context),
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
              color: Color(0xFF414BB2),
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
                  fontSize: deviceWidth / 12, color: Color(0xFF2D9BF0)),
            ),
          ),
        ),
        Expanded(flex: 1, child: SizedBox())
      ],
    );
  }

  Widget drawerBuilder(
      double deviceHeight, double deviceWidth, BuildContext context) {
    return Drawer(
      child: ListView(
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
            title: Text('Current Jobs'),
            visualDensity: VisualDensity(vertical: -3),
            onTap: () async {
              await showRegisterDialog(deviceWidth);
            },
          ),
          ListTile(
            title: Text('Previous Jobs'),
            visualDensity: VisualDensity(vertical: -3),
            onTap: () async {
              await showRegisterDialog(deviceWidth);
            },
          ),
          ListTile(
            title: Text('Earnings and Payments'),
            visualDensity: VisualDensity(vertical: -3),
            onTap: () async {
              await showRegisterDialog(deviceWidth);
            },
          ),
          ListTile(
            title: Divider(color: Colors.grey, thickness: 1),
            visualDensity: VisualDensity(vertical: -3),
          ),
          ListTile(
            title: Text('Washer Board'),
            visualDensity: VisualDensity(vertical: -3),
            onTap: () async {
              await showRegisterDialog(deviceWidth);
            },
          ),
          ListTile(
            title: Divider(color: Colors.grey, thickness: 1),
            visualDensity: VisualDensity(vertical: -3),
          ),
          ListTile(
            title: Text('Return to Become a Washer'),
            visualDensity: VisualDensity(vertical: -3),
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName("/BecomeWasher"));
            },
          ),
        ],
      ),
    );
  }

  Widget welcomer(double deviceWidth) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            "Hi Sergio,",
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSans(
                fontSize: deviceWidth / 16, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Text(
            "WashMe requests",
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSans(
                fontSize: deviceWidth / 16, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Text(
            "are waiting for you",
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSans(
                fontSize: deviceWidth / 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget map(double deviceHeight, double deviceWidth) {
    return Container(
      width: double.infinity,
      child: Center(
          child: FaIcon(
        FontAwesomeIcons.mapLocation,
        size: deviceHeight / 3,
      )),
    );
  }

  Widget filter(double deviceWidth, BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextButton(
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            onPressed: () {
              setState(() {
                filtered = !filtered;
              });
            },
            child: Text(
              filtered == true ? "Reset filters" : "Filter requests",
              style: GoogleFonts.notoSans(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
                fontSize: deviceWidth / 20,
                color: filtered == true ? Colors.deepOrangeAccent : Colors.blue,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget ordersBuilder(
      double deviceHeight, double deviceWidth, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,

          padding: EdgeInsets.zero,
          itemCount: 16,
          itemBuilder: (BuildContext context, int index) {

            return Column(
              children: [
                SizedBox(
                  height: deviceHeight / 80,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Radio<LatLng>(
                        value: LatLng(
                            double.parse("$index"), double.parse("$index")),
                        groupValue: selectedCustomerLatLong,
                        onChanged: (LatLng? value) {
                          setState(() {
                            selectedCustomerLatLong = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCustomerLatLong = LatLng(
                                double.parse("$index"), double.parse("$index"));
                          });
                        },
                        child: Column(
                          children: [
                            SizedBox(
                                width: double.infinity,
                                child: Text(
                                  index % 2 == 0 ? "Suv or Van" : "Sedan",
                                  style: GoogleFonts.notoSans(
                                      fontSize: deviceWidth / 20,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left,
                                )),
                            SizedBox(
                                width: double.infinity,
                                child: Text(
                                  index % 3 == 0
                                      ? "BucketAndSponge"
                                      : "Waterjet or vapor",
                                  style: GoogleFonts.notoSans(
                                    fontSize: deviceWidth / 20,
                                  ),
                                  textAlign: TextAlign.left,
                                ),),
                            SizedBox(
                                width: double.infinity,
                                child: Text(
                                  "Extras : " +
                                      (index % 3 == 0
                                          ? "No extra clean"
                                          : index % 2 == 0
                                              ? "Interior, Trunk"
                                              : "Interior, Engine"),
                                  style: GoogleFonts.notoSans(
                                    fontSize: deviceWidth / 20,
                                  ),
                                  textAlign: TextAlign.left,
                                )),
                            SizedBox(
                                width: double.infinity,
                                child: Text(
                                  index % 2 == 0
                                      ? "5004 Bangor Drive"
                                      : "1771 N Pierce Street",
                                  style: GoogleFonts.notoSans(
                                    fontSize: deviceWidth / 20,
                                  ),
                                  textAlign: TextAlign.left,
                                )),
                            SizedBox(
                                width: double.infinity,
                                child: Text(
                                  index % 3 == 0
                                      ? "Kensington MD 20895"
                                      : "Arlington VA 22209",
                                  style: GoogleFonts.notoSans(
                                    fontSize: deviceWidth / 20,
                                  ),
                                  textAlign: TextAlign.left,
                                )),
                            SizedBox(
                                width: double.infinity,
                                child: Text(
                                  index % 2 == 0
                                      ? "(1.3 miles)"
                                      : "(0.4 miles)",
                                  style: GoogleFonts.notoSans(
                                      fontSize: deviceWidth / 20,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left,
                                )),
                            SizedBox(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      index % 2 == 0
                                          ? "June 28 Tuesday 11:30am"
                                          : "June 30 Thursday 02:30am",
                                      style: GoogleFonts.notoSans(
                                          fontSize: deviceWidth / 20),
                                      textAlign: TextAlign.right,
                                    ),
                                    Text(
                                      "\$$index",
                                      style: GoogleFonts.notoSans(
                                          fontSize: deviceWidth / 20,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          await showRegisterDialog(deviceWidth);
                        },
                        child: Container(
                            width: deviceWidth * (3 / 10),
                            height: deviceHeight / 15,
                            child: Center(
                                child: Text("Accept",
                                    style: GoogleFonts.notoSans(
                                      fontSize: deviceWidth / 20,
                                    ),
                                    textAlign: TextAlign.center)))),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueGrey,
                        ),
                        onPressed: () async {
                          await showRegisterDialog(deviceWidth);
                        },
                        child: Container(
                            width: deviceWidth * (3 / 10),
                            height: deviceHeight / 15,
                            child: Center(
                                child: Text("Hide",
                                    style: GoogleFonts.notoSans(
                                      fontSize: deviceWidth / 20,
                                    ),
                                    textAlign: TextAlign.center)))),
                  ],
                ),
                SizedBox(
                  height: deviceHeight / 20,
                ),
              ],
            );
          }),
    );
  }

  Widget dragInformation(double deviceHeight, double deviceWidth) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FaIcon(FontAwesomeIcons.arrowUp),
              FaIcon(FontAwesomeIcons.arrowDown),
            ],
          ),
          Text("Drag Up-Down to see other opportunities",
              style: GoogleFonts.notoSans(
                  fontSize: deviceWidth / 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Future showRegisterDialog(double deviceWidth) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            insetPadding: EdgeInsets.all(deviceWidth / 40),
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(deviceWidth/40),
                child: Column(
                  children: [
                    Text(
                        "You need to register as a washer to interact with this page!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSans(
                          fontSize: deviceWidth / 16, fontWeight: FontWeight.bold),),
                    SizedBox(height: deviceWidth/16),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.popUntil(context, ModalRoute.withName("/BecomeWasher"));
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text("Return Back!",
                            style: GoogleFonts.notoSans(
                              fontSize: deviceWidth / 16,
                            ),
                            textAlign: TextAlign.left,),
                        ),),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
