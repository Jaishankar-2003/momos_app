import 'package:flutter/material.dart';
import '../services/db_helper.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  double totalToday = 0;
  Map<String,int> top = {};

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  Future<void> loadStats() async {
    final t = await DBHelper.instance.totalSalesToday();
    final topS = await DBHelper.instance.topSellers(top: 5);
    setState(() {
      totalToday = t;
      top = topS;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: RefreshIndicator(
        onRefresh: loadStats,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Card(child: ListTile(title: const Text('Total Sales Today'), subtitle: Text('₹${totalToday.toStringAsFixed(2)}',style: const TextStyle(
              fontSize: 22,           // ✅ bigger font
              fontWeight: FontWeight.bold,
            ),))),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Top Selling Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if (top.isEmpty) const Text('No data yet')
                  else ...top.entries.map((e) => ListTile(title: Text(e.key), trailing: Text('${e.value} sold',style: const TextStyle(
                    fontSize: 18,       // ✅ increased font
                    fontWeight: FontWeight.w600,
                  ),))),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
