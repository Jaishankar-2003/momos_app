class OrderModel {
  final int? id;
  final String itemsJson; // JSON string of items [{name,price,qty},...]
  final double total;
  final String date; // ISO yyyy-mm-dd
  final String time; // HH:MM

  OrderModel({
    this.id,
    required this.itemsJson,
    required this.total,
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': itemsJson,
      'total': total,
      'date': date,
      'time': time,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> m) {
    return OrderModel(
      id: m['id'] as int?,
      itemsJson: m['items'] as String,
      total: (m['total'] as num).toDouble(),
      date: m['date'] as String,
      time: m['time'] as String,
    );
  }
}
