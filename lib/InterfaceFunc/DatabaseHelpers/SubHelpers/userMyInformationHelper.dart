
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;


class InformationHelper {

  static const _dbName = "userInformation.db";
  static const _version = 1;
  static const tableName = "user_information";


  static Future<sql.Database> createInformationsDatabase() async{
    final _dbPath =  await sql.getDatabasesPath();
    return sql.openDatabase(path.join(_dbPath, _dbName), onCreate: (db, version){
      return db.execute('''CREATE TABLE $tableName(
      id TEXT NOT NULL,
      fullName TEXT NOT NULL,
      surname TEXT NOT NULL,
      phoneNumber TEXT NOT NULL,
      email TEXT NOT NULL,
      birthDate TEXT NOT NULL,
       gender TEXT NOT NULL,
       photoFile TEXT NOT NULL)''');
    }, version: _version);
  }

  static onLoginCreator() async {
    final _dbPath =  await sql.getDatabasesPath();
    return sql.openDatabase(path.join(_dbPath, _dbName)).then((db) => {
        db.execute('''CREATE TABLE $tableName(
      id TEXT NOT NULL,
      fullName TEXT NOT NULL,
      surname TEXT NOT NULL,
      phoneNumber TEXT NOT NULL,
      email TEXT NOT NULL,
      birthDate TEXT NOT NULL,
       gender TEXT NOT NULL,
       photoFile TEXT NOT NULL)''')
    });
  }

  static insertInformation(Map<String, Object>  data)async {
    final db = await InformationHelper.createInformationsDatabase();

    // returns -1 if the address already exists. If address is created, returns id number.

    //  ******************************************
    List<Map<String, dynamic>> currentDataList = await InformationHelper.getInformationsData();
    for(int i = 0; i< currentDataList.length; i++){
      Map<String, dynamic> currentData = currentDataList[i];
      if(currentData["id"] == data["id"]){
        return db.update(tableName, data, where: 'id = ?', whereArgs: [data["id"]]);
      }
    }
    //  ******************************************
    return await db.insert(tableName, data, conflictAlgorithm: sql.ConflictAlgorithm.replace,);
  }


  static Future<List<Map<String, dynamic>>> getInformationsData() async {
    final db = await InformationHelper.createInformationsDatabase();
    return db.query(tableName);
  }

  static Future<Future<int>> DeleteInformation(String whereMethod) async{
    final db = await InformationHelper.createInformationsDatabase();
    print("Database is being deleted with method ==  $whereMethod");
    return db.delete(tableName, where: whereMethod);
  }


  /*
  static informationdbDestroyer() async {
    final db = await InformationHelper.createInformationsDatabase();
    db.execute("DROP TABLE IF EXISTS $tableName");
    print("**************");
  }
   */

}