import 'package:path/path.dart';
import 'package:qr_app/model/result.dart';
import 'package:sqflite/sqflite.dart';

class ScansDatabase {
  static final ScansDatabase instance = ScansDatabase._init();

  static Database? _database;

  ScansDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('scans.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

//create database method
  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableScans ( 
  ${ScanFields.id} $idType,   
  ${ScanFields.result} $textType,  
  ${ScanFields.time} $textType
  )
''');
  }

// inserting to db

  Future<Scan> create(Scan scan) async {
    final db = await instance.database;
    final id = await db.insert(tableScans, scan.toJson());
    return scan.copy(id: id);
  }

  //Get  result with id

  Future<Scan> readScan(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableScans,
      columns: ScanFields.values,
      where: '${ScanFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Scan.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

//Get all result

  Future<List<Scan>> readAllScans() async {
    final db = await instance.database;

    final orderBy = '${ScanFields.time} ASC';

    final result = await db.query(tableScans, orderBy: orderBy);

    return result.map((json) => Scan.fromJson(json)).toList();
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
