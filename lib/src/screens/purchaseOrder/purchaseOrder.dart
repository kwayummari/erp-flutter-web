import 'dart:math';
import 'package:erp/src/gateway/purchaseOrderService.dart';
import 'package:erp/src/screens/supplier/addSupplier.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app-dropdown.dart';
import 'package:erp/src/widgets/app_button.dart';
import 'package:erp/src/widgets/app_modal.dart';
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
            for (var inventoryList in order['inventoryDetails']) {
              for (var inventory in inventoryList) {
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
      print('Error fetching data: $e');
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/logo.png',
                    width: 100,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: AppText(
                    txt: 'JamSolutions,',
                    size: 15,
                    color: AppConst.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: AppText(
                    txt: 'Dar Es Salaam,',
                    size: 15,
                    color: AppConst.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: AppText(
                    txt: '+255 762 996 305',
                    size: 15,
                    color: AppConst.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 40, bottom: 20),
                  child: AppText(
                    txt: 'Purchase Order',
                    size: 25,
                    color: AppConst.black,
                    weight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 400,
                      child: DropdownTextFormField(
                        fetchSupplier: fetchSupplier,
                        refreshSuppliers: refreshSuppliers,
                        labelText: 'Select Supplier',
                        fillcolor: AppConst.white,
                        apiUrl: 'suppliers',
                        textsColor: AppConst.black,
                        dropdownColor: AppConst.white,
                        dataOrigin: 'suppliers',
                        onChanged: (value) {
                          purchaseData = [];
                          setState(() {
                            supplierId = value.toString();
                          });
                          fetchData();
                        },
                        valueField: 'id',
                        displayField: 'name',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Container(
                        height: 50,
                        child: AppButton(
                          onPress: () {
                            ReusableModal.show(
                              width: 500,
                              height: 550,
                              context,
                              AppText(
                                  txt: 'Add Supplier',
                                  size: 22,
                                  weight: FontWeight.bold),
                              onClose: fetchData,
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  addSupplierForm(fetchData: fetchData, refreshSuppliers: refreshSuppliers)
                                ],
                              ),
                              footer: AppButton(
                                  onPress: () {
                                    Navigator.pop(context);
                                  },
                                  solidColor: AppConst.black,
                                  label: 'Cancel',
                                  borderRadius: 5,
                                  textColor: AppConst.white),
                            );
                            refreshSuppliers();
                          },
                          label: 'Add Supplier',
                          borderRadius: 8,
                          textColor: AppConst.white,
                          solidColor: AppConst.black,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                      child: AppText(
                        txt: 'Purchase Order #${randomNumber}',
                        size: 20,
                        color: AppConst.black,
                        weight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 20, top: 20, bottom: 20),
                      child: AppText(
                        txt: 'Date: ${todayDate}',
                        size: 20,
                        color: AppConst.black,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ],
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
