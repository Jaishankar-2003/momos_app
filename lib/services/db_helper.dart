import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/menu_item.dart';
import '../models/order.dart';

class DBHelper {
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _db;
  bool _isInitialized = false;
  bool get isWeb => kIsWeb;

  Future<Database?> get database async {
    if (isWeb) return null;
    return _db ??= await _init();
  }

  Future<void> initDB() async {
    if (_isInitialized) return;
    if (isWeb) {
      debugPrint('DB initialization skipped on web platform');
      _isInitialized = true;
      return;
    }

    try {
      _db ??= await _init();
      // ensure default menu populated
      final items = await getMenuItems();
      if (items.isEmpty) {
        await insertMenuItem(MenuItemModel(name: 'Veg Momos', price: 50));
        await insertMenuItem(MenuItemModel(name: 'Chicken Momos', price: 80));
        await insertMenuItem(MenuItemModel(name: 'Paneer Momos', price: 70));
      }
      _isInitialized = true;
    } catch (e) {
      debugPrint('DB initialization error: $e');
      _isInitialized = true; // Mark as initialized to prevent retries
    }
  }

  Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'momos_pos.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE menu_items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            price REAL NOT NULL
          );
        ''');
        await db.execute('''
          CREATE TABLE orders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            items TEXT NOT NULL,
            total REAL NOT NULL,
            date TEXT NOT NULL,
            time TEXT NOT NULL
          );
        ''');
      },
    );
  }

  // Menu operations
  Future<int> insertMenuItem(MenuItemModel item) async {
    final db = await database;
    if (db == null) {
      debugPrint('Database not available (web platform)');
      return 0;
    }
    return await db.insert('menu_items', item.toMap());
  }

  Future<List<MenuItemModel>> getMenuItems() async {
    final db = await database;
    if (db == null) {
      // Return default items for web
      return [
        MenuItemModel(name: 'Veg Momos', price: 50),
        MenuItemModel(name: 'Chicken Momos', price: 80),
        MenuItemModel(name: 'Paneer Momos', price: 70),
        MenuItemModel(name: 'chicken Rice', price: 70),
      ];
    }
    final rows = await db.query('menu_items', orderBy: 'id DESC');
    return rows.map((r) => MenuItemModel.fromMap(r)).toList();
  }

  Future<int> deleteMenuItem(int id) async {
    final db = await database;
    if (db == null) {
      debugPrint('Database not available (web platform)');
      return 0;
    }
    return await db.delete('menu_items', where: 'id=?', whereArgs: [id]);
  }

  // Order operations
  Future<int> insertOrder(OrderModel order) async {
    final db = await database;
    if (db == null) {
      debugPrint('Database not available (web platform)');
      return 0;
    }
    return await db.insert('orders', order.toMap());
  }

  Future<List<OrderModel>> getOrders() async {
    final db = await database;
    if (db == null) {
      return [];
    }
    final rows = await db.query('orders', orderBy: 'id DESC');
    return rows.map((r) => OrderModel.fromMap(r)).toList();
  }

  // Stats helpers
  Future<Map<String, int>> topSellers({int top = 5}) async {
    final db = await database;
    if (db == null) {
      return {};
    }
    final rows = await db.query('orders');
    final Map<String, int> counts = {};
    for (var r in rows) {
      final items = jsonDecode(r['items'] as String) as List<dynamic>;
      for (var it in items) {
        final name = it['name'] as String;
        final qty = it['qty'] as int;
        counts[name] = (counts[name] ?? 0) + qty;
      }
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final Map<String, int> out = {};
    for (var i = 0; i < sorted.length && i < top; i++) {
      out[sorted[i].key] = sorted[i].value;
    }
    return out;
  }

  Future<double> totalSalesToday() async {
    final db = await database;
    if (db == null) {
      return 0.0;
    }
    final today = DateTime.now();
    final dateStr =
        "${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    final rows = await db.query(
      'orders',
      where: 'date = ?',
      whereArgs: [dateStr],
    );
    double sum = 0;
    for (var r in rows) {
      sum += (r['total'] as num).toDouble();
    }
    return sum;
  }
}
