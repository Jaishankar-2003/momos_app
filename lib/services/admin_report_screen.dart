import 'package:flutter/material.dart';
import 'admin_report_pdf.dart';
import '../services/db_helper.dart';

class AdminReportScreen extends StatefulWidget {
  const AdminReportScreen({super.key});

  @override
  State<AdminReportScreen> createState() => _AdminReportScreenState();
}

class _AdminReportScreenState extends State<AdminReportScreen> {
  final service = AdminReportPdfService();

  double? _totalToday;
  Map<String, int>? _topItems;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReportData();
  }

  Future<void> _fetchReportData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final total = await DBHelper.instance.totalSalesToday();
      final items = await DBHelper.instance.todayItemSales();
      setState(() {
        _totalToday = total;
        _topItems = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching report data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Report')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: const Text('👀 View PDF'),
                    onPressed: () async {
                      if (_totalToday == null || _topItems == null) return;
                      final bytes = await service.generatePdf(
                        totalToday: _totalToday!,
                        topItems: _topItems!,
                      );
                      await service.viewPdf(bytes);
                    },
                  ),
                  ElevatedButton(
                    child: const Text('📤 Share PDF'),
                    onPressed: () async {
                      if (_totalToday == null || _topItems == null) return;
                      final bytes = await service.generatePdf(
                        totalToday: _totalToday!,
                        topItems: _topItems!,
                      );
                      await service.sharePdf(bytes);
                    },
                  ),
                  ElevatedButton(
                    child: const Text('📂 Save to Downloads'),
                    onPressed: () async {
                      if (_totalToday == null || _topItems == null) return;
                      final bytes = await service.generatePdf(
                        totalToday: _totalToday!,
                        topItems: _topItems!,
                      );
                      await service.savePdfWithPicker(bytes);
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
