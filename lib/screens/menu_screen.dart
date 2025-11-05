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
