import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentMethods extends StatelessWidget {
  static const routeName = "/PaymentMethods";
  const PaymentMethods({Key? key}) : super(key: key);

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
                Container(
                  width: double.infinity,
                  child: Text(
                    "Payment Methods",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: _deviceWidth / 21),
                  ),
                ),
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
}
