
/*

import 'dart:convert';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../models/order.dart';

class PDFService {
  Future<void> generateAndPrint(OrderModel order) async {
    try {
      final pdf = pw.Document();
      final items = jsonDecode(order.itemsJson) as List<dynamic>;

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return [
              pw.Header(
                level: 0,
                child: pw.Text(
                  "Mallang's Momos",
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text('Invoice ID: ${order.id ?? "N/A"}'),
              pw.Text('Date: ${order.date}  Time: ${order.time}'),
              pw.SizedBox(height: 12),
              pw.TableHelper.fromTextArray(
                headers: const ['Item', 'Qty', 'Price', 'Total'],
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                data: items.map((item) {
                  final name = item['name'] as String? ?? 'Unknown Item';
                  final qty = (item['qty'] as num?)?.toInt() ?? 0;
                  final price = (item['price'] as num?)?.toDouble() ?? 0.0;
                  final total = qty * price;
                  return [
                    name,
                    qty.toString(),
                    '₹${price.toStringAsFixed(2)}',
                    '₹${total.toStringAsFixed(2)}',
                  ];
                }).toList(),
              ),
              pw.SizedBox(height: 12),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Total: ₹${order.total.toStringAsFixed(2)}',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Text('Thank you for your business!'),
            ];
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      throw Exception('Failed to generate and print PDF: $e');
    }
  }

  Future<void> generateAndSharePdf(OrderModel order) async {
    try {
      final pdf = pw.Document();
      final items = jsonDecode(order.itemsJson) as List<dynamic>;

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Text(
                "Mallang's Momos",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Text('Date: ${order.date} ${order.time}'),
            pw.SizedBox(height: 8),
            pw.TableHelper.fromTextArray(
              headers: const ['Item', 'Qty', 'Price', 'Total'],
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              data: items.map((item) {
                final name = item['name'] as String? ?? 'Unknown Item';
                final qty = (item['qty'] as num?)?.toInt() ?? 0;
                final price = (item['price'] as num?)?.toDouble() ?? 0.0;
                final total = qty * price;
                return [
                  name,
                  qty.toString(),
                  '₹${price.toStringAsFixed(2)}',
                  '₹${total.toStringAsFixed(2)}',
                ];
              }).toList(),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              'Total: ₹${order.total.toStringAsFixed(2)}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
      );

      final bytes = await pdf.save();
      await Printing.sharePdf(
        bytes: bytes,
        filename:
            'invoice_${order.id ?? DateTime.now().millisecondsSinceEpoch}.pdf',
      );
    } catch (e) {
      throw Exception('Failed to generate and share PDF: $e');
    }
  }
}

 */

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' show PdfPageFormat;
import 'package:pdf/widgets.dart' as pw;
import '../models/order.dart';

class PDFService {
  Future<void> generateAndSavePdf(OrderModel order) async {
    try {
      final pdf = pw.Document();
      final items = jsonDecode(order.itemsJson) as List<dynamic>;

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Text(
                "Mallang's Momos",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Text(
              "Customer: ${order.customerName}",
              style: pw.TextStyle(
                fontSize: 18,           // ✅ increase font size
                fontWeight: pw.FontWeight.bold,  // ✅ make it bold
              ),
            ),
            pw.Text("Invoice ID: ${order.id ?? 'N/A'}"),
            pw.Text("Date: ${order.date}   Time: ${order.time}"),
            pw.SizedBox(height: 10),

            pw.TableHelper.fromTextArray(
              headers: const ['Item', 'Qty', 'Price', 'Total'],
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              data: items.map((item) {
                final qty = (item['qty'] as num?)?.toInt() ?? 0;
                final price = (item['price'] as num?)?.toDouble() ?? 0.0;
                final total = qty * price;

                return [
                  item['name'],
                  qty.toString(),
                  "Rs : ${price.toStringAsFixed(2)}",
                  "Rs : ${total.toStringAsFixed(2)}"
                ];
              }).toList(),
            ),

            pw.SizedBox(height: 20),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                "TOTAL: Rs : ${order.total.toStringAsFixed(2)}",
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
            ),
          ],
        ),
      );

      // SAVE TO DOWNLOADS FOLDER
      Directory? dir;
      if (Platform.isAndroid) {
        dir = Directory("/storage/emulated/0/Download");
      } else {
        dir = await getDownloadsDirectory();
      }

      if (!await dir!.exists()) {
        await dir.create(recursive: true);
      }

//       final safeTime = order.time.replaceAll(":", "-");
//       final filePath = "${dir.path}/invoice_${order.date}_$safeTime.pdf";
//
//       final file = File(filePath);
//       await file.writeAsBytes(await pdf.save());
//
//       print("PDF saved at: $filePath");
//     } catch (e) {
//       throw Exception("Failed to save invoice PDF: $e");
//     }
//   }
// }
      // Safe customer name for filename
      final safeCustomerName = order.customerName
          .replaceAll(RegExp(r'[^\w\s-]'), '') // remove special chars
          .replaceAll(' ', '_');               // replace spaces with underscores

      // Safe time for filename
      final safeTime = order.time.replaceAll(":", "-");

      // Final file path including customer name
      final filePath = "${dir.path}/${safeCustomerName}_${order.date}_${safeTime}.pdf";

      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      print("PDF saved at: $filePath");
    } catch (e) {
      throw Exception("Failed to save invoice PDF: $e");
    }
  }
}







