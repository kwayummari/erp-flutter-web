import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:erp/src/gateway/grnServices.dart';
import 'package:erp/src/screens/grn/topGrn.dart';
import 'package:erp/src/widgets/app_table3.dart';
import 'package:flutter/rendering.dart';
import 'package:erp/src/gateway/purchaseOrderService.dart';
import 'package:erp/src/provider/table2_notifier.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_button.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:erp/src/screens/models/layout/layout.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

class GrnManagement extends StatefulWidget {
  const GrnManagement({super.key});

  @override
  State<GrnManagement> createState() => _GrnManagementState();
}

class _GrnManagementState extends State<GrnManagement> {
  List<Map<String, dynamic>> purchaseData = [];
  bool isLoading = true;
  bool hasError = false;
  var purchaseId;
  var orderId;
  var supplierId;
  var todayDate;
  var randomNumber;
  var purchaseOrderId;
  bool fetchSupplier = false;
  double totalAmount = 0.0;
  double vatAmount = 0.0;
  double grandTotal = 0.0;
  final List<String> titles = [
    'Name',
    'Description',
    'Quantity',
    'Price',
    'Total',
  ];
  GlobalKey _printKey = GlobalKey();

  void refreshSuppliers() {
    setState(() {
      fetchSupplier = !fetchSupplier;
    });
  }

  var branchId;
  Future<void> fetchData() async {
    try {
      GrnServices grnService = GrnServices();
      final grnResponse = await grnService.getGrn(context, supplierId);
      setState(() {
        purchaseId = grnResponse['orders'][0]['id'];
        branchId = grnResponse['orders'][0]['branchDetails']['id'];
      });
      if (grnResponse != null && grnResponse['orders'] != null) {
        purchaseData = [];
        totalAmount = 0.0;
        setState(() {
          orderId = grnResponse['orders'][0]['id'].toString();
          purchaseOrderId = grnResponse['orders'][0]['orderId'];
          purchaseData = [];
          for (var order in grnResponse['orders']) {
            for (var inventory in order['inventoryDetails']) {
              double total = double.parse(inventory['buyingPrice']) *
                  double.parse(inventory['quantity']);
              totalAmount += total;
              purchaseData.add({
                'id': inventory['id'].toString(),
                'orderedId': inventory['orderedId'].toString(),
                'name': inventory['name'].toString(),
                'description': inventory['description'].toString(),
                'quantity': inventory['quantity'].toString(),
                'price': inventory['buyingPrice'].toString(),
                'total': total.toString(),
                'quantity_received': inventory['quantity_received'].toString(),
              });
            }
          }
          vatAmount = totalAmount * 0.2;
          grandTotal = totalAmount + vatAmount;
          isLoading = false;
        });
        final tableDataNotifier =
            Provider.of<TableDataNotifier>(context, listen: false);
        tableDataNotifier.data.clear();
        for (var order in grnResponse['orders']) {
          for (var inventory in order['inventoryDetails']) {
            tableDataNotifier.addNewRow({
              'id': inventory['id'].toString(),
              'orderedId': inventory['orderedId'].toString(),
              'name': inventory['name'].toString(),
              'description': inventory['description'].toString(),
              'quantity': inventory['quantity'].toString(),
              'price': inventory['buyingPrice'].toString(),
              'total': (double.parse(inventory['buyingPrice']) *
                      double.parse(inventory['quantity']))
                  .toString(),
              'quantity_received': inventory['quantity_received'].toString(),
            });
          }
        }
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> saveData(purchaseId, supplierId) async {
    try {
      purchaseOrderServices purchaseOrderService = purchaseOrderServices();
      final grnResponse = await purchaseOrderService.savePurchaseOrder(
          context, purchaseId, supplierId, branchId, '2');
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (supplierId != null) fetchData();
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    todayDate = formatter.format(now);
    Random random = Random();
    randomNumber = random.nextInt(1000000);
  }

  Future<void> _showComingSoonPopup() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppConst.black,
          title: AppText(
            txt: 'Coming Soon',
            size: 15,
            color: AppConst.white,
          ),
          content: AppText(
            txt: 'This feature is coming soon.',
            size: 15,
            color: AppConst.white,
          ),
          actions: <Widget>[
            TextButton(
              child: AppText(
                txt: 'OK',
                size: 15,
                color: AppConst.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _printPage() async {
    try {
      RenderRepaintBoundary boundary =
          _printKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        final pdf = pw.Document();
        final imageBytes = byteData.buffer.asUint8List();
        final pdfImage = pw.MemoryImage(imageBytes);
        pdf.addPage(pw.Page(
            build: (pw.Context context) => pw.Center(
                  child: pw.Image(pdfImage),
                )));
        await Printing.layoutPdf(
            onLayout: (PdfPageFormat format) async => pdf.save());
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return layout(
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: RepaintBoundary(
            key: _printKey,
            child: Container(
              width: MediaQuery.of(context).size.width - 400,
              height: MediaQuery.of(context).size.height - 200,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: AppConst.grey100,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.black),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(4, 4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TopGrn(
                    randomNumber: randomNumber,
                    todayDate: todayDate,
                    refreshSuppliers: refreshSuppliers,
                    fetchSupplier: fetchSupplier,
                    supplierId: supplierId,
                    fetchData: fetchData,
                    fetchData1: fetchData,
                    orderId: orderId,
                    purchaseOrderId: purchaseOrderId,
                    onSupplierChanged: (value) {
                      setState(() {
                        supplierId = value;
                        fetchData();
                      });
                    },
                    purchaseData: purchaseData,
                  ),
                  Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    child: ReusableTable3(
                      fetchData1: fetchData,
                      orderId: orderId,
                      supplierId: supplierId,
                      deleteModalHeight: 300,
                      deleteModalWidth: 500,
                      editModalHeight: 550,
                      editModalWidth: 500,
                      fetchData: fetchData,
                      columnSpacing: 100,
                      titles: titles,
                      randomNumber: randomNumber.toString(),
                      cellBuilder: (context, row, title) {
                        return Text(
                            row[title.toLowerCase().replaceAll(' ', '')] ?? '');
                      },
                      onClose: fetchData,
                      url: 'deleteOrder',
                      data: purchaseData,
                      enabled: true,
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppButton(
                            solidColor: AppConst.primary,
                            onPress: _showComingSoonPopup,
                            label: 'Send Email',
                            borderRadius: 5,
                            textColor: AppConst.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppButton(
                            solidColor: AppConst.red,
                            onPress: () async {
                              await saveData(
                                  purchaseId.toString(), supplierId.toString());
                              setState(() {
                                supplierId = null;
                              });
                              await fetchData();
                            },
                            label: 'Save',
                            borderRadius: 5,
                            textColor: AppConst.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppButton(
                            solidColor: AppConst.black,
                            onPress: _printPage,
                            label: 'Print',
                            borderRadius: 5,
                            textColor: AppConst.white),
                      ),
                      Spacer(),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AppText(
                                txt:
                                    'Total: Tsh.${totalAmount.toStringAsFixed(2)}',
                                size: 15,
                                weight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AppText(
                                txt:
                                    'VAT (20%): Tsh.${vatAmount.toStringAsFixed(2)}',
                                size: 15,
                                weight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AppText(
                                txt:
                                    'Grand Total: Tsh.${grandTotal.toStringAsFixed(2)}',
                                size: 15,
                                weight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
