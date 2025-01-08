import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sneakers_app/data/dummy_data.dart'; // Import dummy_data.dart
import 'package:sneakers_app/models/shoe_model.dart'; // Import shoe_model.dart

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  static Database? _database;

  DBHelper._internal();

  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'sneakers.db');
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }

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
      version: 2,
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
          CREATE TABLE shoes (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            model TEXT NOT NULL,
            price REAL NOT NULL,
            image TEXT NOT NULL,
            color INTEGER
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
          CREATE TABLE cart (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            shoe_id INTEGER,
            size REAL NOT NULL,
            quantity INTEGER NOT NULL DEFAULT 1,
            added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
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

        // Initialize shoes data
        await _initializeShoes(db);
      },
    );
  }

  Future<void> _initializeShoes(Database db) async {
    // Insert all available shoes from dummy_data
    final batch = db.batch();
    for (var shoe in availableShoes) {
      batch.insert('shoes', {
        'id': shoe.id,
        'name': shoe.name,
        'model': shoe.model,
        'price': shoe.price,
        'image': shoe.imgAddress,
        'color': shoe.modelColor.value,
      });
    }
    await batch.commit();
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

  Future<List<Map<String, dynamic>>> getAllShoes() async {
    final db = await database;
    return await db.query('shoes');
  }

  Future<List<Map<String, dynamic>>> getFavorites(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.rawQuery('''
      SELECT s.*, f.id as favorite_id
      FROM favorites f
      JOIN shoes s ON f.shoe_id = s.id
      WHERE f.user_id = ?
    ''', [userId]);
    
    return results;
  }

  Future<void> addFavorite(int userId, int shoeId) async {
    final db = await database;
    await db.insert(
      'favorites',
      {
        'user_id': userId,
        'shoe_id': shoeId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(int userId, int shoeId) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'user_id = ? AND shoe_id = ?',
      whereArgs: [userId, shoeId],
    );
  }

  Future<bool> isFavorite(int userId, int shoeId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'favorites',
      where: 'user_id = ? AND shoe_id = ?',
      whereArgs: [userId, shoeId],
    );
    return result.isNotEmpty;
  }

  // Cart Methods
  Future<void> addToCart(int userId, ShoeModel shoe) async {
    final db = await database;
    
    // First ensure the shoe exists in the shoes table
    final List<Map<String, dynamic>> existingShoe = await db.query(
      'shoes',
      where: 'id = ?',
      whereArgs: [shoe.id],
    );

    if (existingShoe.isEmpty) {
      // Insert the shoe if it doesn't exist
      await db.insert('shoes', {
        'id': shoe.id,
        'name': shoe.name,
        'model': shoe.model,
        'price': shoe.price,
        'image': shoe.imgAddress,
        'color': shoe.modelColor.value,
      });
    }
    
    // Check if the same shoe with the same size exists in cart
    final List<Map<String, dynamic>> existing = await db.query(
      'cart',
      where: 'user_id = ? AND shoe_id = ? AND size = ?',
      whereArgs: [userId, shoe.id, shoe.selectedSize],
    );

    if (existing.isNotEmpty) {
      // Update quantity if same shoe with same size exists
      await db.update(
        'cart',
        {'quantity': existing.first['quantity'] + 1},
        where: 'id = ?',
        whereArgs: [existing.first['id']],
      );
    } else {
      // Add new item to cart
      await db.insert('cart', {
        'user_id': userId,
        'shoe_id': shoe.id,
        'size': shoe.selectedSize,
        'quantity': 1,
      });
    }
  }

  Future<List<Map<String, dynamic>>> getCartItems(int userId) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT c.*, s.name, s.model, s.price, s.image, c.size, c.quantity
      FROM cart c
      JOIN shoes s ON c.shoe_id = s.id
      WHERE c.user_id = ?
      ORDER BY c.added_at DESC
    ''', [userId]);
  }

  Future<void> updateCartItemQuantity(int cartId, int quantity) async {
    final db = await database;
    await db.update(
      'cart',
      {'quantity': quantity},
      where: 'id = ?',
      whereArgs: [cartId],
    );
  }

  Future<void> removeFromCart(int cartId) async {
    final db = await database;
    await db.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [cartId],
    );
  }

  Future<double> getCartTotal(int userId) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT SUM(s.price * c.quantity) as total
      FROM cart c
      JOIN shoes s ON c.shoe_id = s.id
      WHERE c.user_id = ?
    ''', [userId]);
    
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

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
    final List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
    
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }
}