// import 'package:flutter/material.dart';
// import '../services/db_helper.dart';
// import '../services/admin_report_pdf.dart';
//
//
// class AdminDashboard extends StatefulWidget {
//   const AdminDashboard({super.key});
//   @override
//   State<AdminDashboard> createState() => _AdminDashboardState();
// }
//
// class _AdminDashboardState extends State<AdminDashboard> {
//   double totalToday = 0;
//   Map<String,int> top = {};
//
//   @override
//   void initState() {
//     super.initState();
//     loadStats();
//   }
//
//   Future<void> loadStats() async {
//     final t = await DBHelper.instance.totalSalesToday();
//     final topS = await DBHelper.instance.topSellers(top: 5);
//     setState(() {
//       totalToday = t;
//       top = topS;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Admin Dashboard')),
//       body: RefreshIndicator(
//         onRefresh: loadStats,
//         child: ListView(
//           padding: const EdgeInsets.all(12),
//           children: [
//             Card(child: ListTile(title: const Text('Total Sales Today'), subtitle: Text('₹${totalToday.toStringAsFixed(2)}',style: const TextStyle(
//               fontSize: 22,           // ✅ bigger font
//               fontWeight: FontWeight.bold,
//             ),))),
//             const SizedBox(height: 12),
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                   const Text('Top Selling Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   if (top.isEmpty) const Text('No data yet')
//                   else ...top.entries.map((e) => ListTile(title: Text(e.key), trailing: Text('${e.value} sold',style: const TextStyle(
//                     fontSize: 18,       // ✅ increased font
//                     fontWeight: FontWeight.w600,
//                   ),))),
//                 ]),
//               ),
//             ),
//
//
//
//             const SizedBox(height: 20),
//
//             ElevatedButton.icon(
//               icon: const Icon(Icons.download),
//               label: const Text(
//                 "Download End of Day Report",
//                 style: TextStyle(fontSize: 16),
//               ),
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//               ),
//               onPressed: () async {
//                 await AdminReportPDF().generateAndSave(
//                   totalToday: totalToday,
//                   topItems: top,
//                 );
//
//                 if (!mounted) return;
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text("Admin report downloaded successfully"),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//===========================================================================================================================

//========================================================= Working ==================================================================


// import 'package:flutter/material.dart';
// import '../services/db_helper.dart';
// import '../services/admin_report_pdf.dart';
//
// class AdminDashboard extends StatefulWidget {
//   const AdminDashboard({super.key});
//   @override
//   State<AdminDashboard> createState() => _AdminDashboardState();
// }
//
// class _AdminDashboardState extends State<AdminDashboard> {
//   double totalToday = 0;
//   Map<String, int> top = {};
//
//   @override
//   void initState() {
//     super.initState();
//     loadStats();
//   }
//
//   // Future<void> loadStats() async {
//   //   final t = await DBHelper.instance.totalSalesToday();
//   //   final topS = await DBHelper.instance.todayItemSales();
//   //   setState(() {
//   //     totalToday = t;
//   //     top = topS;
//   //   });
//   // }
//
//
//   double totalWeek = 0;
//   Map<String, int> weekTop = {};
//
//
//
//   Future<void> loadStats() async {
//     final t = await DBHelper.instance.totalSalesToday();
//     final topS = await DBHelper.instance.todayItemSales();
//
//     final wTotal = await DBHelper.instance.totalSalesThisWeek();
//     final wTop = await DBHelper.instance.weekItemSales();
//
//     setState(() {
//       totalToday = t;
//       top = topS;
//       totalWeek = wTotal;
//       weekTop = wTop;
//     });
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Admin Dashboard')),
//       body: RefreshIndicator(
//         onRefresh: loadStats,
//         child: ListView(
//           padding: const EdgeInsets.all(12),
//           children: [
//             Card(
//               child: ListTile(
//                 title: const Text('Total Sales Today'),
//                 subtitle: Text(
//                   '₹${totalToday.toStringAsFixed(2)}',
//                   style: const TextStyle(
//                     fontSize: 22, // ✅ bigger font
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Top Selling Items',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     if (top.isEmpty)
//                       const Text('No data yet')
//                     else
//                       ...top.entries.map(
//                         (e) => ListTile(
//                           title: Text(e.key),
//                           trailing: Text(
//                             '${e.value} sold',
//                             style: const TextStyle(
//                               fontSize: 18, // ✅ increased font
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             ElevatedButton.icon(
//               icon: const Icon(Icons.download),
//               label: const Text(
//                 "Download End of Day Report",
//                 style: TextStyle(fontSize: 16),
//               ),
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//               ),
//               onPressed: () async {
//                 try {
//                   await AdminReportPDF().generateAndSave(
//                     totalToday: totalToday,
//                     topItems: top,
//                   );
//
//                   if (!mounted) return;
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text("Admin report downloaded successfully"),
//                     ),
//                   );
//                 } catch (e) {
//                   if (!mounted) return;
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text("Error: ${e.toString()}"),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               },
//             ),
//
//             const SizedBox(height: 12),
//
//             ElevatedButton.icon(
//               icon: const Icon(Icons.download),
//               label: const Text(
//                 "Download Weekly Report",
//                 style: TextStyle(fontSize: 16),
//               ),
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//               ),
//               onPressed: () async {
//                 try {
//                   await AdminReportPDF().generateAndSave(
//                     totalToday: totalWeek,
//                     topItems: weekTop,
//                   );
//
//                   if (!mounted) return;
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text("Weekly report downloaded successfully"),
//                     ),
//                   );
//                 } catch (e) {
//                   if (!mounted) return;
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text("Error: ${e.toString()}"),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               },
//             ),
//
//
//             const SizedBox(height: 12),
//
//             Card(
//               child: ListTile(
//                 title: const Text('Total Sales This Week'),
//                 subtitle: Text(
//                   '₹${totalWeek.toStringAsFixed(2)}',
//                   style: const TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 12),
//
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Top Selling Items (This Week)',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     if (weekTop.isEmpty)
//                       const Text('No data yet')
//                     else
//                       ...weekTop.entries.map(
//                             (e) => ListTile(
//                           title: Text(e.key),
//                           trailing: Text(
//                             '${e.value} sold',
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//
//
//
//           ],
//         ),
//       ),
//     );
//   }
// }

