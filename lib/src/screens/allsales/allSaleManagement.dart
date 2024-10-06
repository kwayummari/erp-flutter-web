import 'dart:convert';

import 'package:erp/src/gateway/salesProductServices.dart';
import 'package:erp/src/screens/allsales/itemSales.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/utils/auth_utils.dart';
import 'package:erp/src/utils/routes/route-names.dart';
import 'package:erp/src/widgets/app_button.dart';
import 'package:erp/src/widgets/app_listTile.dart';
import 'package:erp/src/widgets/app_listview_builder.dart';
import 'package:erp/src/widgets/app_modal.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:erp/src/screens/models/layout/layout.dart';
import 'package:go_router/go_router.dart';

class AllSalesManagement extends StatefulWidget {
  const AllSalesManagement({super.key});

  @override
  State<AllSalesManagement> createState() => _AllSalesManagementState();
}

class _AllSalesManagementState extends State<AllSalesManagement> {
  List<Map<String, dynamic>> salesData = [];
  bool isLoading = true;
  bool hasError = false;
  List sales = [];
  List salesItems = [];

  Future<void> fetchData() async {
    try {
      salesProductServices productListServices = salesProductServices();
      final orderListResponse =
          await productListServices.getAllSalesServices(context);
      setState(() {
        sales = orderListResponse['sales'];
        isLoading = false;
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
    _checkLoginStatus();
    fetchData();
  }

  Future<void> _checkLoginStatus() async {
    if (!await isUserLoggedIn()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(RouteNames.login);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return layout(
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? const Center(child: Text('Error loading data'))
              : sales.isEmpty
                  ? const Center(child: Text('No sales data available'))
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 700,
                        child: AppListviewBuilder(
                          itemnumber: sales.length,
                          direction: Axis.vertical,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Material(
                                elevation: 4,
                                child: AppListTile(
                                  title: AppText(
                                    txt:
                                        'Receipt No: ${sales[index]['receiptNo']}',
                                    size: 20,
                                    color: AppConst.black,
                                    weight: FontWeight.bold,
                                  ),
                                  subTitle: Row(
                                    children: [
                                      AppText(
                                        txt:
                                            'Payment Method: ${sales[index]['method']} ',
                                        size: 15,
                                      ),
                                      AppText(
                                        txt:
                                            sales[index]['paymentStatus'] == '1'
                                                ? ' (Paid)'
                                                : ' (Not paid)',
                                        size: 15,
                                        color: sales[index]['paymentStatus'] ==
                                                '1'
                                            ? Colors.green
                                            : Colors
                                                .red,
                                        weight: FontWeight
                                            .bold,
                                      ),
                                    ],
                                  ),
                                  trailing: Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Container(
                                      height: 50,
                                      child: AppButton(
                                        onPress: () {
                                          var salesItems =
                                              sales[index]['salesItems'];
                                          if (salesItems is String) {
                                            if (!salesItems.startsWith('[')) {
                                              salesItems = '[$salesItems]';
                                            }
                                            salesItems = jsonDecode(salesItems);
                                          }
                                          ReusableModal.show(
                                            width: 500,
                                            height: 600,
                                            context,
                                            AppText(
                                                txt: 'View details',
                                                size: 22,
                                                weight: FontWeight.bold),
                                            onClose: fetchData,
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                ItemSales(
                                                  sales: salesItems,
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                        label: 'View details',
                                        borderRadius: 5,
                                        textColor: AppConst.white,
                                        gradient: AppConst.primaryGradient,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
    );
  }
}