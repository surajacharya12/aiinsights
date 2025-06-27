import '../JSON/users.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  final String databaseName = "auth.db";

  final String userTable = '''
    CREATE TABLE IF NOT EXISTS users (
      usrId INTEGER PRIMARY KEY AUTOINCREMENT,
      fullName TEXT,
      email TEXT UNIQUE,
      usrPassword TEXT,
      photo TEXT
    )
  ''';

  final String courseTable = '''
    CREATE TABLE IF NOT EXISTS courses (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      cid TEXT UNIQUE,
      name TEXT,
      description TEXT,
      noOfChapters INTEGER,
      includeVideo INTEGER,
      level TEXT,
      category TEXT,
      courseJson TEXT,
      userEmail TEXT,
      bannerImageURL TEXT,
      courseContent TEXT,
      FOREIGN KEY(userEmail) REFERENCES users(email)
    )
  ''';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute(userTable);
        await db.execute(courseTable);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        print('DB upgrade from $oldVersion to $newVersion');
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE users ADD COLUMN photo TEXT;');
          await db.execute(courseTable);
        }
      },
    );
  }

  // User CRUD
  Future<int> createUser(Users usr) async {
    final db = await database;
    return db.insert("users", usr.toMap());
  }

  Future<bool> authenticate(Users usr) async {
    final db = await database;
    final res = await db.query(
      "users",
      where: "email = ? AND usrPassword = ?",
      whereArgs: [usr.email?.trim().toLowerCase(), usr.password.trim()],
    );
    return res.isNotEmpty;
  }

  Future<Users?> getUser(String email) async {
    final db = await database;
    final res = await db.query(
      "users",
      where: "email = ?",
      whereArgs: [email.trim().toLowerCase()],
    );
    return res.isNotEmpty ? Users.fromMap(res.first) : null;
  }

  Future<int> updateUserPhotoPath(int usrId, String photoPath) async {
    final db = await database;
    return db.update(
      "users",
      {"photo": photoPath},
      where: "usrId = ?",
      whereArgs: [usrId],
    );
  }

  Future<int> updateUser(Users user) async {
    final db = await database;
    return db.update(
      "users",
      user.toMap(),
      where: "usrId = ?",
      whereArgs: [user.usrId],
    );
  }

  // Course CRUD
  Future<int> insertCourse(Course course) async {
    final db = await database;
    return db.insert("courses", course.toMap());
  }

  Future<List<Course>> getCoursesByUser(String userEmail) async {
    final db = await database;
    final res = await db.query(
      "courses",
      where: "userEmail = ?",
      whereArgs: [userEmail.trim().toLowerCase()],
    );
    return res.map((e) => Course.fromMap(e)).toList();
  }
}
