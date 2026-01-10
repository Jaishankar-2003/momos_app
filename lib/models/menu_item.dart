
/*
class MenuItemModel {
  final int? id;
  final String name;
  final double price;

  MenuItemModel({this.id, required this.name, required this.price});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'price': price};
  }

  factory MenuItemModel.fromMap(Map<String, dynamic> m) {
    return MenuItemModel(
      id: m['id'] as int?,
      name: m['name'] as String,
      price: (m['price'] as num).toDouble(),
    );
  }
}
 */

import 'package:flutter/material.dart';

class MenuItemModel {
  final int? id;
  final String name;
  final double price;

  MenuItemModel({
    this.id,
    required this.name,
    required this.price,
  });

  // 🥗 Auto detect veg / non-veg from name
  bool get isVeg {
    final lower = name.toLowerCase();
    return lower.contains('veg') || lower.contains('paneer') || lower.contains('kalan')|| lower.contains('Kalan')|| lower.contains('Paneer');
  }

  // 🎨 Get color directly for UI usage
  Color get itemColor => isVeg ? Colors.green : Colors.red;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  factory MenuItemModel.fromMap(Map<String, dynamic> m) {
    return MenuItemModel(
      id: m['id'] as int?,
      name: m['name'] as String,
      price: (m['price'] as num).toDouble(),
    );
  }
}
