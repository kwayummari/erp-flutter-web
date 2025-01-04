import 'package:erp/src/screens/models/layout/layout.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Receipt extends StatefulWidget {
  final String company;
  final String amount;
  final String recipientName;
  final String senderName;
  final String phoneNumber;
  final List<Map<String, dynamic>>? products;

  Receipt({
    Key? key,
    required this.company,
    required this.amount,
    required this.recipientName,
    required this.senderName,
    required this.phoneNumber,
    this.products,
  }) : super(key: key);

  @override
  State<Receipt> createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> printReceipt(double subtotal, double vat, double total) async {
    print('Printing receipt');
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.nunitoRegular();
  final boldFont = await PdfGoogleFonts.nunitoBold();

    // Get the display products at the start
    List<Map<String, dynamic>> displayProducts = widget.products ?? [];

    pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Column(
          children: [
            // Header
            pw.Text(
              widget.company,
              style: pw.TextStyle(
                font: boldFont,
                fontSize: 24,
              ),
            ),
            pw.Text('TIN: 123-456-789', style: pw.TextStyle(font: font)),
            pw.Text('P.O. Box 11111, Dar es Salaam', style: pw.TextStyle(font: font)),
            pw.Text('Tel: ${widget.phoneNumber}', style: pw.TextStyle(font: font)),
            
            pw.Divider(),
            pw.Text(
              'TAX INVOICE/RECEIPT',
              style: pw.TextStyle(font: boldFont),
            ),
            pw.Text('Receipt No: EFD-123456789', style: pw.TextStyle(font: font)),
            pw.Text('Date: ${DateTime.now().toString().split(' ')[0]}', 
              style: pw.TextStyle(font: font)),
            pw.Divider(),

            // Customer Details
            pw.Container(
              alignment: pw.Alignment.centerLeft,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Customer: ${widget.recipientName}', 
                    style: pw.TextStyle(font: font)),
                  pw.Text('Phone: ${widget.phoneNumber}', 
                    style: pw.TextStyle(font: font)),
                ],
              ),
            ),
            pw.SizedBox(height: 24),

            // Products Table
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: pw.FlexColumnWidth(3),
                1: pw.FlexColumnWidth(1),
                2: pw.FlexColumnWidth(2),
                3: pw.FlexColumnWidth(2),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Text('Item', style: pw.TextStyle(font: boldFont)),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Text('Qty', style: pw.TextStyle(font: boldFont)),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Text('Price', style: pw.TextStyle(font: boldFont)),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Text('Total', style: pw.TextStyle(font: boldFont)),
                    ),
                  ],
                ),
                ...widget.products?.map((product) => pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Text(product['name'].toString(), 
                        style: pw.TextStyle(font: font)),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Text(product['qty'].toString(), 
                        style: pw.TextStyle(font: font)),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Text(product['price'].toString(), 
                        style: pw.TextStyle(font: font)),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Text(
                        (int.tryParse(product['price'].toString()) ?? 0 * 
                         product['qty']).toString(),
                        style: pw.TextStyle(font: font),
                      ),
                    ),
                  ],
                )).toList() ?? [],
              ],
            ),

            // Totals
            pw.SizedBox(height: 24),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Subtotal:', style: pw.TextStyle(font: font)),
                pw.Text('TZS ${subtotal.toStringAsFixed(2)}', 
                  style: pw.TextStyle(font: font)),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('VAT (18%):', style: pw.TextStyle(font: font)),
                pw.Text('TZS ${vat.toStringAsFixed(2)}', 
                  style: pw.TextStyle(font: font)),
              ],
            ),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Total:', style: pw.TextStyle(font: boldFont)),
                pw.Text('TZS ${total.toStringAsFixed(2)}', 
                  style: pw.TextStyle(font: boldFont)),
              ],
            ),

            // Footer
            pw.SizedBox(height: 24),
            pw.Text('Thank you for your business!', 
              style: pw.TextStyle(font: font)),
            pw.Text('This is a valid tax invoice/receipt',
              style: pw.TextStyle(font: font, fontSize: 12)),
            pw.Text('Powered by EFD System',
              style: pw.TextStyle(font: font, fontSize: 12)),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> displayProducts = widget.products ?? [];
    double subtotal = displayProducts.fold(0, (sum, item) {
      int price = int.tryParse(item['price'].toString()) ?? 0;
      int qty = int.tryParse(item['qty'].toString()) ?? 0;
      return sum + (price * qty);
    });

    double vat = subtotal * 0.18; // 18% VAT
    double total = subtotal + vat;
    return layout(
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Card(
                margin: EdgeInsets.all(16),
                child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Header
                        Text(
                          widget.company,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text('TIN: 123-456-789'),
                        Text('P.O. Box 11111, Dar es Salaam'),
                        Text('Tel: ${widget.phoneNumber}'),

                        Divider(height: 32),
                        Text(
                          'TAX INVOICE/RECEIPT',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Receipt No: EFD-123456789'),
                        Text(
                            'Date: ${DateTime.now().toString().split(' ')[0]}'),
                        Divider(height: 32),

                        // Customer Details
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Customer: ${widget.recipientName}'),
                              Text('Phone: ${widget.phoneNumber}'),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),

                        Table(
                          border: TableBorder.all(),
                          columnWidths: {
                            0: FlexColumnWidth(3),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(2),
                            3: FlexColumnWidth(2),
                          },
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                    child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('Item'),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('Qty'),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('Price'),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('Total'),
                                )),
                              ],
                            ),
                            ...displayProducts
                                .map((product) => TableRow(
                                      children: [
                                        TableCell(
                                            child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child:
                                              Text(product['name'].toString()),
                                        )),
                                        TableCell(
                                            child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child:
                                              Text(product['qty'].toString()),
                                        )),
                                        TableCell(
                                            child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child:
                                              Text(product['price'].toString()),
                                        )),
                                        TableCell(
                                            child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child:
                                              Text(product['total'].toString()),
                                        )),
                                      ],
                                    ))
                                .toList(),
                          ],
                        ),
                        SizedBox(height: 24),

                        // Totals
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Subtotal:'),
                            Text('TZS ${subtotal.toStringAsFixed(2)}'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('VAT (18%):'),
                            Text('TZS ${vat.toStringAsFixed(2)}'),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('TZS ${total.toStringAsFixed(2)}',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),

                        // Footer
                        SizedBox(height: 24),
                        Text('Thank you for your business!'),
                        Text('This is a valid tax invoice/receipt',
                            style: TextStyle(fontSize: 12)),
                        Text('Powered by EFD System',
                            style: TextStyle(fontSize: 12)),
                      ],
                    ))),
            Positioned(
              bottom: 32,
              right: 32,
              child: FloatingActionButton.extended(
                onPressed: () => printReceipt(subtotal, vat, total),
                icon: Icon(Icons.print),
                label: Text('Print Receipt'),
                backgroundColor: AppConst.primary,
              ),
            )
          ],
        ),
      ),
    );
  }
}
