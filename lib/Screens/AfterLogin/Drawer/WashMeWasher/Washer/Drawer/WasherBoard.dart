import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WasherBoard extends StatelessWidget {
  static const routeName = "/WasherBoard";
  const WasherBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;


    return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.all(_deviceWidth/45),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: _deviceHeight/45,),
                hamMenuAndTitle(_deviceWidth, context),
                SizedBox(
                  height: _deviceHeight / 30,
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                    "Washer Board",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: _deviceWidth / 21),
                  ),
                ),
                SizedBox(
                  height: _deviceHeight / 30,
                ),
                Image.asset(
                  "lib/Assets/WashMe/account.png",
                  height: _deviceWidth / 3,
                ),
                washerButtonsBuilder(_deviceHeight, _deviceWidth, context),
              ],
            ),
          ),
        )
    );
  }

  hamMenuAndTitle(double deviceHeight, BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: Container(
              height:  deviceHeight / 6.6,
              child: TextButton(
                child: Icon(
                  Icons.keyboard_backspace,
                  color: Color(0xFF2D9BF0),
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
                    fontSize: deviceHeight / 9, color: Color(0xFF2D9BF0)),
              ),
            )),
        Expanded(flex: 1, child: SizedBox())
      ],
    );
  }

  Widget washerButtonsBuilder(double deviceHeight, double deviceWidth, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: deviceWidth/10, right: deviceWidth/10, top: deviceWidth/20, bottom: deviceWidth/20),
      child: Column(
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF2D9BF0),
              ),
              child: SizedBox(
              height: deviceHeight / 12,
              width: deviceWidth * (5 / 8),
              child: Center(child: Text("My Wash Statistics",
                  style: TextStyle(fontSize: deviceWidth / 21)))), onPressed: (){
                null;
          }),
          SizedBox(height: deviceHeight/30,),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF2D9BF0),
              ),
              child: SizedBox(
              height: deviceHeight / 12,
              width: deviceWidth * (5 / 8),
              child: Center(child: Text("My Bank Account",
                  style: TextStyle(fontSize: deviceWidth / 21)))), onPressed: (){
              null;
          }),
          SizedBox(height: deviceHeight/30,),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF2D9BF0),
              ),
              child: SizedBox(
              height: deviceHeight / 12,
              width: deviceWidth * (5 / 8),
              child: Center(child: Text("My Wash Equipments",
                  style: TextStyle(fontSize: deviceWidth / 21)))), onPressed: (){
            null;
          }),
          SizedBox(height: deviceHeight/30,),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF2D9BF0),
              ),
              child: SizedBox(
              height: deviceHeight / 12,
              width: deviceWidth * (5 / 8),
              child: Center(child: Text("Delete My Washer Account",
                  style: TextStyle(fontSize: deviceWidth / 21)))), onPressed: (){
            Navigator.of(context).pushNamed("/DeleteMyWasherAccount");
          }),
        ],
      ),
    );
  }
}
