import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sneakers_app/data/dummy_data.dart'; // Import dummy_data.dart
import 'package:sneakers_app/models/shoe_model.dart'; // Import shoe_model.dart

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  static Database? _database;

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'sneakers.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE favorites (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            shoe_id INTEGER,
            FOREIGN KEY (user_id) REFERENCES users(id),
            FOREIGN KEY (shoe_id) REFERENCES shoes(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE payments (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            card_number TEXT,
            expiry_date TEXT,
            cvv TEXT,
            FOREIGN KEY (user_id) REFERENCES users(id)
          )
        ''');
      },
    );
  }

  // Insert a new user into the database
  Future<void> insertUser(String name, String email, String password) async {
    final db = await database;
    await db.insert(
      'users',
      {'name': name, 'email': email, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve a user by email and password
  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  // Check if an email already exists
  Future<bool> emailExists(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  // Add a shoe to favorites
  Future<void> addToFavorites(int userId, int shoeId) async {
    final db = await database;
    await db.insert(
      'favorites',
      {'user_id': userId, 'shoe_id': shoeId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all favorite shoes for a user

  // Insert payment information
  Future<void> insertPayment(int userId, String cardNumber, String expiryDate, String cvv) async {
    final db = await database;
    await db.insert(
      'payments',
      {'user_id': userId, 'card_number': cardNumber, 'expiry_date': expiryDate, 'cvv': cvv},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile(int userId) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }
}