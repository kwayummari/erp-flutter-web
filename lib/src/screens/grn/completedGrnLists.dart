import 'dart:math';
import 'package:erp/src/screens/grn/topCompletedGrn.dart';
import 'package:erp/src/screens/grn/topCompletedGrnList.dart';
import 'package:erp/src/widgets/app_listview_builder.dart';
import 'package:erp/src/gateway/purchaseOrderService.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:erp/src/screens/models/layout/layout.dart';
import 'package:intl/intl.dart';

class CompletedGrnListsManagement extends StatefulWidget {
  const CompletedGrnListsManagement({super.key});

  @override
  State<CompletedGrnListsManagement> createState() =>
      _CompletedGrnListsManagementState();
}

class _CompletedGrnListsManagementState
    extends State<CompletedGrnListsManagement> {
  List<Map<String, dynamic>> purchaseData = [];
  bool isLoading = true;
  bool hasError = false;
  var purchaseId;
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

  Future<void> saveData(purchaseId, supplierId) async {
    try {
      purchaseOrderServices purchaseOrderService = purchaseOrderServices();
      final grnResponse = await purchaseOrderService.savePurchaseOrder(
          context, purchaseId, supplierId, '2');
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
                  TopCompletedGrnList(
                    randomNumber: randomNumber,
                    todayDate: todayDate,
                    refreshSuppliers: refreshSuppliers,
                    fetchSupplier: fetchSupplier,
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
                    child: AppListviewBuilder(
                      itemnumber: 10,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('Item $index'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
