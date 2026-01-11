/*

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/db_helper.dart';
import '../models/menu_item.dart';
import '../providers/order_provider.dart';
import '../widgets/menu_tile.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<MenuItemModel> _menu = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMenu();
  }

  Future<void> _loadMenu() async {
    if (!mounted) return; // Prevent setState if widget is disposed

    setState(() => _isLoading = true);
    try {
      final items = await DBHelper.instance.getMenuItems();
      if (!mounted) return;

      setState(() {
        _menu = items;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading menu: ${error.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _openCart() {
    Navigator.pushNamed(context, '/cart');
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<OrderProvider>().cart;
    final cartCount =
        cart.fold<int>(0, (p, e) => p + ((e['qty'] as int?) ?? 0));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mallang's Momos"),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            onPressed: () => Navigator.pushNamed(context, '/orders'),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: _openCart,
              ),
              if (cartCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.white,
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(fontSize: 10, color: Colors.black),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadMenu,
              child: ListView.builder(
                itemCount: _menu.length,
                itemBuilder: (ctx, i) {
                  final item = _menu[i];
                  return MenuTile(
                    name: item.name,
                    price: item.price,
                    onAdd: () => context.read<OrderProvider>().addToCart(item),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.admin_panel_settings),
        onPressed: () => Navigator.pushNamed(context, '/admin'),
      ),
    );
  }
}
 */

