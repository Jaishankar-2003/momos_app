import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  final String name;
  final double price;
  final VoidCallback onAdd;

  const MenuTile({super.key, required this.name, required this.price, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text('₹${price.toStringAsFixed(0)}'),
      trailing: ElevatedButton(onPressed: onAdd, child: const Text('Add')),
    );
  }
}
