import 'dart:math';
import 'package:erp/src/gateway/purchaseOrderService.dart';
import 'package:erp/src/screens/purchaseOrder/topOfOrder.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_table2.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:erp/src/screens/models/layout/layout.dart';
import 'package:intl/intl.dart';

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
        setState(() {
          purchaseData = [];
          for (var order in purchaseOrderResponse['orders']) {
            for (var inventory in order['inventoryDetails']) {
              purchaseData.add({
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
    Random random = new Random();
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
                  purchaseData: purchaseData,
                  supplierId: supplierId,
                  fetchData: fetchData,
                  fetchData1: fetchData,
                  onSupplierChanged: (value) {
                    setState(() {
                      supplierId = value;
                    });
                  },
                ),
                Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  child: ReusableTable2(
                    deleteModalHeight: 300,
                    deleteModalWidth: 500,
                    editModalHeight: 550,
                    editModalWidth: 500,
                    editStatement: AppText(
                        txt: 'Edit user', size: 18, weight: FontWeight.bold),
                    fetchData: fetchData,
                    columnSpacing: 100,
                    titles: titles,
                    data: purchaseData,
                    cellBuilder: (context, row, title) {
                      return Text(
                          row[title.toLowerCase().replaceAll(' ', '')] ?? '');
                    },
                    onClose: fetchData,
                    deleteStatement: AppText(
                        txt: 'Are you sure you want to delete this user?',
                        size: 18,
                        weight: FontWeight.bold),
                    url: 'deleteUserById',
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
