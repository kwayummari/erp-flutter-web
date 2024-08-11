import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:erp/src/gateway/salesProductServices.dart';
import 'package:erp/src/screens/saleProducts/topOfSales.dart';
import 'package:erp/src/utils/auth_utils.dart';
import 'package:erp/src/utils/routes/route-names.dart';
import 'package:erp/src/widgets/app-offlineDropdownFormField.dart';
import 'package:erp/src/widgets/app_table4.dart';
import 'package:flutter/rendering.dart';
import 'package:erp/src/gateway/purchaseOrderService.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_button.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:erp/src/screens/models/layout/layout.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class SaleManagement extends StatefulWidget {
  const SaleManagement({super.key});

  @override
  State<SaleManagement> createState() => _SaleManagementState();
}

class _SaleManagementState extends State<SaleManagement> {
  List<Map<String, dynamic>> salesData = [];
  bool isLoading = true;
  bool hasError = false;
  var purchaseId;
  var orderId;
  var supplierId;
  var todayDate;
  var randomNumber;
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

  Future<void> fetchData() async {
    try {
      salesProductServices productListServices = salesProductServices();
      final orderListResponse = await productListServices.getSalesServices(
          context, randomNumber.toString());
      if (orderListResponse != null && orderListResponse['products'] != null) {
        salesData = [];
        totalAmount = 0.0;
        setState(() {
          salesData = [];
          for (var inventory in orderListResponse['products']) {
            double total = double.parse(inventory['buyingPrice']) *
                double.parse(inventory['quantity']);
            totalAmount += total;
            salesData.add({
              'id': inventory['id'].toString(),
              'mainId': inventory['mainId'].toString(),
              'orderedId': inventory['orderedId'].toString(),
              'name': inventory['name'].toString(),
              'description': inventory['description'].toString(),
              'quantity': inventory['quantity'].toString(),
              'price': inventory['buyingPrice'].toString(),
              'total': total.toString(),
            });
          }
          vatAmount = totalAmount * 0.2;
          grandTotal = totalAmount + vatAmount;
          isLoading = false;
        });
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

  Future<void> saveData(randomNumber) async {
    try {
      purchaseOrderServices purchaseOrderService = purchaseOrderServices();
      final purchaseOrderResponse =
          await purchaseOrderService.saveSalesOrder(context, randomNumber);
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  String selectedOption = 'Payment by cash';
  List<String> options = [
    'Payment by cash',
    'Payment by invoice',
    'Payment by card'
  ];

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    todayDate = formatter.format(now);
    Random random = Random();
    randomNumber = random.nextInt(1000000);
  }

  Future<void> _checkLoginStatus() async {
    if (!await isUserLoggedIn()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(RouteNames.login);
      });
    }
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
                  TopOfSales(
                    randomNumber: randomNumber,
                    todayDate: todayDate,
                    refreshSuppliers: refreshSuppliers,
                    fetchSupplier: fetchSupplier,
                    supplierId: supplierId,
                    fetchData: fetchData,
                    fetchData1: fetchData,
                    orderId: orderId,
                    onSupplierChanged: (value) {
                      setState(() {
                        supplierId = value;
                        fetchData();
                      });
                    },
                    purchaseData: salesData,
                  ),
                  Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    child: ReusableTable4(
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
                      url: 'delete_product_sale',
                      data: salesData,
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 230,
                          child: AppDropdownTextFormField(
                            labelText: 'Select Payment Method',
                            options: options,
                            value: selectedOption,
                            onChanged: (newValue) {
                              setState(() {
                                selectedOption = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, bottom: 20),
                        child: Container(
                          height: 50,
                          child: AppButton(
                              solidColor: AppConst.red,
                              onPress: () async {
                                await saveData(randomNumber.toString());
                                setState(() {
                                  supplierId = null;
                                  salesData = [];
                                });
                                _printPage();
                              },
                              label: 'Submit and Print',
                              borderRadius: 20,
                              textColor: AppConst.white),
                        ),
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
