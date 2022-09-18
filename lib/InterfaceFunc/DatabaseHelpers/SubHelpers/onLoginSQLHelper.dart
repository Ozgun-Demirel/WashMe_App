import 'package:WashMe/InterfaceFunc/DatabaseHelpers/SubHelpers/userLocationsHelper.dart';
import 'package:WashMe/InterfaceFunc/DatabaseHelpers/SubHelpers/userMyInformationHelper.dart';
import 'package:WashMe/InterfaceFunc/DatabaseHelpers/SubHelpers/userVehiclesHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart' as sql;

FirebaseAuth _auth = FirebaseAuth.instance;

class OnLoginHelper {

  static User? user = _auth.currentUser;

  static const locationsTableName = "user_locations";
  static const userInformationsTableName = "user_information";
  static const vehiclesTableName = "user_cars";

  static tableDestroyer() async {
    final locationsDb = await LocationHelper.createLocationsDatabase();
    await locationsDb.execute("DROP TABLE IF EXISTS $locationsTableName");
    final luserInformationsDb = await InformationHelper.createInformationsDatabase();
    await luserInformationsDb.execute("DROP TABLE IF EXISTS $userInformationsTableName");
    final vehiclesDb = await VehiclesSQLHelper.createVehiclesDatabase();
    await vehiclesDb.execute("DROP TABLE IF EXISTS $vehiclesTableName");
    print("**************");
  }

  static databaseDestroyer() async {
    final _dbPath =  await sql.getDatabasesPath();
    await sql.deleteDatabase(_dbPath);
  }

  static sqlCreator() async {
    await LocationHelper.onLoginCreator();
    await InformationHelper.onLoginCreator();
    await VehiclesSQLHelper.onLoginCreator();
  }

  static placingOnlineData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users')
        .doc(user!.uid)
        .collection("locations").get();
    try {
      for (int index= 0; index < querySnapshot.docs.length; index++) {
        LocationHelper.insertLocation(querySnapshot.docs[index].data() as Map<String, dynamic>);
      }
    } catch (err){
      print(err);
    }
  }

  static firebaseDataDeleter() async {
    if(user != null ){
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection("locations").get().then((value) => {
            for(DocumentSnapshot ds in value.docs){
          ds.reference.delete()
            }
      });
    }
  }

  static onLogin() async {
    await OnLoginHelper.tableDestroyer();
    await OnLoginHelper.sqlCreator();
    await OnLoginHelper.placingOnlineData();
    // await OnLoginHelper.placingOnlineData(); // empty for now
  }

}