import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../FirebaseHelper/FirestoreHelpers/UserHelpers/UserVehiclesHelper.dart';
import '../../../../InterfaceFunc/DatabaseHelpers/SubHelpers/userVehiclesHelper.dart';
import '../../../../InterfaceFunc/ImageHelper/imagePicker.dart';
import '../../../../Models/Users/vehicleValuesType.dart';

class MyCars extends StatefulWidget {
  static const routeName = "/MyCars";

  const MyCars({Key? key}) : super(key: key);

  @override
  State<MyCars> createState() => _MyCarsState();
}

class _MyCarsState extends State<MyCars> {
  final _carInfoFormKey = GlobalKey<FormState>();

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
                Container(
                  child: Text(
                    "My Cars",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: _deviceWidth / 21),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return carAdderDialog(
                                context, _deviceHeight, _deviceWidth);
                          });
                    },
                    iconSize: _deviceWidth / 6),
              ],
            ),
            carsBuilder(context, _deviceHeight, _deviceWidth),
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
            child: Container(
              height: deviceHeight / 6.6,
              child: TextButton(
                child: Icon(
                  Icons.keyboard_backspace,
                  color: Color(0xFF2D9BF0),
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
                    fontSize: deviceHeight / 9, color: Color(0xFF2D9BF0)),
              ),
            )),
        Expanded(flex: 1, child: SizedBox())
      ],
    );
  }

  Widget carsBuilder(
      BuildContext context, double deviceHeight, double deviceWidth) {
    return Container(
      height: deviceHeight * (5 / 6),
      child: FutureBuilder(
          future: VehiclesSQLHelper.getCarsData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Text('Loading....');
              default:
                if (snapshot.hasError)
                  return Text('Error');
                else {
                  List dataList = snapshot.data as List;
                  if (dataList.length == 0) {
                    return Column(
                      children: [
                        SizedBox(
                          height: deviceHeight / 8,
                        ),
                        Text(
                            "You do not have any vehicles yet.\n\nPlease add a vehicle via plus icon!",
                            style: GoogleFonts.notoSans(
                                fontSize: deviceWidth / 24,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: deviceHeight / 16,
                        ),
                        IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return carAdderDialog(
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
                          var vehicleInstance = dataList[index];
                          return Column(
                            children: [
                              ListTile(
                                leading: Text(
                                  "${index + 1}",
                                  style: GoogleFonts.fredokaOne(
                                      fontSize: deviceHeight / 20),
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: Text(vehicleInstance[
                                                "licensePlateNumber"] +
                                            " " +
                                            vehicleInstance["brand"] +
                                            " " +
                                            vehicleInstance["model"]),
                                      ),
                                    ),
                                    Container(
                                        width: deviceWidth / 4,
                                        child: Image.file(File(
                                            vehicleInstance["photoFile"]))),
                                  ],
                                ),
                                subtitle: Text(vehicleInstance["color"] +
                                    " " +
                                    vehicleInstance["classType"]),
                                trailing: TextButton(
                                  child: Image.asset(
                                    "lib/Assets/WashMe/bin.png",
                                    height: (deviceHeight / 10),
                                  ),
                                  onPressed: () {
                                    VehiclesSQLHelper.deleteCar(
                                        "id = ${vehicleInstance["id"]}");
                                    FirestoreUserVehiclesHelper
                                        .userVehiclesDeleter(
                                            vehicleInstance["id"]);
                                    setState(() {});
                                  },
                                ),
                              ),
                              Divider(thickness: 2, color: Colors.grey),
                            ],
                          );
                        });
                  }
                }
            }
          }),
    );
  }

  Widget carAdderDialog(BuildContext context, deviceHeight, deviceWidth) {
    VehicleValues _vehicleValue = VehicleValues();
    return SimpleDialog(
      insetPadding: EdgeInsets.all(deviceWidth / 40),
      children: [
        SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(
                  left: deviceWidth / 40, right: deviceWidth / 40),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(deviceWidth/40),
                    child: carInfo(deviceHeight, deviceWidth, _vehicleValue),
                  ),
                  SizedBox(
                    height: deviceHeight / 40,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF2D9BF0),
                      ),
                      onPressed: () async {
                        _carInfoFormKey.currentState?.save();
                        if (_vehicleValue.licensePlateNumber != null &&
                            _vehicleValue.brand != null &&
                            _vehicleValue.model != null &&
                            _vehicleValue.color != null &&
                            _vehicleValue.classType != null &&
                            _vehicleValue.photoFile != null) {
                          int insertResult = await VehiclesSQLHelper.insertCar({
                            "licensePlateNumber":
                            _vehicleValue.licensePlateNumber.toString(),
                            "brand": _vehicleValue.brand.toString(),
                            "model": _vehicleValue.model.toString(),
                            "color": _vehicleValue.color.toString(),
                            "photoFile": _vehicleValue.photoFile.toString(),
                            "classType": _vehicleValue.classType.toString()
                          });
                          if (insertResult > 0) {
                            print(insertResult);
                            FirestoreUserVehiclesHelper.userVehiclesAdder(
                                insertResult, _vehicleValue);
                            setState(() {});
                            Navigator.pop(context);
                          } else {
                            print(insertResult);
                          }
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.all(deviceWidth / 30),
                        child: Text("Save This Car",
                            style: GoogleFonts.openSans(
                              fontSize: deviceWidth / 24,
                            )),
                      )),
                ],
              )),
        ),
      ],
    );
  }

  carInfo(
    double deviceHeight,
    double deviceWidth, VehicleValues vehicleValue,
  ) {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        width: deviceWidth * (11 / 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    child: Text(
                      "Add Your Car",
                      style: GoogleFonts.notoSans(
                          fontSize: deviceWidth / 21, fontWeight: FontWeight.bold),
                    )),
                Container(
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop('dialog');
                      },
                      icon: Icon(Icons.close)),
                ),
              ],
            ),
            Form(
              key: _carInfoFormKey,
              child: Column(
                children: [
                  Container(
                    child: Column(
                      children: [
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            fillColor: Colors.white,
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.blue, width: 4),
                            ),
                            filled: true,
                            hintText: 'XX XXX000',
                            labelText: 'License Plate Number',
                          ),
                          onSaved: (String? value) {
                            vehicleValue.licensePlateNumber = value.toString();
                          },
                        ),
                        Container(
                          width: double.infinity,
                          child: Text(
                            "License Plate Number",
                            style: GoogleFonts.openSans(
                                fontSize: deviceWidth / 24,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: deviceHeight / 100,
                  ),
                  Container(
                    child: Column(
                      children: [
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            fillColor: Colors.white,
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.blue, width: 4),
                            ),
                            filled: true,
                            hintText: 'Ford',
                            labelText: 'Brand',
                          ),
                          onSaved: (String? value) {
                            vehicleValue.brand = value.toString();
                          },
                        ),
                        Container(
                          width: double.infinity,
                          child: Text(
                            "Brand",
                            style: GoogleFonts.openSans(
                                fontSize: deviceWidth / 24,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: deviceHeight / 100,
                  ),
                  Container(
                    child: Column(
                      children: [
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            fillColor: Colors.white,
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.blue, width: 4),
                            ),
                            filled: true,
                            hintText: 'Escape',
                            labelText: 'Model',
                          ),
                          onSaved: (String? value) {
                            vehicleValue.model = value.toString();
                          },
                        ),
                        Container(
                          width: double.infinity,
                          child: Text(
                            "Model",
                            style: GoogleFonts.openSans(
                                fontSize: deviceWidth / 24,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: deviceHeight / 100,
                  ),
                  Container(
                    child: Column(
                      children: [
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            fillColor: Colors.white,
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.blue, width: 4),
                            ),
                            filled: true,
                            hintText: 'Navy Blue',
                            labelText: 'Color',
                          ),
                          onSaved: (String? value) {
                            vehicleValue.color = value.toString();
                          },
                        ),
                        Container(
                          width: double.infinity,
                          child: Text(
                            "Color",
                            style: GoogleFonts.openSans(
                                fontSize: deviceWidth / 24,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: deviceHeight / 100,
                  ),
                  Container(
                    child: Column(
                      children: [
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            fillColor: Colors.white,
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.blue, width: 4),
                            ),
                            filled: true,
                            hintText: 'Small, Medium, Sedan, Van, SUV,',
                            labelText: 'Class Type',
                          ),
                          onSaved: (String? value) {
                            vehicleValue.classType = value.toString();
                          },
                        ),
                        Container(
                          width: double.infinity,
                          child: Text(
                            "Class Type",
                            style: GoogleFonts.openSans(
                                fontSize: deviceWidth / 24,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: deviceHeight / 100,
                  ),
                  Container(
                    padding: EdgeInsets.all(deviceWidth/60),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 2),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Add an Image of Your Car:",
                          style: GoogleFonts.openSans(
                              fontSize: deviceWidth / 24,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: deviceHeight / 60,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                File? fileName = await ImagePickerHelper.takePicture();
                                if (fileName == null) return;
                                vehicleValue.photoFile = fileName.path;
                                setState((){});
                              },
                              child: Container(
                                  margin: EdgeInsets.all(deviceWidth / 40),
                                  child: Text(
                                    "Open Camera",
                                    style: GoogleFonts.openSans(
                                        fontSize: deviceWidth / 24),
                                  )),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                File? fileName = await ImagePickerHelper.selectPicture();
                                if (fileName == null) return;
                                vehicleValue.photoFile = fileName.path;
                                setState((){});
                              },
                              child: Container(
                                  margin: EdgeInsets.all(deviceWidth / 40),
                                  child: Text(
                                    "Open Photos",
                                    style: GoogleFonts.openSans(
                                        fontSize: deviceWidth / 24),
                                  )),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(deviceWidth/40),
                          child: vehicleValue.photoFile != null ? Image.file(File(vehicleValue.photoFile as String)) : Container(
                              padding: EdgeInsets.all(deviceWidth/60),
                              child: Text("You need to take a picture of your car", style: GoogleFonts.fredokaOne(fontWeight: FontWeight.bold, fontSize: deviceWidth/24),)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }



}
