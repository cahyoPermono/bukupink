import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class User {
  final int? id;
  final String username;
  final String password;

  User({this.id, required this.username, required this.password});

  Map<String, dynamic> toMap() {
    return {'id': id, 'username': username, 'password': password};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
    );
  }
}

class DatabaseService {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'bukupink.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            password TEXT
          )
        ''');
      },
    );
  }

  static Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  static Future<User?> getUser(String username, String password) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  static Future<User?> getUserByUsername(String username) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }
}

// Tambahkan model UserProfile
class UserProfile {
  final int? id;
  final String name;
  final int age;
  final double height;
  final double weight;

  UserProfile({
    this.id,
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'height': height,
      'weight': weight,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      height: map['height'],
      weight: map['weight'],
    );
  }
}

// Tambahkan service untuk user_profile
extension UserProfileService on DatabaseService {
  static Future<void> createProfileTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_profile (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        age INTEGER,
        height REAL,
        weight REAL
      )
    ''');
  }

  static Future<UserProfile?> getProfile() async {
    final dbClient = await DatabaseService.database;
    await createProfileTable(dbClient);
    final res = await dbClient.query('user_profile', limit: 1);
    if (res.isNotEmpty) {
      return UserProfile.fromMap(res.first);
    }
    return null;
  }

  static Future<int> insertProfile(UserProfile profile) async {
    final dbClient = await DatabaseService.database;
    await createProfileTable(dbClient);
    return await dbClient.insert('user_profile', profile.toMap());
  }

  static Future<int> updateProfile(UserProfile profile) async {
    final dbClient = await DatabaseService.database;
    await createProfileTable(dbClient);
    return await dbClient.update(
      'user_profile',
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }
}
