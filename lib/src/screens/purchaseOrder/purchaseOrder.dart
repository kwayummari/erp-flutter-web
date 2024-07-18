import 'dart:math';
import 'package:erp/src/gateway/purchaseOrderService.dart';
import 'package:erp/src/provider/table2_notifier.dart';
import 'package:erp/src/screens/purchaseOrder/topOfOrder.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_table2.dart';
import 'package:flutter/material.dart';
import 'package:erp/src/screens/models/layout/layout.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Import provider

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
  var supplierId;
  var todayDate;
  var randomNumber;
  bool fetchSupplier = false;
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
        setState(() {
          purchaseData = [];
          for (var order in purchaseOrderResponse['orders']) {
            for (var inventory in order['inventoryDetails']) {
              purchaseData.add({
                'id': inventory['id'].toString(),
                'name': inventory['name'].toString(),
                'description': inventory['description'].toString(),
                'quantity': inventory['quantity'].toString(),
                'price': inventory['buyingPrice'].toString(),
                'total': (int.parse(inventory['buyingPrice']) *
                        int.parse(inventory['quantity']))
                    .toString(),
              });
            }
          }
          isLoading = false;
        });
        final tableDataNotifier =
            Provider.of<TableDataNotifier>(context, listen: false);
        tableDataNotifier.data.clear();
        for (var order in purchaseOrderResponse['orders']) {
          for (var inventory in order['inventoryDetails']) {
            tableDataNotifier.addNewRow({
              'id': inventory['id'].toString(),
              'name': inventory['name'].toString(),
              'description': inventory['description'].toString(),
              'quantity': inventory['quantity'].toString(),
              'price': inventory['buyingPrice'].toString(),
              'total': (int.parse(inventory['buyingPrice']) *
                      int.parse(inventory['quantity']))
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
                  onSupplierChanged: (value) {
                    setState(() {
                      supplierId = value;
                      fetchData();
                    });
                  },
                  purchaseData: purchaseData,
                ),
                Container(
                  height: 300,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
