import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// class AdminReportPDF {
//   Future<void> generateAndSave({
//     required double totalToday,
//     required Map<String, int> topItems,
//   }) async {
//     final pdf = pw.Document();
//     final now = DateTime.now();
//
//     final date =
//         "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day
//         .toString().padLeft(2, '0')}";
//
//     pdf.addPage(
//       pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         build: (context) =>
//         [
//           pw.Header(
//             level: 0,
//             child: pw.Text(
//               "Mallang's Momos - Admin Report",
//               style: pw.TextStyle(
//                 fontSize: 22,
//                 fontWeight: pw.FontWeight.bold,
//               ),
//             ),
//           ),
//
//           pw.Text("Report Date: $date"),
//           pw.SizedBox(height: 16),
//
//           // Total Sales
//           pw.Container(
//             padding: const pw.EdgeInsets.all(12),
//             decoration: pw.BoxDecoration(
//               border: pw.Border.all(),
//             ),
//             child: pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.Text(
//                   "Total Sales Today",
//                   style: pw.TextStyle(fontSize: 16),
//                 ),
//                 pw.Text(
//                   "₹${totalToday.toStringAsFixed(2)}",
//                   style: pw.TextStyle(
//                     fontSize: 18,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           pw.SizedBox(height: 20),
//
//           pw.Text(
//             "Top Selling Items",
//             style: pw.TextStyle(
//               fontSize: 16,
//               fontWeight: pw.FontWeight.bold,
//             ),
//           ),
//           pw.SizedBox(height: 8),
//
//           topItems.isEmpty
//               ? pw.Text("No data available")
//               : pw.Table.fromTextArray(
//             headers: const ['Item Name', 'Quantity Sold'],
//             headerStyle:
//             pw.TextStyle(fontWeight: pw.FontWeight.bold),
//             data: topItems.entries
//                 .map((e) => [e.key, e.value.toString()])
//                 .toList(),
//           ),
//         ],
//       ),
//     );
//
//     final bytes = await pdf.save();
//
//     // ✅ ANDROID SAFE DIRECTORY (NULL-SAFE)
//     Directory? dir;
//
//     if (Platform.isAndroid) {
//       dir = await getExternalStorageDirectory();
//     } else {
//       dir = await getDownloadsDirectory() ??
//           await getApplicationDocumentsDirectory();
//     }
//
//     if (dir == null) {
//       throw Exception("Storage directory not available");
//     }
//
//     if (!await dir.exists()) {
//       await dir.create(recursive: true);
//     }
//
//     // ✅ UNIQUE FILE NAME
//     final timestamp = DateTime.now().millisecondsSinceEpoch;
//     final filePath =
//         '${dir.path}/Admin_Report_${date}_$timestamp.pdf';
//
//     final file = File(filePath);
//     await file.writeAsBytes(bytes, flush: true);
//
//
//     // ✅ THIS IS INSIDE try
//     print('✅ Admin report saved at: $filePath');
//
//   } catch (e) {
//   // ✅ catch is directly after try
//   print('❌ Failed to save admin report PDF: $e');
//   }
//
// }

//============================================================================================================================================

class AdminReportPdfService {
  // 1️⃣ Generate PDF
  Future<Uint8List> generatePdf({
    required double totalToday,
    required Map<String, int> topItems,
  }) async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final date =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (_) => [
          pw.Text(
            "Mallang's Momos - Admin Report",
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 20),
          pw.Text("Report Date: $date"),
          pw.SizedBox(height: 16),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(border: pw.Border.all()),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Total Sales Today", style: pw.TextStyle(fontSize: 16)),
                pw.Text(
                  "₹${totalToday.toStringAsFixed(2)}",
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            "Top Selling Items",
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          topItems.isEmpty
              ? pw.Text("No data available")
              : pw.Table.fromTextArray(
                  headers: const ['Item Name', 'Quantity Sold'],
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  data: topItems.entries
                      .map((e) => [e.key, e.value.toString()])
                      .toList(),
                ),
        ],
      ),
    );

    return pdf.save();
  }

  // 2️⃣ View PDF
  Future<void> viewPdf(Uint8List bytes) async {
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => bytes);
  }

  // 3️⃣ Share PDF
  Future<void> sharePdf(Uint8List bytes) async {
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'Admin_Report_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  // 4️⃣ Save to Downloads
  Future<void> savePdfWithPicker(Uint8List bytes) async {
    Directory? dir;

    if (Platform.isAndroid) {
      dir = await getExternalStorageDirectory();
    } else {
      dir =
          await getDownloadsDirectory() ??
          await getApplicationDocumentsDirectory();
    }

    if (dir == null) {
      throw Exception("Storage directory not available");
    }

    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final fileName =
        'Admin_Report_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final filePath = '${dir.path}/$fileName';
    final file = File(filePath);

    await file.writeAsBytes(bytes, flush: true);
  }

  // 5️⃣ Generate and Save (for compatibility with admin_dashboard)
  Future<void> generateAndSave({
    required double totalToday,
    required Map<String, int> topItems,
  }) async {
    final bytes = await generatePdf(totalToday: totalToday, topItems: topItems);
    await savePdfWithPicker(bytes);
  }
}

// Alias for backward compatibility
class AdminReportPDF extends AdminReportPdfService {}
