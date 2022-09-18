import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactUs extends StatelessWidget {
  static const routeName = "/ContactUs";
  const ContactUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;


    return Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            } // When not focused to Form TextFormFields',
            // keyboard will be lost automatically.
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: _deviceHeight/80, horizontal: _deviceWidth/30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: _deviceHeight/45,),
                  hamMenuAndTitle(_deviceWidth, context),
                  SizedBox(height: _deviceHeight/45,),
                  Container(width: double.infinity, child: Text("Contact Us", style: GoogleFonts.fredokaOne(fontWeight: FontWeight.bold, fontSize: _deviceWidth/21),),),
                  SizedBox(height: _deviceHeight/45,),
                  Image.asset(
                    "lib/Assets/WashMe/CommonScreens/operator.png",
                    height: _deviceHeight/6,
                  ),
                  SizedBox(height: _deviceHeight/60,),
                  infoTaker(_deviceHeight, _deviceWidth),
                  SizedBox(height: _deviceHeight/80,),
                  Container(width: double.infinity, child: Text("Your E-mail", style: GoogleFonts.openSans(fontSize: _deviceWidth/26, fontWeight: FontWeight.bold),),),
                  eMailTaker(_deviceHeight, _deviceWidth),
                  SizedBox(height: _deviceHeight/40,),
              ElevatedButton(onPressed: (){}, child: SizedBox( height: _deviceHeight/15, width: _deviceWidth/4 ,child: Center(child: Text("Send", style: GoogleFonts.openSans(fontSize: _deviceWidth/24),))),),
                 SizedBox(height: _deviceHeight/45,),
                  orDividerBuilder(_deviceWidth),
                  SizedBox(height: _deviceHeight/60,),
                  SizedBox(width: double.infinity, height: _deviceHeight/40,child: Center(child: Text("Contact us via", style: GoogleFonts.openSans(fontSize: _deviceWidth/32, fontWeight: FontWeight.bold),))
                  ),
                  SizedBox(height: _deviceHeight/45,),
                  linksBuilder(_deviceHeight, context),
                ],
              ),
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

  Widget infoTaker(double deviceHeight, double deviceWidth) {
    return TextField(
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLength: 1000,
      maxLines: 4,
      decoration: InputDecoration(
       border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 3), ),

      ),
    );
  }

  Widget eMailTaker(double deviceHeight, double deviceWidth) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 3), ),
        isDense: true,
        contentPadding: EdgeInsets.all(8),
      ),
    );
  }

  Widget orDividerBuilder(double deviceWidth) {
    return  Row(
      children: [
        Expanded(flex: 4, child: Divider(color: Colors.black, thickness: 2,)),
        Expanded(flex: 2, child: Center(child: Text("OR", style: GoogleFonts.openSans(fontSize: deviceWidth/26, fontWeight: FontWeight.bold),))),
        Expanded(flex: 4, child: Divider(color: Colors.black, thickness: 2,)),
      ],
    );
  }

  Widget linksBuilder(double deviceHeight, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset(
          "lib/Assets/WashMe/CommonScreens/whatsapp.png",
          height: deviceHeight / 12,
        ),
        Image.asset(
          "lib/Assets/WashMe/CommonScreens/phone.png",
          height: deviceHeight / 12,
        ),
      ],
    );
  }
}
