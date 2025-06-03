import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'bukupink.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE anak (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT,
            tanggal_lahir TEXT,
            jenis_kelamin TEXT
          );
        ''');
        await db.execute('''
          CREATE TABLE growth (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            anak_id INTEGER,
            tanggal TEXT,
            berat REAL,
            tinggi REAL,
            FOREIGN KEY(anak_id) REFERENCES anak(id) ON DELETE CASCADE
          );
        ''');
        await db.execute('''
          CREATE TABLE imunisasi (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            anak_id INTEGER,
            nama TEXT,
            tanggal TEXT,
            done INTEGER,
            FOREIGN KEY(anak_id) REFERENCES anak(id) ON DELETE CASCADE
          );
        ''');
      },
    );
  }
}
