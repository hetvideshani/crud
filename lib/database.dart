import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MyDatabase {

  Future initDatabase() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasePath = join(appDocDir.path, 'apidb.db');
    return await openDatabase(databasePath);
  }

  Future<bool> copyPasteAssetFileToRoot() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "apidb.db");

    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      ByteData data =
      await rootBundle.load(join('assets/database', 'apidb.db'));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
      return true;
    }
    return false;
  }


  Future<List<Map<String, dynamic>>> getUserListFromUserTable() async {
    Database db = await initDatabase();
    List<Map<String, dynamic>> userList = await db.rawQuery('select UserID, Name, CityName from Tbl_User Inner Join Tbl_City on Tbl_User.CityID = Tbl_City.CityID');
    return userList;
  }


  Future<int>  insertDetailInTblUser(map) async {
    Database db = await initDatabase();
    int userId = await db.insert("Tbl_User", map);
    return userId;
  }

  Future<int> deleteUserByUserId(int UserID) async {
    Database db = await initDatabase();
    int userID= await db.delete('Tbl_User', where: 'UserID = ?', whereArgs: [UserID]);
    return userID;
  }

  Future<int> updateDetailInTblUserByUserId(Map<String,Object?> map,int UserID) async {
    Database db = await initDatabase();

    var res =await db.update("Tbl_User", map,where: "UserID = ?",whereArgs: [UserID]);
    return res;
  }

}
