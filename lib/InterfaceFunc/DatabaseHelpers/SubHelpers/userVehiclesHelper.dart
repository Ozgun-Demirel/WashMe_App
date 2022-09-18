
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;


class VehiclesSQLHelper {

  static const _dbName = "vehicles.db";
  static const _version = 1;
  static const tableName = "user_cars";

  static Future<sql.Database> createVehiclesDatabase() async{
    final dbPath =  await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, _dbName), onCreate: (db, version){
      return db.execute('''CREATE TABLE $tableName(
      id INTEGER PRIMARY KEY AUTOINCREMENT,  
      licensePlateNumber TEXT NOT NULL, 
      brand TEXT NOT NULL, 
      model TEXT NOT NULL, 
      color TEXT NOT NULL,
       photoFile TEXT NOT NULL, 
       classType TEXT NOT NULL)''');
    }, version: _version);
  }

  static onLoginCreator() async {
    final _dbPath =  await sql.getDatabasesPath();
    return sql.openDatabase(path.join(_dbPath, _dbName)).then((db) => {
    db.execute('''CREATE TABLE $tableName(
      id INTEGER PRIMARY KEY AUTOINCREMENT,  
      licensePlateNumber TEXT NOT NULL, 
      brand TEXT NOT NULL, 
      model TEXT NOT NULL, 
      color TEXT NOT NULL,
       photoFile TEXT NOT NULL, 
       classType TEXT NOT NULL)''')
    });
  }

  static insertCar(Map<String, String>  data)async {
    final db = await VehiclesSQLHelper.createVehiclesDatabase();

    // returns -1 if the address already exists. If address is created, returns id number.

    //  ******************************************
    List<Map<String, dynamic>> currentDataList = await VehiclesSQLHelper.getCarsData();
    for(int i = 0; i< currentDataList.length; i++){
      Map<String, dynamic> currentData = currentDataList[i];
      if(currentData["licensePlateNumber"] == data["licensePlateNumber"] &&
          currentData["brand"] == data["brand"] &&
          currentData["model"] == data["model"] &&
          currentData["color"] == data["color"] &&
          currentData["photoFile"] == data["photoFile"] &&
          currentData["classType"] == data["classType"]){
        return -1;
      }
    }
    //  ******************************************
    return await db.insert(tableName, data, conflictAlgorithm: sql.ConflictAlgorithm.replace,);
  }

  static Future<List<Map<String, dynamic>>> getCarsData() async {
    final db = await VehiclesSQLHelper.createVehiclesDatabase();
    return db.query(tableName);
  }

  static deleteCar(String whereMethod) async{
    final db = await VehiclesSQLHelper.createVehiclesDatabase();
    print("Database is being deleted with method ==  $whereMethod");
    return db.delete(tableName, where: whereMethod);
  }

/*
  static vehiclesdbDestroyer() async {
    final db = await LocationHelper.createVehiclesDatabase();
    db.execute("DROP TABLE IF EXISTS $tableName");
    print("**************");
  }
   */

}