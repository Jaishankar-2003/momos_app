
/*
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
 */

import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  final String name;
  final double price;
  final VoidCallback onAdd;

  const MenuTile({
    super.key,
    required this.name,
    required this.price,
    required this.onAdd,
  });

  bool get isVeg {
    final lower = name.toLowerCase();
    return lower.contains('veg') || lower.contains('paneer');
  }

  @override
  Widget build(BuildContext context) {
    final Color itemColor = isVeg ? Colors.green.shade700 : Colors.red.shade700;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          radius: 8,
          backgroundColor: itemColor,
        ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: itemColor,
          ),
        ),
        subtitle: Text(
          '₹${price.toStringAsFixed(0)}',
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
        trailing: ElevatedButton(
          onPressed: onAdd,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange.shade400,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          ),
          child: const Text('Add'),
        ),
      ),
    );
  }
}
