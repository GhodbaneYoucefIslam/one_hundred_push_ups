import 'package:one_hundred_push_ups/database/LocalDB.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService{
  Database? _db;

  Future<Database> get database async{
    if(_db !=null){return _db!;}
    _db= await _initialize();
    return  _db!;
  }

  Future<String> get fullPath async{
    const name = "goals.db";
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<void> dropDB() async{
    final String path = await fullPath;
    databaseFactory.deleteDatabase(path);
  }

  Future<Database> _initialize() async{
    final String path = await fullPath;
    Database db = await openDatabase(
      path,
      version: 1,
      singleInstance: true,
      onCreate: (Database db, int version) async => await LocalDB().createTables(db),
    );
    return db;
  }
}