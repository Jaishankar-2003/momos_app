import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../models/order.dart';
import '../services/db_helper.dart';

// class OrderProvider extends ChangeNotifier {
//   final List<Map<String, dynamic>> _cart = []; // {name, price, qty}
//   List<Map<String, dynamic>> get cart => List.unmodifiable(_cart);
//
//   void addToCart(MenuItemModel item) {
//     final idx = _cart.indexWhere((e) => e['name'] == item.name);
//     if (idx == -1) {
//       _cart.add({'name': item.name, 'price': item.price, 'qty': 1});
//     } else {
//       _cart[idx]['qty'] = _cart[idx]['qty'] + 1;
//     }
//     notifyListeners();
//   }
//
//   void decrementItem(String name) {
//     final idx = _cart.indexWhere((e) => e['name'] == name);
//     if (idx != -1) {
//       if (_cart[idx]['qty'] > 1) {
//         _cart[idx]['qty'] = _cart[idx]['qty'] - 1;
//       } else {
//         _cart.removeAt(idx);
//       }
//       notifyListeners();
//     }
//   }
//
//   void removeItem(String name) {
//     _cart.removeWhere((e) => e['name'] == name);
//     notifyListeners();
//   }
//
//   double get total {
//     double sum = 0;
//     for (var i in _cart) {
//       sum += (i['price'] as double) * (i['qty'] as int);
//     }
//     return sum;
//   }
//
//   void clearCart() {
//     _cart.clear();
//     notifyListeners();
//   }
//
//   // Place order and save to local DB
//   Future<void> placeOrder() async {
//     if (_cart.isEmpty) return;
//     final dateTime = DateTime.now();
//     final date = "${dateTime.year.toString().padLeft(4,'0')}-${dateTime.month.toString().padLeft(2,'0')}-${dateTime.day.toString().padLeft(2,'0')}";
//     final time = "${dateTime.hour.toString().padLeft(2,'0')}:${dateTime.minute.toString().padLeft(2,'0')}";
//     final order = OrderModel(
//       itemsJson: jsonEncode(_cart),
//       total: total,
//       date: date,
//       time: time,
//     );
//     await DBHelper.instance.insertOrder(order);
//     clearCart();
//   }
// }


//=====================================================================================================================================================================================

import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../models/order.dart';
import '../services/db_helper.dart';

class OrderProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _cart = []; // {name, price, qty}
  List<Map<String, dynamic>> get cart => List.unmodifiable(_cart);

  void addToCart(MenuItemModel item) {
    final idx = _cart.indexWhere((e) => e['name'] == item.name);
    if (idx == -1) {
      _cart.add({'name': item.name, 'price': item.price, 'qty': 1});
    } else {
      _cart[idx]['qty'] = _cart[idx]['qty'] + 1;
    }
    notifyListeners();
  }

  void decrementItem(String name) {
    final idx = _cart.indexWhere((e) => e['name'] == name);
    if (idx != -1) {
      if (_cart[idx]['qty'] > 1) {
        _cart[idx]['qty'] = _cart[idx]['qty'] - 1;
      } else {
        _cart.removeAt(idx);
      }
      notifyListeners();
    }
  }

  void removeItem(String name) {
    _cart.removeWhere((e) => e['name'] == name);
    notifyListeners();
  }

  double get total {
    double sum = 0;
    for (var i in _cart) {
      sum += (i['price'] as double) * (i['qty'] as int);
    }
    return sum;
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  // Place order and save to local DB
  // Future<void> placeOrder() async {
  //   if (_cart.isEmpty) return;
  //   final dateTime = DateTime.now();
  //   final date = "${dateTime.year.toString().padLeft(4,'0')}-${dateTime.month.toString().padLeft(2,'0')}-${dateTime.day.toString().padLeft(2,'0')}";
  //   final time = "${dateTime.hour.toString().padLeft(2,'0')}:${dateTime.minute.toString().padLeft(2,'0')}";
  //   final order = OrderModel(
  //     itemsJson: jsonEncode(_cart),
  //     total: total,
  //     date: date,
  //     time: time,
  //   );
  //   await DBHelper.instance.insertOrder(order);
  //   clearCart();
  // }
}
