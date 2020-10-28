import 'dart:io';
import 'package:brokfy_app/src/models/auth_api_response.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import './db_repository.dart';

class DBService {
  static Database _database;
  static final DBService db = DBService._();

  DBService._();
  Future<Database> get database async {
    if( _database != null ) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join( documentsDirectory.path, 'brokfy.db' );
    
    
    return await openDatabase(
      path,
      version: DBRepository.migrations.length + 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        DBRepository.initScript.forEach((script) async => await db.execute(script));  
        DBRepository.migrations.forEach((script) async => await db.execute(script));  
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        for (var i = oldVersion - 1; i <= newVersion - 2; i++) {
          try {
            await db.execute(DBRepository.migrations[i]);
          } catch (ex) {}
        }  
      }
    );
  }

  /* ====================================================================
    CRUD: Auth
  ======================================================================= */
  insertAuth(AuthApiResponse auth) async {
    final db = await database;
    await db.delete('Auth');
    final res = await db.insert('Auth', auth.toJson());
    return res;
  }

  replaceAllAuth(List<AuthApiResponse> auth) async {
    final db = await database;
    await db.delete('Auth');
    await Future.forEach(auth, (element) async => await db.insert('Auth', element.toJson()));
    return 1;
  }

  Future<int> updateAuth(AuthApiResponse auth) async {
    final db = await database;
    final res = await db.update('Auth', auth.toJson(), where: 'username = ?', whereArgs: [auth.username]);
    return res;
  }

  Future<int> deleteAuth(String username) async {
    final db = await database;
    final res = await db.delete('Auth', where: 'username = ?', whereArgs: [username]);
    return res;
  }

  Future<AuthApiResponse> getAuthFirst() async {
    final db = await database;
    final res = await db.query('Auth');
    return res.isNotEmpty ? AuthApiResponse.fromJson(res.first) : null;
  }

  Future<List<AuthApiResponse>> getAllAuth() async {
    final db = await database;
    final res = await db.query('Auth');
    List<AuthApiResponse> list = res.isNotEmpty ? res.map((item) => AuthApiResponse.fromJson(item)).toList() : [];
    return list;
  }

  Future<int> deleteAllAuth() async {
    final db = await database;
    final res = await db.delete('Auth');
    return res;
  }
}