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
import 'package:provider/provider.dart';
import '../services/db_helper.dart';
import '../services/admin_report_pdf.dart';
import '../services/network_service.dart';

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

            // ================= NETWORK =================
            
            // Consumer<NetworkService>(
            //   builder: (context, networkService, _) {
            //     return Card(
            //       color: networkService.isHost
            //           ? Colors.green.shade50
            //           : networkService.isDiscovering
            //               ? Colors.blue.shade50
            //               : null,
            //       child: Padding(
            //         padding: const EdgeInsets.all(12.0),
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             const Text(
            //               'Network Sync',
            //               style: TextStyle(
            //                 fontSize: 18,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             ),
            //             const SizedBox(height: 12),
            //
            //             if (networkService.errorMessage != null)
            //               Container(
            //                 padding: const EdgeInsets.all(8),
            //                 margin: const EdgeInsets.only(bottom: 12),
            //                 decoration: BoxDecoration(
            //                   color: Colors.red.shade50,
            //                   borderRadius: BorderRadius.circular(4),
            //                   border: Border.all(color: Colors.red.shade200),
            //                 ),
            //                 child: Row(
            //                   children: [
            //                     Icon(Icons.error, color: Colors.red.shade700, size: 20),
            //                     const SizedBox(width: 8),
            //                     Expanded(
            //                       child: Text(
            //                         networkService.errorMessage!,
            //                         style: TextStyle(
            //                           color: Colors.red.shade700,
            //                           fontSize: 12,
            //                         ),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //
            //             if (networkService.isHost)
            //               Container(
            //                 padding: const EdgeInsets.all(8),
            //                 margin: const EdgeInsets.only(bottom: 12),
            //                 decoration: BoxDecoration(
            //                   color: Colors.green.shade100,
            //                   borderRadius: BorderRadius.circular(4),
            //                 ),
            //                 child: Row(
            //                   children: [
            //                     Icon(Icons.wifi, color: Colors.green.shade700),
            //                     const SizedBox(width: 8),
            //                     const Text(
            //                       'Host Mode: Waiting for clients...',
            //                       style: TextStyle(
            //                         fontWeight: FontWeight.w600,
            //                         color: Colors.green,
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               )
            //             else if (networkService.isDiscovering)
            //               Container(
            //                 padding: const EdgeInsets.all(8),
            //                 margin: const EdgeInsets.only(bottom: 12),
            //                 decoration: BoxDecoration(
            //                   color: Colors.blue.shade100,
            //                   borderRadius: BorderRadius.circular(4),
            //                 ),
            //                 child: Row(
            //                   children: [
            //                     const SizedBox(
            //                       width: 16,
            //                       height: 16,
            //                       child: CircularProgressIndicator(strokeWidth: 2),
            //                     ),
            //                     const SizedBox(width: 8),
            //                     const Text(
            //                       'Discovering devices...',
            //                       style: TextStyle(
            //                         fontWeight: FontWeight.w600,
            //                         color: Colors.blue,
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //
            //             Row(
            //               children: [
            //                 Expanded(
            //                   child: ElevatedButton.icon(
            //                     icon: Icon(networkService.isHost ? Icons.stop : Icons.play_arrow),
            //                     label: Text(networkService.isHost ? 'Stop Host' : 'Start Host'),
            //                     style: ElevatedButton.styleFrom(
            //                       backgroundColor: networkService.isHost
            //                           ? Colors.red
            //                           : Colors.green,
            //                       foregroundColor: Colors.white,
            //                       padding: const EdgeInsets.symmetric(vertical: 12),
            //                     ),
            //                     onPressed: () async {
            //                       try {
            //                         if (networkService.isHost) {
            //                           await networkService.stop();
            //                           if (context.mounted) {
            //                             ScaffoldMessenger.of(context).showSnackBar(
            //                               const SnackBar(content: Text('Host stopped')),
            //                             );
            //                           }
            //                         } else {
            //                           await networkService.startHost();
            //                           if (context.mounted) {
            //                             ScaffoldMessenger.of(context).showSnackBar(
            //                               const SnackBar(
            //                                 content: Text('Host started successfully'),
            //                                 backgroundColor: Colors.green,
            //                               ),
            //                             );
            //                           }
            //                         }
            //                       } catch (e) {
            //                         if (context.mounted) {
            //                           ScaffoldMessenger.of(context).showSnackBar(
            //                             SnackBar(
            //                               content: Text('Error: ${e.toString()}'),
            //                               backgroundColor: Colors.red,
            //                             ),
            //                           );
            //                         }
            //                       }
            //                     },
            //                   ),
            //                 ),
            //                 const SizedBox(width: 12),
            //                 Expanded(
            //                   child: ElevatedButton.icon(
            //                     icon: Icon(networkService.isDiscovering ? Icons.stop : Icons.search),
            //                     label: Text(networkService.isDiscovering ? 'Stop Discovery' : 'Discover'),
            //                     style: ElevatedButton.styleFrom(
            //                       backgroundColor: networkService.isDiscovering
            //                           ? Colors.red
            //                           : Colors.blue,
            //                       foregroundColor: Colors.white,
            //                       padding: const EdgeInsets.symmetric(vertical: 12),
            //                     ),
            //                     onPressed: () async {
            //                       try {
            //                         if (networkService.isDiscovering) {
            //                           await networkService.stop();
            //                           if (context.mounted) {
            //                             ScaffoldMessenger.of(context).showSnackBar(
            //                               const SnackBar(content: Text('Discovery stopped')),
            //                             );
            //                           }
            //                         } else {
            //                           await networkService.startDiscovery();
            //                           if (context.mounted) {
            //                             ScaffoldMessenger.of(context).showSnackBar(
            //                               const SnackBar(
            //                                 content: Text('Discovery started. Grant permissions if prompted.'),
            //                                 backgroundColor: Colors.blue,
            //                               ),
            //                             );
            //                           }
            //                         }
            //                       } catch (e) {
            //                         if (context.mounted) {
            //                           final errorMsg = e.toString();
            //                           final isPermissionDenied = errorMsg.contains('permission') ||
            //                                                      errorMsg.contains('denied');
            //                           ScaffoldMessenger.of(context).showSnackBar(
            //                             SnackBar(
            //                               content: Text(
            //                                 isPermissionDenied
            //                                     ? 'Permission denied. Please grant WiFi permissions in settings.'
            //                                     : 'Error: $errorMsg',
            //                               ),
            //                               backgroundColor: Colors.red,
            //                               duration: const Duration(seconds: 5),
            //                             ),
            //                           );
            //                         }
            //                       }
            //                     },
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ],
            //         ),
            //       ),
            //     );
            //   },
            // ),
            //
            // const SizedBox(height: 24),
            // const Divider(),

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
