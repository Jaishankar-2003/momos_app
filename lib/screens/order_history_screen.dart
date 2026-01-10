
/*
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
                            trailing: Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'x',
                                    style: TextStyle(
                                      fontSize: 16, // smaller for 'x'
                                      color: Colors.black54,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${it['qty']}',
                                    style: const TextStyle(
                                      fontSize: 18, // bigger only for qty
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )).toList(),
                          //   trailing: Text('x${it['qty']}', style: const TextStyle(
                          //       fontSize: 8),),
                          //
                          // )).toList(),
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
 */


import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/db_helper.dart';
import '../models/order.dart';

// class OrderHistoryScreen extends StatefulWidget {
//   const OrderHistoryScreen({super.key});
//
//   @override
//   State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
// }
//
// class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
//   List<OrderModel> _orders = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }
//
//   Future<void> _load() async {
//     final rows = await DBHelper.instance.getOrders();
//     setState(() {
//       _orders = rows;
//     });
//   }
//
//   Future<void> _deleteOrder(int id) async {
//     final result = await DBHelper.instance.deleteOrder(id);
//     if (result > 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Order deleted successfully')),
//       );
//       await _load(); // reload list
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to delete order')),
//       );
//     }
//   }
//
//   void _showOrderDetails(OrderModel o) {
//     final items = jsonDecode(o.itemsJson) as List<dynamic>;
//
//     showDialog(
//       context: context,
//       builder: (_) {
//         return AlertDialog(
//           title: Text('Order #${o.id}'),
//           content: SizedBox(
//             width: double.maxFinite,
//             child: ListView(
//               shrinkWrap: true,
//               children: items.map((it) {
//                 return ListTile(
//                   title: Text('${it['name']}'),
//                   trailing: Text.rich(
//                     TextSpan(
//                       children: [
//                         const TextSpan(
//                           text: 'x',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.black54,
//                           ),
//                         ),
//                         TextSpan(
//                           text: '${it['qty']}',
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () async {
//                 Navigator.pop(context);
//                 final confirm = await showDialog(
//                   context: context,
//                   builder: (_) => AlertDialog(
//                     title: const Text('Confirm Delete'),
//                     content: const Text('Are you sure you want to delete this order?'),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.pop(context, false),
//                         child: const Text('Cancel'),
//                       ),
//                       TextButton(
//                         onPressed: () => Navigator.pop(context, true),
//                         child: const Text('Delete', style: TextStyle(color: Colors.red)),
//                       ),
//                     ],
//                   ),
//                 );
//                 if (confirm == true) {
//                   await _deleteOrder(o.id!);
//                 }
//               },
//               child: const Text('Delete', style: TextStyle(color: Colors.red)),
//             ),
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Orders')),
//       body: RefreshIndicator(
//         onRefresh: _load,
//         child: _orders.isEmpty
//             ? const Center(child: Text('No orders found'))
//             : ListView.builder(
//           itemCount: _orders.length,
//           itemBuilder: (context, i) {
//             final o = _orders[i];
//             final items = jsonDecode(o.itemsJson) as List<dynamic>;
//
//             return Card(
//               margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//               child: ListTile(
//                 title: Text('₹${o.total.toStringAsFixed(2)}'),
//                 subtitle: Text('${o.date} ${o.time} • ${items.length} items'),
//                 onTap: () => _showOrderDetails(o),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }


//===================================================================================================================================



/*
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
                            trailing: Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'x',
                                    style: TextStyle(
                                      fontSize: 16, // smaller for 'x'
                                      color: Colors.black54,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${it['qty']}',
                                    style: const TextStyle(
                                      fontSize: 18, // bigger only for qty
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )).toList(),
                          //   trailing: Text('x${it['qty']}', style: const TextStyle(
                          //       fontSize: 8),),
                          //
                          // )).toList(),
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
 */

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

  Future<void> _deleteOrder(int id) async {
    final result = await DBHelper.instance.deleteOrder(id);
    if (result > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order deleted successfully')),
      );
      await _load(); // reload list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete order')),
      );
    }
  }

  void _showOrderDetails(OrderModel o) {
    final items = jsonDecode(o.itemsJson) as List<dynamic>;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            '${o.customerName} (Order #${o.id})',
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: items.map((it) {
                return ListTile(
                  title: Text('${it['name']}'),
                  trailing: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'x',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        TextSpan(
                          text: '${it['qty']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final confirm = await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Confirm Delete'),
                    content: const Text('Are you sure you want to delete this order?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await _deleteOrder(o.id!);
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _orders.isEmpty
            ? const Center(child: Text('No orders found'))
            : ListView.builder(
          itemCount: _orders.length,
          itemBuilder: (context, i) {
            final o = _orders[i];
            final items = jsonDecode(o.itemsJson) as List<dynamic>;

            // return Card(
            //   margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            //   child: ListTile(
            //     title: Text('₹${o.total.toStringAsFixed(2)}'),
            //     subtitle: Text('${o.date} ${o.time} • ${items.length} items'),
            //     onTap: () => _showOrderDetails(o),
            //   ),
            // );

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: ListTile(
                title: Text(
                  o.customerName.isNotEmpty ? o.customerName : 'Customer',
                  style: const TextStyle(
                    fontSize: 18,          // 🔼 increase here
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '₹${o.total.toStringAsFixed(2)} • ${o.date} ${o.time} • ${items.length} items',
                  style: const TextStyle(fontSize: 15),
                ),
                onTap: () => _showOrderDetails(o),
              ),
            );
          },
        ),
      ),
    );
  }
}



