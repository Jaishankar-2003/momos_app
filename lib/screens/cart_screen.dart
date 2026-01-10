import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../services/db_helper.dart';
import '../models/order.dart';
import '../services/pdf_service.dart';

// class CartScreen extends StatelessWidget {
//   const CartScreen({super.key});
//
//   Future<void> _confirmOrder(BuildContext context) async {
//     if (!context.mounted) return;
//     final provider = context.read<OrderProvider>();
//     if (provider.cart.isEmpty) {
//       if (!context.mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cart is empty')));
//       return;
//     }
//     // Save to DB
//     final dateTime = DateTime.now();
//     final date = "${dateTime.year.toString().padLeft(4,'0')}-${dateTime.month.toString().padLeft(2,'0')}-${dateTime.day.toString().padLeft(2,'0')}";
//     final time = "${dateTime.hour.toString().padLeft(2,'0')}:${dateTime.minute.toString().padLeft(2,'0')}";
//     final order = OrderModel(itemsJson: jsonEncode(provider.cart), total: provider.total, date: date, time: time);
//     final id = await DBHelper.instance.insertOrder(order);
//     final savedOrder = OrderModel(id: id, itemsJson: order.itemsJson, total: order.total, date: order.date, time: order.time);
//     provider.clearCart();
//     // Show invoice via PDF
//     //await PDFService().generateAndSharePdf(savedOrder);
//     await PDFService().generateAndSavePdf(savedOrder);
//     if (!context.mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order placed')));
//     if (!context.mounted) return;
//     Navigator.pop(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<OrderProvider>();
//     final cart = provider.cart;
//     return Scaffold(
//       appBar: AppBar(title: const Text('Cart')),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: cart.length,
//               itemBuilder: (c,i){
//                 final it = cart[i];
//                 return ListTile(
//                   title: Text('${it['name']}'),
//                   subtitle: Text('₹${it['price']} x ${it['qty']}'),
//                   trailing: Row(mainAxisSize: MainAxisSize.min, children: [
//                     IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => context.read<OrderProvider>().decrementItem(it['name'])),
//                     IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => context.read<OrderProvider>().removeItem(it['name'])),
//                   ]),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(12, 12, 12, 150),
//             child: Column(
//               children: [
//                 Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                   const Text('Total', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//                   Text('₹${provider.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//                 ]),
//                 const SizedBox(height: 100),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () => _confirmOrder(context),
//                     child: const Text('Confirm Order & Generate Invoice'),
//                   ),
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

//====================================================================================================================================================================================


class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _confirmOrder(BuildContext context) async {
    if (!context.mounted) return;
    final provider = context.read<OrderProvider>();
    if (provider.cart.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cart is empty')));
      return;
    }
    // Save to DB
    final dateTime = DateTime.now();
    final date = "${dateTime.year.toString().padLeft(4,'0')}-${dateTime.month.toString().padLeft(2,'0')}-${dateTime.day.toString().padLeft(2,'0')}";
    final time = "${dateTime.hour.toString().padLeft(2,'0')}:${dateTime.minute.toString().padLeft(2,'0')}";

    final customerName = await _askCustomerName(context);
    if (customerName == null) return;

    final order = OrderModel(
      customerName: customerName, // ✅ ADD
      itemsJson: jsonEncode(provider.cart),
      total: provider.total,
      date: date,
      time: time,
    );

    final id = await DBHelper.instance.insertOrder(order);

    final savedOrder = OrderModel(
      id: id,
      customerName: order.customerName, // ✅ ADD THIS
      itemsJson: order.itemsJson,
      total: order.total,
      date: order.date,
      time: order.time,
    );

    provider.clearCart();
    // Show invoice via PDF
    //await PDFService().generateAndSharePdf(savedOrder);
    await PDFService().generateAndSavePdf(savedOrder);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order placed')));
    if (!context.mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();
    final cart = provider.cart;
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (c,i){
                final it = cart[i];
                return ListTile(
                  title: Text('${it['name']}'),
                  subtitle: Text('₹${it['price']} x ${it['qty']}'),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => context.read<OrderProvider>().decrementItem(it['name'])),
                    IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => context.read<OrderProvider>().removeItem(it['name'])),
                  ]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 150),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('Total', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text('₹${provider.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 100),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _confirmOrder(context),
                    child: const Text('Confirm Order & Generate Invoice'),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

Future<String?> _askCustomerName(BuildContext context) async {
  final controller = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Customer Name'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: 'Enter customer name',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = controller.text.trim();
            if (name.isNotEmpty) {
              Navigator.pop(ctx, name);
            }
          },
          child: const Text('Confirm'),
        ),
      ],
    ),
  );
}