//----------------------------------------------------------------------------------------

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../services/db_helper.dart';
// import '../models/menu_item.dart';
// import '../providers/order_provider.dart';
// import '../widgets/menu_tile.dart';
//
//
// String getCategory(String name) {
//   final lower = name.toLowerCase();
//
//   if (lower.contains('chicken')) return 'Chicken';
//   if (lower.contains('egg')) return 'Egg';
//   if (lower.contains('paneer')) return 'Paneer';
//   if (lower.contains('kalan')) return 'Kalan';
//   return 'Veg';
// }
//
//
//
// class MenuScreen extends StatefulWidget {
//   const MenuScreen({super.key});
//   @override
//   State<MenuScreen> createState() => _MenuScreenState();
// }
//
// class _MenuScreenState extends State<MenuScreen> {
//   List<MenuItemModel> _menu = [];
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadMenu();
//   }
//
//   Future<void> _loadMenu() async {
//     if (!mounted) return;
//     setState(() => _isLoading = true);
//     try {
//       final items = await DBHelper.instance.getMenuItems();
//       if (!mounted) return;
//       setState(() {
//         _menu = items;
//         _isLoading = false;
//       });
//     } catch (error) {
//       if (!mounted) return;
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error loading menu: ${error.toString()}'),
//           backgroundColor: Colors.red,
//           duration: const Duration(seconds: 3),
//         ),
//       );
//     }
//   }
//
//   void _openCart() {
//     Navigator.pushNamed(context, '/cart');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<OrderProvider>();
//     final cart = provider.cart;
//     final total = provider.total;
//     final cartCount = cart.fold<int>(0, (p, e) => p + ((e['qty'] as int?) ?? 0));
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Mallai Momos (Jspcs)"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.receipt_long),
//             onPressed: () => Navigator.pushNamed(context, '/orders'),
//           ),
//           Stack(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.shopping_cart),
//                 onPressed: _openCart,
//               ),
//               if (cartCount > 0)
//                 Positioned(
//                   right: 6,
//                   top: 6,
//                   child: CircleAvatar(
//                     radius: 9,
//                     backgroundColor: Colors.white,
//                     child: Text(
//                       '$cartCount',
//                       style: const TextStyle(fontSize: 10, color: Colors.black),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           _isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : RefreshIndicator(
//             onRefresh: _loadMenu,
//             child: ListView.builder(
//               padding: const EdgeInsets.only(bottom: 50), // prevent overlap
//               itemCount: _menu.length,
//               itemBuilder: (ctx, i) {
//                 final item = _menu[i];
//                 return MenuTile(
//                   name: item.name,
//                   price: item.price,
//                   onAdd: () => context.read<OrderProvider>().addToCart(item),
//                 );
//               },
//             ),
//           ),
//           if (total > 0)
//             Positioned(
//               bottom: 75,
//               left: 10,
//               right: 10,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.green.shade600.withValues(alpha: 0.75),
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: const [
//                     BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
//                   ],
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Total: ₹${total.toStringAsFixed(2)}',
//                       style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600.withValues(alpha: 0.75),
//                     ),
//                       onPressed: _openCart,
//                       child: const Text(
//                         'View Cart',
//                         style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.admin_panel_settings),
//         onPressed: () => Navigator.pushNamed(context, '/admin'),
//       ),
//     );
//   }
// }


//========================================================================== working ==========================================================


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../services/db_helper.dart';
// import '../models/menu_item.dart';
// import '../providers/order_provider.dart';
// import '../widgets/menu_tile.dart';
//
//
// String getCategory(String name) {
//   final lower = name.toLowerCase();
//
//   if (lower.contains('chicken')) return 'Chicken';
//   if (lower.contains('egg')) return 'Egg';
//   if (lower.contains('paneer')) return 'Paneer';
//   if (lower.contains('kalan')) return 'Kalan';
//   return 'Veg';
// }
//
// Color getCategoryColor(String category) {
//   switch (category) {
//     case 'Chicken':
//       return Colors.red.shade700;
//     case 'Egg':
//       return Colors.orange.shade700;
//     case 'Paneer':
//       return Colors.green.shade700;
//     case 'Kalan':
//       return Colors.brown.shade600;
//     case 'Veg':
//     default:
//       return Colors.lightGreen.shade700;
//   }
// }
//
//
//
// class MenuScreen extends StatefulWidget {
//   const MenuScreen({super.key});
//   @override
//   State<MenuScreen> createState() => _MenuScreenState();
// }
//
// class _MenuScreenState extends State<MenuScreen> {
//   List<MenuItemModel> _menu = [];
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadMenu();
//   }
//
//   Future<void> _loadMenu() async {
//     if (!mounted) return;
//     setState(() => _isLoading = true);
//     try {
//       final items = await DBHelper.instance.getMenuItems();
//       if (!mounted) return;
//       setState(() {
//         _menu = items;
//         _isLoading = false;
//       });
//     } catch (error) {
//       if (!mounted) return;
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error loading menu: ${error.toString()}'),
//           backgroundColor: Colors.red,
//           duration: const Duration(seconds: 3),
//         ),
//       );
//     }
//   }
//
//   void _openCart() {
//     Navigator.pushNamed(context, '/cart');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<OrderProvider>();
//     final cart = provider.cart;
//     final total = provider.total;
//     final cartCount = cart.fold<int>(0, (p, e) => p + ((e['qty'] as int?) ?? 0));
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Mallai Momos (Jspcs)"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.receipt_long),
//             onPressed: () => Navigator.pushNamed(context, '/orders'),
//           ),
//           Stack(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.shopping_cart),
//                 onPressed: _openCart,
//               ),
//               if (cartCount > 0)
//                 Positioned(
//                   right: 6,
//                   top: 6,
//                   child: CircleAvatar(
//                     radius: 9,
//                     backgroundColor: Colors.white,
//                     child: Text(
//                       '$cartCount',
//                       style: const TextStyle(fontSize: 10, color: Colors.black),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           _isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : RefreshIndicator(
//             onRefresh: _loadMenu,
//             child: Builder(
//               builder: (context) {
//                 final Map<String, List<MenuItemModel>> groupedMenu = {};
//
//                 for (final item in _menu) {
//                   final category = getCategory(item.name);
//                   groupedMenu.putIfAbsent(category, () => []).add(item);
//                 }
//
//                 return ListView(
//                   padding: const EdgeInsets.only(bottom: 50),
//                   children: groupedMenu.entries.map((entry) {
//                     return Card(
//                       margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                       child: ExpansionTile(
//                         title: Text(
//                           entry.key,
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: getCategoryColor(entry.key),
//                           ),
//                         ),
//                         children: entry.value.map((item) {
//                           return MenuTile(
//                             name: item.name,
//                             price: item.price,
//                             onAdd: () =>
//                                 context.read<OrderProvider>().addToCart(item),
//                           );
//                         }).toList(),
//                       ),
//                     );
//                   }).toList(),
//                 );
//               },
//             ),
//
//           ),
//           if (total > 0)
//             Positioned(
//               bottom: 75,
//               left: 10,
//               right: 10,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.green.shade600.withValues(alpha: 0.75),
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: const [
//                     BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
//                   ],
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Total: ₹${total.toStringAsFixed(2)}',
//                       style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600.withValues(alpha: 0.75),
//                       ),
//                       onPressed: _openCart,
//                       child: const Text(
//                         'View Cart',
//                         style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.admin_panel_settings),
//         onPressed: () => Navigator.pushNamed(context, '/admin'),
//       ),
//     );
//   }
// }
//

//================================================================ order colour =====================================================================


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/db_helper.dart';
import '../models/menu_item.dart';
import '../providers/order_provider.dart';
import '../widgets/menu_tile.dart';
import '../services/feedback_helper.dart';


String getCategory(String name) {
  final lower = name.toLowerCase();

  if (lower.contains('chicken')) return 'Chicken';
  if (lower.contains('egg')) return 'Egg';
  if (lower.contains('paneer')) return 'Paneer';
  if (lower.contains('kalan')) return 'Kalan';
  return 'Veg';
}

Color getCategoryColor(String category) {
  switch (category) {
    case 'Chicken':
      return Colors.red.shade700;
    case 'Egg':
      return Colors.orange.shade700;
    case 'Paneer':
      return Colors.green.shade700;
    case 'Kalan':
      return Colors.brown.shade600;
    case 'Veg':
    default:
      return Colors.lightGreen.shade700;
  }
}

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<MenuItemModel> _menu = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMenu();
  }

  Future<void> _loadMenu() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final items = await DBHelper.instance.getMenuItems();
      if (!mounted) return;
      setState(() {
        _menu = items;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading menu: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _openCart() {
    Navigator.pushNamed(context, '/cart');
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();
    final cart = provider.cart;
    final total = provider.total;
    final cartCount =
    cart.fold<int>(0, (p, e) => p + ((e['qty'] as int?) ?? 0));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mallai Momos (Jspcs)"),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            onPressed: () => Navigator.pushNamed(context, '/orders'),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: _openCart,
              ),
              if (cartCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.white,
                    child: Text(
                      '$cartCount',
                      style:
                      const TextStyle(fontSize: 10, color: Colors.black),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      // ✅ BODY (NO OVERLAP)
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadMenu,
        child: Builder(
          builder: (context) {
            final Map<String, List<MenuItemModel>> groupedMenu = {};

            for (final item in _menu) {
              final category = getCategory(item.name);
              groupedMenu
                  .putIfAbsent(category, () => [])
                  .add(item);
            }

            return ListView(
              padding: const EdgeInsets.only(bottom: 12),
              children: groupedMenu.entries.map((entry) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  child: ExpansionTile(
                    title: Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: getCategoryColor(entry.key),
                      ),
                    ),
                    children: entry.value.map((item) {
                      return MenuTile(
                        name: item.name,
                        price: item.price,
                    //     onAdd: () => context
                    //         .read<OrderProvider>()
                    //         .addToCart(item),
                    //   );
                    // }).toList(),
                        onAdd: () {
                          context.read<OrderProvider>().addToCart(item);
                          FeedbackHelper.itemAdded(); // 🔔 correct place
                        },
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),

      // ✅ FIXED TOTAL BAR (BEST UX)
      bottomNavigationBar: total > 0
          ? SafeArea(
        child: Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.green.shade600,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: ₹${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                ),
                onPressed: _openCart,
                child: const Text(
                  'View Cart',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      )
          : null,

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.admin_panel_settings),
        onPressed: () => Navigator.pushNamed(context, '/admin'),
      ),
    );
  }
}
