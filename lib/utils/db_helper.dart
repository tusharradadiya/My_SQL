import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {

  static DbHelper dbHelper = DbHelper();

  Database? database;

  Future<Database?> cheackDb() async {
    if (database != null) {
      return database;
    } else {
      return await createDb();
    }
  }

  Future<Database> createDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'tushar.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        String query =
            "CREATE TABLE std(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,std TEXT,address TEXT)";
        db.execute(query);
      },
    );
  }

  Future<void> insertData({required String name, required String add, required String std}) async {
    database = await cheackDb();
    database!.insert("std", {"name": name, "std": std, "address": add});
  }

  Future<List<Map>> readData() async {
    database = await cheackDb();
    String query = "SELECT * FROM std";
    List<Map> datalist =await database!.rawQuery(query);
    return datalist;
  }

  Future<void> updateData({required int id,required String name,required String std,required String add}) async {
    database = await cheackDb();
    database!.update("std",{"name":name,"std":std,"address":add}, where: "id = ?",whereArgs: [id]);
  }

  Future<void> deleteData({required int id}) async {
    database = await cheackDb();
    database!.delete("std",where: "id = ?",whereArgs: [id]);
  }

}
