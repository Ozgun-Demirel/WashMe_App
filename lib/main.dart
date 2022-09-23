
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'InterfaceFunc/MaterialColorCreator.dart';
import 'Screens/AfterLogin/ClientOperations/ClientInputs.dart';
import 'Screens/AfterLogin/Drawer/ALCurrentOrder.dart';
import 'Screens/AfterLogin/Drawer/ALPersonalInformation.dart';
import 'Screens/AfterLogin/Drawer/ALPreviousOrders.dart';
import 'Screens/AfterLogin/Drawer/ALWashMeWasher.dart';
import 'Screens/AfterLogin/Drawer/PersonalInformation/MyAddresses.dart';
import 'Screens/AfterLogin/Drawer/PersonalInformation/MyCars.dart';
import 'Screens/AfterLogin/Drawer/PersonalInformation/MyInformation.dart';
import 'Screens/AfterLogin/Drawer/PersonalInformation/PaymentMethods.dart';
import 'Screens/AfterLogin/Drawer/WashMeWasher/NotWasher/BecomeWasher.dart';
import 'Screens/AfterLogin/Drawer/WashMeWasher/NotWasher/ContinueWithoutRegistration.dart';
import 'Screens/AfterLogin/Drawer/WashMeWasher/NotWasher/WasherRegistration.dart';
import 'Screens/AfterLogin/Drawer/WashMeWasher/NotWasher/WasherRegistrationID.dart';
import 'Screens/AfterLogin/Drawer/WashMeWasher/NotWasher/WasherRegistrationNameAndAddress.dart';
import 'Screens/AfterLogin/Drawer/WashMeWasher/NotWasher/WasherRegistrationPhotos.dart';
import 'Screens/AfterLogin/Drawer/WashMeWasher/NotWasher/WasherRegistrationSecurityCheck.dart';
import 'Screens/AfterLogin/Drawer/WashMeWasher/Washer/Drawer/CurrentJobs.dart';
import 'Screens/AfterLogin/Drawer/WashMeWasher/Washer/Drawer/EarningsAndPayments.dart';
import 'Screens/AfterLogin/Drawer/WashMeWasher/Washer/Drawer/PreviousJobs.dart';
import 'Screens/AfterLogin/Drawer/WashMeWasher/Washer/Drawer/WasherBoard.dart';
import 'Screens/AfterLogin/Drawer/WashMeWasher/Washer/Drawer/WasherBoard/DeleteMyWasherAccount.dart';
import 'Screens/AfterLogin/Drawer/WashMeWasher/Washer/Drawer/WasherBoard/MyBankAccounts.dart';
import 'Screens/AfterLogin/Drawer/WashMeWasher/Washer/Drawer/WasherBoard/MyWashEquipments.dart';
import 'Screens/AfterLogin/Drawer/WashMeWasher/Washer/Drawer/WasherBoard/MyWashStatistics.dart';
import 'Screens/AfterLogin/Drawer/WashMeWasher/Washer/WasherRequests.dart';
import 'Screens/BeforeLogin/ClientOperations/ClientInputs.dart';
import 'Screens/BeforeLogin/Drawer/BLCurrentOrders.dart';
import 'Screens/BeforeLogin/LoginPage.dart';
import 'Screens/BeforeLogin/Register.dart';
import 'Screens/CommonScreens/AboutUs.dart';
import 'Screens/CommonScreens/ContactUs.dart';
import 'Screens/CommonScreens/Disclaimer.dart';
import 'Screens/SplashAndIntro/HoldToLoad.dart';
import 'Screens/SplashAndIntro/Intro.dart';
import 'Screens/SplashAndIntro/Splash.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? showIntro = prefs.getBool("showIntro");

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  
  runApp(RoadEO_3(showIntro: showIntro,));
}

class RoadEO_3 extends StatelessWidget {
  const RoadEO_3({Key? key, bool? this.showIntro}) : super(key: key);
  final showIntro;

  @override
  Widget build(BuildContext context) {

    bool _showIntro = showIntro ?? true;


    return MaterialApp(
      // restorationScopeId: 'root', // image_picker problem with gallery
      debugShowCheckedModeBanner:
          false, // There will be a red "Debug" banner on the right corner of the app if this bool is not used!
      title: 'WashMe',
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.white),
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: createMaterialColor(const Color(0xFF414BB2))),
        // backgroundColor: Colors.white,
      ),


      home: _showIntro ? Intro() : Splash(showIntro: _showIntro,),

      routes: {
        // Splash And Intro:
        Splash.routeName : (context) => Splash(),
        Intro.routeName : (context) => Intro(),

        // Common Screens:
        HoldToLoad.routeName : (context) => HoldToLoad(),
        Disclaimer.routeName : (context) => Disclaimer(),
        ContactUs.routeName : (context) => ContactUs(),
        AboutUs.routeName : (context) => AboutUs(),
        //
        // After Login Routes:
        ALClientInputs.routeName : (context) => ALClientInputs(),
        // AL Drawer:
        ALWashMeWasher.routeName : (context) => ALWashMeWasher(),
        ALCurrentOrder.routeName : (context) => ALCurrentOrder(),
        ALPersonalInformation.routeName : (context) => ALPersonalInformation(),
        ALPreviousOrders.routeName : (context) => ALPreviousOrders(),
        // AL Personal Information Sub Pages:
        MyAddresses.routeName : (context) => MyAddresses(),
        MyCars.routeName : (context) => MyCars(),
        MyInformation.routeName : (context) => MyInformation(),
        PaymentMethods.routeName : (context) => PaymentMethods(),
        // AL WashMeWasher Not Washer Sub Pages:
        BecomeWasher.routeName : (context) => BecomeWasher(),
        WasherRegistration.routeName : (context) => WasherRegistration(),
        WasherRegistrationID.routeName : (context) => WasherRegistrationID(),
        WasherRegistrationNameAndAddress.routeName : (context) => WasherRegistrationNameAndAddress(),
        WasherRegistrationPhotos.routeName : (context) => WasherRegistrationPhotos(),
        WasherRegistrationSecurityCheck.routeName : (context) => WasherRegistrationSecurityCheck(),
        ContinueWithoutRegistration.routeName : (context) => ContinueWithoutRegistration(),
        // AL WashMeWasher Washer Sub Pages:
        WasherRequests.routeName : (context) => WasherRequests(),
        // AL WashMeWasher Washer Drawer:
        WasherBoard.routeName : (context) => WasherBoard(),
        EarningsAndPayments.routeName : (context) => EarningsAndPayments(),
        PreviousJobs.routeName : (context) => PreviousJobs(),
        CurrentJobs.routeName : (context) => CurrentJobs(),
        //AL WashMeWasher WasherBoard Sub Pages:
        MyWashStatistics.routeName : (context) => MyWashStatistics(),
        MyBankAccount.routeName : (context) => MyBankAccount(),
        MyWashEquipments.routeName : (context) => MyWashEquipments(),
        DeleteMyWasherAccount.routeName : (context) => DeleteMyWasherAccount(),
        //
        // Before Login Routes:
        BLClientInputs.routeName : (context) => BLClientInputs(),
        RegisterPage.routeName : (context) => RegisterPage(),
        LoginPage.routeName : (context) => LoginPage(),
        // BL Drawer: no need yet.
        BLCurrentOrders.routeName : (context) => BLCurrentOrders(),

      },
    );
  }


}
