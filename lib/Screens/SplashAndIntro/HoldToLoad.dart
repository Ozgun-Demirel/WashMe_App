import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../InterfaceFunc/DatabaseHelpers/SubHelpers/onLoginSQLHelper.dart';

class HoldToLoad extends StatelessWidget {
  static const routeName = "/HoldToLoad";
  const HoldToLoad({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String _goToPage ;

    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    if (user != null && !user.isAnonymous ) {
      _goToPage = "/ALClientInputs";
    } else if (user != null && user.isAnonymous ){
      _goToPage = "/BLClientInputs";
    } else {
      _auth.signInAnonymously();
      _goToPage = "/BLClientInputs";
    }

    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      OnLoginHelper.onLogin();
    });
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      Navigator.of(context).pushReplacementNamed(_goToPage);
    });


    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      ),
    );
  }


}
