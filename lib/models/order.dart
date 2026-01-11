// class OrderModel {
//   final int? id;
//   final String itemsJson; // JSON string of items [{name,price,qty},...]
//   final double total;
//   final String date; // ISO yyyy-mm-dd
//   final String time; // HH:MM
//
//   OrderModel({
//     this.id,
//     required this.itemsJson,
//     required this.total,
//     required this.date,
//     required this.time,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'items': itemsJson,
//       'total': total,
//       'date': date,
//       'time': time,
//     };
//   }
//
//   factory OrderModel.fromMap(Map<String, dynamic> m) {
//     return OrderModel(
//       id: m['id'] as int?,
//       itemsJson: m['items'] as String,
//       total: (m['total'] as num).toDouble(),
//       date: m['date'] as String,
//       time: m['time'] as String,
//     );
//   }
// }



// ########################################################################## working ###################################################################################################


// class OrderModel {
//   final int? id;
//   final String itemsJson; // JSON string of items [{name,price,qty},...]
//   final String customerName; // ✅ ADD
//   final double total;
//   final String date; // ISO yyyy-mm-dd
//   final String time; // HH:MM
//
//   OrderModel({
//     this.id,
//     required this.itemsJson,
//     required this.customerName,
//     required this.total,
//     required this.date,
//     required this.time,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'items': itemsJson,
//       'customer_name': customerName, // ✅ ADD
//       'total': total,
//       'date': date,
//       'time': time,
//     };
//   }
//
//   factory OrderModel.fromMap(Map<String, dynamic> m) {
//     return OrderModel(
//       id: m['id'] as int?,
//       itemsJson: m['items'] as String,
//       customerName: m['customer_name'], // ✅ ADD
//       total: (m['total'] as num).toDouble(),
//       date: m['date'] as String,
//       time: m['time'] as String,
//     );
//   }
// }

// ################################################################## order colour ###########################################################################################################

class OrderModel {
  final int? id;
  final String itemsJson;
  final String customerName;
  final double total;
  final String date;
  final String time;
  final bool isDelivered; // ✅

  OrderModel({
    this.id,
    required this.itemsJson,
    required this.customerName,
    required this.total,
    required this.date,
    required this.time,
    this.isDelivered = false, // ✅ default
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': itemsJson,
      'customer_name': customerName,
      'total': total,
      'date': date,
      'time': time,
      'is_delivered': isDelivered ? 1 : 0,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> m) {
    return OrderModel(
      id: m['id'] as int?,
      itemsJson: m['items'] as String,
      customerName: m['customer_name'] ?? '',
      total: (m['total'] as num).toDouble(),
      date: m['date'] as String,
      time: m['time'] as String,
      isDelivered: (m['is_delivered'] ?? 0) == 1, // ✅ backward safe
    );
  }
}
