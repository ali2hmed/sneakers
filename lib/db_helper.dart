import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/shoe_model.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'sneakers.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE cart (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER,
            shoeId INTEGER,
            name TEXT,
            price REAL,
            quantity INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE favorites (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER,
            shoeId INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE shoes (
            id INTEGER PRIMARY KEY,
            name TEXT,
            model TEXT,
            price REAL,
            image TEXT,
            description TEXT,
            category TEXT,
            selectedSize REAL,
            modelColor INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE orders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER,
            customerName TEXT,
            totalAmount REAL
          )
        ''');
      },
    );
  }

  // ✅ Check if shoe exists
  Future<bool> shoesExist(int id) async {
    final db = await database;
    var result = await db.query('shoes', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty;
  }

  // ✅ Insert shoes into database
  Future<void> insertShoes(List<ShoeModel> shoes) async {
    final db = await database;
    for (var shoe in shoes) {
      await db.insert(
        'shoes',
        {
          'id': shoe.id,
          'name': shoe.name,
          'model': shoe.model,
          'price': shoe.price,
          'image': shoe.imgAddress,
          'description': shoe.description,
          'category': shoe.category,
          'selectedSize': shoe.selectedSize,
          'modelColor': shoe.modelColor.value,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // ✅ Get all shoes
  Future<List<ShoeModel>> getShoes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('shoes');
    return maps.map((map) => ShoeModel.fromMap(map)).toList();
  }

  // ✅ Delete a shoe
  Future<void> deleteShoe(int id) async {
    final db = await database;
    await db.delete('shoes', where: 'id = ?', whereArgs: [id]);
  }

  // ✅ Manage Favorites
  Future<bool> isFavorite(int userId, int shoeId) async {
    final db = await database;
    var result = await db.query(
      'favorites',
      where: 'userId = ? AND shoeId = ?',
      whereArgs: [userId, shoeId],
    );
    return result.isNotEmpty;
  }

  Future<void> addFavorite(int userId, int shoeId) async {
    final db = await database;
    await db.insert(
      'favorites',
      {'userId': userId, 'shoeId': shoeId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(int userId, int shoeId) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'userId = ? AND shoeId = ?',
      whereArgs: [userId, shoeId],
    );
  }

  Future<List<Map<String, dynamic>>> getFavorites(int userId) async {
    final db = await database;
    return await db.query('favorites', where: 'userId = ?', whereArgs: [userId]);
  }

  // ✅ Cart Management
  Future<void> addToCart(int userId, int shoeId, String name, double price, int quantity) async {
    final db = await database;
    await db.insert(
      'cart',
      {'userId': userId, 'shoeId': shoeId, 'name': name, 'price': price, 'quantity': quantity},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getCartItems(int userId) async {
    final db = await database;
    return await db.query('cart', where: 'userId = ?', whereArgs: [userId]);
  }

  Future<void> removeFromCart(int userId, int shoeId) async {
    final db = await database;
    await db.delete('cart', where: 'userId = ? AND shoeId = ?', whereArgs: [userId, shoeId]);
  }

  Future<double> getCartTotal(int userId) async {
    final db = await database;
    var result = await db.rawQuery(
        'SELECT SUM(price * quantity) as total FROM cart WHERE userId = ?', [userId]);
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  // ✅ FIX: Update Cart Item Quantity
  Future<void> updateCartItemQuantity(int cartId, int newQuantity) async {
    final db = await database;
    await db.update(
      'cart',
      {'quantity': newQuantity},
      where: 'id = ?',
      whereArgs: [cartId],
    );
  }

  // ✅ User Authentication
  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    final db = await database;
    var result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> insertUser(String name, String email, String password) async {
    final db = await database;
    await db.insert(
      'users',
      {'name': name, 'email': email, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ✅ Orders
  Future<void> insertOrder(int userId, String customerName, double totalAmount) async {
    final db = await database;
    await db.insert(
      'orders',
      {'userId': userId, 'customerName': customerName, 'totalAmount': totalAmount},
    );
  }

  Future<List<Map<String, dynamic>>> getOrders(int userId) async {
    final db = await database;
    return await db.query('orders', where: 'userId = ?', whereArgs: [userId]);
  }

  // ✅ FIX: Check if email exists
  Future<bool> emailExists(String email) async {
    final db = await database;
    var result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  // ✅ FIX: Get User Profile
  Future<Map<String, dynamic>?> getUserProfile(int userId) async {
    final db = await database;
    var result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // ✅ FIX: Get Categories
  Future<List<String>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('shoes', distinct: true, columns: ['category']);
    return maps.map((map) => map['category'] as String).toList();
  }
}
