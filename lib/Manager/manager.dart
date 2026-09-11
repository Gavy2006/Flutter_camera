import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class manager{

  Future<Database> getDatabase() async{

    final db = await  getDatabasesPath() ;
    final dpath = join(db , 'data.db') ;


    return await openDatabase(
      dpath,
      version: 2,

      onCreate: (db, version) async {
        await db.execute('''
      CREATE TABLE imageslist(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        path TEXT
      )
    ''');

        await db.execute('''
      CREATE TABLE video(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        path TEXT
      )
    ''');

        await db.execute('''
      CREATE TABLE policy(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        policyno TEXT
      )
    ''');

        await db.execute('''
      CREATE TABLE describe(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        describe TEXT
      )
    ''');
      },
    );
  }


  Future<void> insertimage(

      List<XFile> images
      ) async{

    final db = await getDatabase() ;

    final path =  images.map((images) => images.path).toList() ;

    await db.insert(
      'imageslist' ,
        {
          "path" : jsonEncode(path)
    }
    ) ;
  }

  Future<void> details(

       String name,
       String policyno

      ) async{

    final db = await getDatabase() ;

    await db.insert(
        'policy' ,
        {
          "name" : name ,
          "policyno" : policyno
        }
    ) ;
  }


  Future< List<Map<String , dynamic?>> > returndetails() async{

    final db = await getDatabase() ;

    final data  = await db.query('policy') ;

    return data ;
  }


  Future<void> describe(

      String describe,

      ) async{

    final db = await getDatabase() ;

    await db.insert(
        'describe' ,
        {
          "describe" : describe ,

        }
    ) ;
  }


  Future< List<Map<String , dynamic?>> > returndescribe() async{

    final db = await getDatabase() ;

    final data  = await db.query('describe') ;

    return data ;
  }




  Future<void> insertvideo(

      XFile video
      ) async{

    final db = await getDatabase() ;
    await db.insert(
        'video' ,
        {
          "path" : video.path
        }
    ) ;
  }


  Future<List<String>> returnimages() async {
    final db = await getDatabase();

    final data = await db.query('imageslist');

    final path = List<String>.from(
      jsonDecode(data.first['path'] as String),
    );

    return path;
  }

  Future<String> returnvideo() async{

    final db = await getDatabase() ;

    final data = await db.query('video') ;

    return  data.first['path'] as String ;
  }
}