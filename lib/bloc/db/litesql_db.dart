import 'dart:convert';

import 'package:sqflite/sqflite.dart';

class DatabaseManager{

  static const String DB_NAME = 'main.db';
  static const String TABLE_RATINGS = 'ratings';
  static const String TABLE_USERS = 'users';
  static const String TABLE_MESSAGES = 'messages';
  static const String TABLE_CHANNELS = 'channels';
  static const String TABLE_NOTS = 'notifications';

  late Database db;
  DatabaseManager(){

  }

  bool isOpen=false;

  init() async{

    db = await openDatabase(DB_NAME,version:1,onCreate: (Database db, int version) async {
      db.transaction((txn) async{
        await txn.execute('CREATE TABLE $TABLE_RATINGS (i INTEGER PRIMARY KEY, id INTEGER, user TEXT, rating DOUBLE, time INTEGER)');
        await txn.execute('CREATE TABLE $TABLE_CHANNELS (i INTEGER PRIMARY KEY, id INTEGER, name TEXT, desc TEXT, owner TEXT, isBlocked INTEGER, subscribed INTEGER, blocked INTEGER)');
        await txn.execute('CREATE TABLE $TABLE_USERS (i INTEGER PRIMARY KEY, id INTEGER, lastContact INTEGER, rating TEXT, name TEXT, fname TEXT, about TEXT, isBlocked INTEGER, deviceId TEXT)');
        await txn.execute('CREATE TABLE $TABLE_NOTS (i INTEGER PRIMARY KEY, id INTEGER, content TEXT, title TEXT, payload TEXT, time INTEGER)');
        await txn.execute('CREATE TABLE $TABLE_MESSAGES (i INTEGER PRIMARY KEY, id INTEGER, reqId TEXT, sender TEXT, receivers TEXT, type INTEGER, time INTEGER, content TEXT, payload TEXT)');
      });
    });
    isOpen =true;
    print("LiteSQL DB initialised");
  }

  close()async{
    await db.close();
    isOpen = false;
  }

  Future<bool> addData(String table, dynamic data)async{
    String additionalCols = "";
    String additionalVals = "";
    if(table == TABLE_USERS){
      additionalCols = ", lastContact";
      additionalVals = ", ${DateTime.now().millisecondsSinceEpoch}";
    }
    await db.transaction((txn) async{
      int? count = Sqflite
          .firstIntValue(await txn.rawQuery("SELECT COUNT(id) FROM $table WHERE id = ${data.id}" ));
      bool exist= count !=null?count >0:false;

      if(! exist) {
        String columns = data.toMap(toDb:true).keys.toList().join(", ") + additionalCols;
        int length = data.toMap(toDb:true).keys.length;
        String valuesComma = List.generate(
            length, (index) => index < length - 1 ? '?' : '?')
            .join(", ") + additionalVals;
        int id2 = await txn.rawInsert(
            'INSERT INTO $table($columns) VALUES($valuesComma)',
            data.toMap(toDb:true).values.toList());
        print('inserted: $id2');
        return true;
      }else{
        return await updateItem(table, data);
      }
    });
    return true;
  }

  updateItem(String table, dynamic data)async{
    print("Updating item");
    List<String> dataKeys= data.toMap(toDb:true).keys.toList();
    String updateFields=List.generate(dataKeys.length, (index){
      return dataKeys[index]+" = ?";
    }).join(", ");

    String payload="";
    if(table == TABLE_USERS){
      payload = ", lastContact = "+DateTime.now().millisecondsSinceEpoch.toString();
    }

    db.transaction((txn)async {
      txn.rawUpdate('UPDATE $table SET $updateFields $payload WHERE id = ?', [...data.toMap(toDb:true).values,data.id]).then((value){
        print('updated: $value');
      });
    });

  }

  Future<Map<String, dynamic>?> queryItem(String table, {String where="1 = 1"})async{
    return await db.transaction((txn) async{
      List<Map<String, dynamic>> list = await txn.rawQuery("SELECT * FROM $table WHERE $where");
      return list.isEmpty?null:list.first;
    });
  }

  Future<bool> itemExists(String table, String where)async{
    return await db.transaction((txn) async{
      int? count = Sqflite
          .firstIntValue(await txn.rawQuery("SELECT COUNT(id) FROM $table WHERE $where"));
      return count !=null?count >0:false;
    });

  }

  Future<int> unSeenNotifications()async{
    int? count;
    try {
      count = await db.transaction((txn) async {
        return Sqflite
            .firstIntValue(await txn.rawQuery(
            "SELECT COUNT(id) FROM $TABLE_NOTS"));
      });
    }catch(e){

    }
    return count==null?0:count;
  }

  Future<int> count({required String table, String args=""})async{
    int? count;
    try {
      count = await db.transaction((txn) async {
        return Sqflite
            .firstIntValue(await txn.rawQuery(
            "SELECT COUNT(ID) FROM $table WHERE $args"));
      });
    }catch(e){

    }
    return count==null?0:count;
  }

  Future <bool> deleteItem(String table, String id)async{
    await db.transaction((txn)async{
      int? count = await txn
          .rawDelete("DELETE FROM $table WHERE id = $id");
      return count !=null?count >0:false;
    });
    return false;
  }

  Future <bool> deleteItemsWhere(String table, {String where="1 = 1"})async{
    await db.transaction((txn)async{
      int? count = await txn
          .rawDelete("DELETE FROM $table WHERE $where");
      return count !=null?count >0:false;
    });
    return false;
  }

  Future<List<Map<String, dynamic>>> queryItems(String table, {int limit=10, String where="1=1", String order="i DESC"}) async{
    String sql = "SELECT * FROM $table WHERE $where ORDER BY $order LIMIT $limit";
    List<Map<String,dynamic>> data =await db.transaction((txn) async{
    List<Map<String, dynamic>> list = await txn.rawQuery(sql);
    print("Loaded ${list.length} rows");
    return list;
    });
    return data;
  }

}