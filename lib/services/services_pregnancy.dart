import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Pregnancy {
  final int? id;
  final String name;
  final String date; // YYYY-MM-DD

  Pregnancy({this.id, required this.name, required this.date});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'date': date};
  }

  factory Pregnancy.fromMap(Map<String, dynamic> map) {
    return Pregnancy(id: map['id'], name: map['name'], date: map['date']);
  }
}

class PregnancyService {
  static Future<void> createPregnancyTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS pregnancies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        date TEXT
      )
    ''');
  }

  static Future<int> insertPregnancy(Pregnancy pregnancy) async {
    final db = await _getDb();
    await createPregnancyTable(db);
    return await db.insert('pregnancies', pregnancy.toMap());
  }

  static Future<List<Pregnancy>> getAllPregnancies() async {
    final db = await _getDb();
    await createPregnancyTable(db);
    final List<Map<String, dynamic>> maps = await db.query('pregnancies');
    return List.generate(maps.length, (i) => Pregnancy.fromMap(maps[i]));
  }

  static Future<void> deletePregnancy(int? id) async {
    if (id == null) return;
    final db = await _getDb();
    await db.delete('pregnancies', where: 'id = ?', whereArgs: [id]);
  }

  static Future<Database> _getDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'bukupink.db');
    return openDatabase(path);
  }
}