//=========================================================================================================================

import 'package:flutter/material.dart';
import '../services/db_helper.dart';
import '../services/admin_report_pdf.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  double totalToday = 0;
  Map<String, int> top = {};

  double totalWeek = 0; // ✅ keep weekly total

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  Future<void> loadStats() async {
    final t = await DBHelper.instance.totalSalesToday();
    final topS = await DBHelper.instance.todayItemSales();
    final wTotal = await DBHelper.instance.totalSalesThisWeek();

    if (!mounted) return;

    setState(() {
      totalToday = t;
      top = topS;
      totalWeek = wTotal;
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
            // ================= TODAY =================

            Card(
              child: ListTile(
                title: const Text('Total Sales Today'),
                subtitle: Text(
                  '₹${totalToday.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Top Selling Items (Today)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (top.isEmpty)
                      const Text('No data yet')
                    else
                      ...top.entries.map(
                            (e) => ListTile(
                          title: Text(e.key),
                          trailing: Text(
                            '${e.value} sold',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ================= WEEK =================

            Card(
              child: ListTile(
                title: const Text('Total Sales This Week'),
                subtitle: Text(
                  '₹${totalWeek.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Divider(),

            // ================= ACTIONS =================

            ElevatedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text(
                "Download End of Day Report",
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () async {
                try {
                  await AdminReportPDF().generateAndSave(
                    totalToday: totalToday,
                    topItems: top,
                  );

                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("End of day report downloaded"),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error: ${e.toString()}"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text(
                "Download Weekly Report",
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () async {
                try {
                  await AdminReportPDF().generateAndSave(
                    totalToday: totalWeek,
                    topItems: const {}, // ✅ empty map (no weekly items)
                  );

                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Weekly report downloaded"),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error: ${e.toString()}"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
