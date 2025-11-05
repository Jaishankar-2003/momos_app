import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/db_helper.dart';
import '../models/order.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<OrderModel> _orders = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final rows = await DBHelper.instance.getOrders();
    setState(() {
      _orders = rows;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView.builder(
          itemCount: _orders.length,
          itemBuilder: (c,i){
            final o = _orders[i];
            final items = jsonDecode(o.itemsJson) as List<dynamic>;
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: ListTile(
                title: Text('₹${o.total.toStringAsFixed(2)}'),
                subtitle: Text('${o.date} ${o.time} • ${items.length} items'),
                onTap: () {
                  showDialog(context: context, builder: (_) {
                    return AlertDialog(
                      title: Text('Order #${o.id}'),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: ListView(
                          shrinkWrap: true,
                          children: items.map((it) => ListTile(
                            title: Text('${it['name']}'),
                            trailing: Text('x${it['qty']}'),
                          )).toList(),
                        ),
                      ),
                      actions: [TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('Close'))],
                    );
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
