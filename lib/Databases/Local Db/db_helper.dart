import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class db_helper{

  db_helper._();

  static final db_helper get_Instance=db_helper._();

  //table name and its columns
  static final String TABLE_NAME= "Note";
  static final String TABLE_COLUMN_SNO= "s_no";
  static final String TABLE_COLUMN_TITLE= "title";
  static final String TABLE_COLUMN_DESC= "discription";


  Database? mydb;

  Future<Database> getdb() async{
    if(mydb!=null){
      return mydb!;
    }
    else{
      mydb= await opendb();
      return mydb!;
    }

  }
  Future<Database> opendb() async{

    Directory appdir= await getApplicationDocumentsDirectory();
    String dbpath=join(appdir.path , "NoteDB.db");

     return await openDatabase(dbpath , onCreate: (db , version) async {
      //create our tables
       await db.execute('''
  CREATE TABLE $TABLE_NAME (
    $TABLE_COLUMN_SNO INTEGER PRIMARY KEY AUTOINCREMENT, 
    $TABLE_COLUMN_TITLE TEXT,
    $TABLE_COLUMN_DESC TEXT
  )
''');

    } , version: 1);




  }
  //To Add Data in Database

  Future<bool> Insert_Note({required String mTitle , required String mDesc}) async {

    var db= await getdb();

    int rows_affected= await db.insert(TABLE_NAME,
        {TABLE_COLUMN_TITLE: mTitle,
          TABLE_COLUMN_DESC: mDesc
        },
    );

    if(rows_affected>0){
      print("Data Inserted Succesfully");
      return true;

    }
    else{
      print("Data Failed to Entered");
      return false;
    }


  }

  //To fetch Data From database
  Future<List<Map<String , dynamic>>> get_all_notes() async{
    var db = await getdb();

    List<Map<String , dynamic>> mdata = await db.query(TABLE_NAME);
    return mdata;

  }

  Future<bool> update({required String mtitle , required String mDesc , required int Sno}) async{

    var db= await getdb();
    int rows_affected = await db.update(
      TABLE_NAME,
      {
        TABLE_COLUMN_TITLE: mtitle,
        TABLE_COLUMN_DESC: mDesc
      },
      where: "$TABLE_COLUMN_SNO = ?",
      whereArgs: [Sno], // This must be a list
    );

    return rows_affected>0;


  }

  Future<bool> delete({required int Sno}) async{

    var db=await getdb();
    int rows_affected = await db.delete(
      TABLE_NAME,
      where: "$TABLE_COLUMN_SNO = ?",
      whereArgs: [Sno.toString()], // Convert to string for the query
    );

    return rows_affected>0;





  }

}