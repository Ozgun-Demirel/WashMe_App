
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;


class LocationHelper {

  static const _dbName = "locations.db";
  static const _version = 1;
  static const tableName = "user_locations";


  static Future<sql.Database> createLocationsDatabase() async{
    final _dbPath =  await sql.getDatabasesPath();
    return sql.openDatabase(path.join(_dbPath, _dbName), onCreate: (db, version){
      return db.execute('''CREATE TABLE $tableName(
      id INTEGER PRIMARY KEY AUTOINCREMENT,  
      lat TEXT NOT NULL, 
      long TEXT NOT NULL, 
      state TEXT NOT NULL, 
      adminArea TEXT NOT NULL,
       streetNumberAndName TEXT NOT NULL, 
       zip TEXT NOT NULL)''');
    }, version: _version);
  }

  static onLoginCreator() async {
    final _dbPath =  await sql.getDatabasesPath();
    return sql.openDatabase(path.join(_dbPath, _dbName)).then((db) => {
    db.execute('''CREATE TABLE $tableName(
      id INTEGER PRIMARY KEY AUTOINCREMENT,  
      lat TEXT NOT NULL,
      long TEXT NOT NULL,
      state TEXT NOT NULL,
      adminArea TEXT NOT NULL,
       streetNumberAndName TEXT NOT NULL,
       zip TEXT NOT NULL)''')
    });
  }

  static insertLocation(Map<String, dynamic>  data)async {
    // returns -1 if the address already exists. If address is created, returns id number.

    final db = await LocationHelper.createLocationsDatabase();
    var currentDataList = await LocationHelper.getLocationsData();
    if (currentDataList != null && currentDataList.length != 0){
      for(int i = 0; i< currentDataList.length; i++){
        Map<String, dynamic> currentData = currentDataList[i];
        if(currentData["state"] == data["state"] &&
            currentData["adminArea"] == data["adminArea"] &&
            currentData["streetNumberAndName"] == data["streetNumberAndName"] &&
            currentData["zip"] == data["zip"]){
          return -1;
        }
      }
    }
    //  ******************************************
     return await db.insert(tableName, data, conflictAlgorithm: sql.ConflictAlgorithm.replace,);
  }

  static insertLocationWithId(String id, Map data)async {
    final db = await LocationHelper.createLocationsDatabase();
    db.rawInsert("""INSERT INTO $tableName(
        id,
        lat,
        long,
        state,
        adminArea,
        streetNumberAndName,
        zip) VALUES(
        $id,
        ${data["lat"]},
        ${data["long"]},
        ${data["state"]},
        ${data["adminArea"]},
        ${data["streetNumberAndName"]},
        ${data["zip"]},
        )""");
  }

  static Future<List<Map<String, dynamic>>> getLocationsData() async {
    final db = await LocationHelper.createLocationsDatabase();
    return db.query(tableName);
  }

  static deleteLocations(String whereMethod) async{
    final db = await LocationHelper.createLocationsDatabase();
    print("Database is being deleted with method ==  $whereMethod");
    return db.delete(tableName, where: whereMethod);
  }

  static locationsdbDestroyer() async {
    final db = await LocationHelper.createLocationsDatabase();
    await db.execute("DROP TABLE IF EXISTS $tableName");
    return 1;
  }

  static databaseDestroyer() async {
    final _dbPath =  await sql.getDatabasesPath();
    await sql.databaseFactory.deleteDatabase(_dbPath);
  }


}