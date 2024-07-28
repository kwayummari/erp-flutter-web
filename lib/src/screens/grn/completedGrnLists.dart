import 'dart:math';
import 'package:erp/src/gateway/grnServices.dart';
import 'package:erp/src/screens/grn/topCompletedGrnList.dart';
import 'package:erp/src/utils/animations/shimmers/dropdown.dart';
import 'package:erp/src/widgets/app_listview_builder.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_text.dart';
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
  bool isLoading = true;
  bool hasError = false;
  var todayDate;
  var randomNumber;
  var purchaseOrderId;
  bool fetchSupplier = false;
  double totalAmount = 0.0;
  double vatAmount = 0.0;
  double grandTotal = 0.0;
  GlobalKey _printKey = GlobalKey();
  List grn = [];

  Future<void> fetchData() async {
    try {
      GrnServices grnService = GrnServices();
      final grnResponse = await grnService.getCompletedGrnList(context);
      print(grnResponse['orders']);
      setState(() {
        isLoading = false;
        grn = grnResponse['orders'];
      });
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
    fetchData();
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
                    onSupplierChanged: (value) {},
                  ),
                  ListTile(
                    tileColor: AppConst.whiteOpacity,
                    title: AppText(
                      txt: 'Supplier Name',
                      size: 20,
                      color: AppConst.black,
                      weight: FontWeight.bold,
                    ),
                    trailing: AppText(
                      txt: 'Number of orders',
                      size: 20,
                      color: AppConst.black,
                      weight: FontWeight.bold,
                    ),
                  ),
                  grn.isEmpty ? dropdownShimmer(width: MediaQuery.of(context).size.width, height: 50, borderRadius: 5.0) : Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    child: AppListviewBuilder(
                      itemnumber: grn.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            elevation: 10,
                            child: ListTile(
                              tileColor: AppConst.whiteOpacity,
                              title: AppText(
                                txt: grn[index]['supplierName'],
                                size: 20,
                                color: AppConst.black,
                                weight: FontWeight.bold,
                              ),
                              subtitle: AppText(
                                txt: grn[index]['date'],
                                size: 15,
                                color: AppConst.black,
                                weight: FontWeight.normal,
                              ),
                              trailing: AppText(
                                txt: grn[index]['inventoryDetails']
                                    .length
                                    .toString(),
                                size: 20,
                                color: AppConst.black,
                                weight: FontWeight.normal,
                              ),
                            ),
                          ),
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
