import 'dart:math';
import 'package:erp/src/gateway/purchaseOrderService.dart';
import 'package:erp/src/provider/table2_notifier.dart';
import 'package:erp/src/screens/purchaseOrder/topOfOrder.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_table2.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:erp/src/screens/models/layout/layout.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class purchaseOrderManagement extends StatefulWidget {
  const purchaseOrderManagement({super.key});

  @override
  State<purchaseOrderManagement> createState() =>
      _purchaseOrderManagementState();
}

class _purchaseOrderManagementState extends State<purchaseOrderManagement> {
  List<Map<String, dynamic>> purchaseData = [];
  bool isLoading = true;
  bool hasError = false;
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

  void refreshSuppliers() {
    setState(() {
      fetchSupplier = !fetchSupplier;
    });
  }

  Future<void> fetchData() async {
    try {
      purchaseOrderServices purchaseOrderService = purchaseOrderServices();
      final purchaseOrderResponse =
          await purchaseOrderService.getPurchaseOrder(context, supplierId);
      if (purchaseOrderResponse != null &&
          purchaseOrderResponse['orders'] != null) {
        purchaseData = [];
        totalAmount = 0.0;
        setState(() {
          orderId = purchaseOrderResponse['orders'][0]['id'].toString();
          purchaseOrderId = purchaseOrderResponse['orders'][0]['orderId'];
          purchaseData = [];
          for (var order in purchaseOrderResponse['orders']) {
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
        for (var order in purchaseOrderResponse['orders']) {
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

  @override
  Widget build(BuildContext context) {
    return layout(
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
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
                TopOfOrder(
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
                  child: ReusableTable2(
                    deleteModalHeight: 300,
                    deleteModalWidth: 500,
                    editModalHeight: 550,
                    editModalWidth: 500,
                    fetchData: fetchData,
                    columnSpacing: 100,
                    titles: titles,
                    cellBuilder: (context, row, title) {
                      return Text(
                          row[title.toLowerCase().replaceAll(' ', '')] ?? '');
                    },
                    onClose: fetchData,
                    url: 'deleteOrder',
                    data: purchaseData,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppText(
                      txt: 'Total: Tsh.${totalAmount.toStringAsFixed(2)}',
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
                      txt: 'VAT (20%): Tsh.${vatAmount.toStringAsFixed(2)}',
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
                      txt: 'Grand Total: Tsh.${grandTotal.toStringAsFixed(2)}',
                      size: 15,
                      weight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
