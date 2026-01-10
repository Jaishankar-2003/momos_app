import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/menu_item.dart';
import '../models/order.dart';

class DBHelper
{
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
      final itemNames = items.map((item) => item.name.toLowerCase()).toSet();

      // Default menu items that should exist
      final defaultItems = [
        MenuItemModel(name: 'Veg Momos Boiled', price: 80),
        MenuItemModel(name: 'Veg Momos Fried', price: 80),
        MenuItemModel(name: 'Veg Momos Chilli', price: 100),
        MenuItemModel(name: 'Chicken Momos Boiled', price: 100),
        MenuItemModel(name: 'Chicken Momos Fried', price: 100),
        MenuItemModel(name: 'Chicken Momos Chilli', price: 120),
        MenuItemModel(name: 'Paneer Momos Boiled', price: 100),
        MenuItemModel(name: 'Paneer Momos Fried', price: 100),
        MenuItemModel(name: 'Paneer Momos chilli', price: 120),
        MenuItemModel(name: 'French Fries Veg', price: 70),
        MenuItemModel(name: 'Chilli potato Veg', price: 100),
        MenuItemModel(name: 'Roll Veg', price: 60),
        MenuItemModel(name: 'Chicken Roll', price: 80),
        MenuItemModel(name: 'Veg Rice', price: 100),
        MenuItemModel(name: 'Egg Rice', price: 110),
        MenuItemModel(name: 'Chicken Rice', price: 130),
        MenuItemModel(name: 'Paneer Rice', price: 130),
        MenuItemModel(name: 'Kalan Rice', price: 130),
        MenuItemModel(name: 'Veg noodles', price: 100),
        MenuItemModel(name: 'Egg noodles', price: 110),
        MenuItemModel(name: 'Chicken noodles', price: 130),
        MenuItemModel(name: 'Paneer noodles', price: 130),
        MenuItemModel(name: 'Kalan noodles', price: 130),
        MenuItemModel(name: 'Chilli chicken', price: 120),
        MenuItemModel(name: 'Chilli Paneer', price: 120),
        MenuItemModel(name: 'Chilli kalan', price: 100),
        MenuItemModel(name: 'Egg mix chicken Burgi', price: 120),
      ];

      // Add any missing items
      for (final item in defaultItems) {
        if (!itemNames.contains(item.name.toLowerCase())) {
          await insertMenuItem(item);
          debugPrint('Added missing menu item: ${item.name}');
        }
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
            customer_name TEXT,
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
        MenuItemModel(name: 'Veg Momos Boiled', price: 80),
        MenuItemModel(name: 'Veg Momos Fried', price: 80),
        MenuItemModel(name: 'Veg Momos Chilli', price: 100),
        MenuItemModel(name: 'Chicken Momos Boiled', price: 100),
        MenuItemModel(name: 'Chicken Momos Fried', price: 100),
        MenuItemModel(name: 'Chicken Momos Chilli', price: 120),
        MenuItemModel(name: 'Paneer Momos Boiled', price: 100),
        MenuItemModel(name: 'Paneer Momos Fried', price: 100),
        MenuItemModel(name: 'Paneer Momos chilli', price: 120),
        MenuItemModel(name: 'French Fries Veg', price: 70),
        MenuItemModel(name: 'Chilli potato Veg', price: 100),
        MenuItemModel(name: 'Roll Veg', price: 60),
        MenuItemModel(name: 'Chicken Roll', price: 80),
        MenuItemModel(name: 'Veg Rice', price: 100),
        MenuItemModel(name: 'Egg Rice', price: 110),
        MenuItemModel(name: 'Chicken Rice', price: 130),
        MenuItemModel(name: 'Paneer Rice', price: 130),
        MenuItemModel(name: 'Kalan Rice', price: 130),
        MenuItemModel(name: 'Veg noodles', price: 100),
        MenuItemModel(name: 'Egg noodles', price: 110),
        MenuItemModel(name: 'Chicken noodles', price: 130),
        MenuItemModel(name: 'Paneer noodles', price: 130),
        MenuItemModel(name: 'Kalan noodles', price: 130),
        MenuItemModel(name: 'Chilli chicken', price: 120),
        MenuItemModel(name: 'Chilli Paneer', price: 120),
        MenuItemModel(name: 'Chilli kalan', price: 100),
        MenuItemModel(name: 'Egg mix chicken Burgi', price: 120),

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

  Future<int> deleteOrder(int id) async {
    final db = await database;
    if (db == null) {
      debugPrint('Database not available (web platform)');
      return 0;
    }
    return await db.delete('orders', where: 'id = ?', whereArgs: [id]);
  }


}



