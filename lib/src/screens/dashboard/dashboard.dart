import 'package:erp/src/gateway/DashboardService.dart';
import 'package:erp/src/screens/dashboard/bestSuppliers.dart';
import 'package:erp/src/screens/dashboard/mostSoldProducts.dart';
import 'package:erp/src/screens/models/layout/layout.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class dashboard extends StatefulWidget {
  const dashboard({super.key});

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  List dashboard = [];
  List sellingProducts = [];
  List bestSuppliers = [];
  bool isLoading = true;
  bool hasError = false;

  Future<void> fetchData() async {
    try {
      DashboardServices dashboardService = DashboardServices();
      final dashboardResponse = await dashboardService.getData(context);
      final products = await dashboardService.getHighSellingProducts(context);
      final suppliers = await dashboardService.getBestSuppliers(context);
      if (dashboardResponse != null && dashboardResponse['dashboard'] != null) {
        setState(() {
          dashboard = dashboardResponse['dashboard'];
          sellingProducts = products['products'];
          bestSuppliers = suppliers['suppliers'];
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
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.currency(locale: 'sw_TZ', symbol: 'Tsh.');
    final double sales =
        dashboard.isNotEmpty ? dashboard[0]['grandTotal'] ?? 0.0 : 0.0;
    final double purchases =
        dashboard.isNotEmpty ? dashboard[0]['totalPurchases'] ?? 0.0 : 0.0;
    final double netProfit = sales - purchases;

    return layout(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : hasError
                ? Center(child: Text('Something went wrong'))
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 100, right: 100),
                        child: Row(
                          children: [
                            Material(
                              elevation: 10,
                              color: AppConst.white,
                              child: Container(
                                width: 250.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  color: AppConst.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 60,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppText(
                                              txt: 'Total sales',
                                              size: 15,
                                              color: AppConst.grey,
                                              weight: FontWeight.bold,
                                            ),
                                            AppText(
                                              txt: numberFormat.format(sales),
                                              size: 20,
                                              color: AppConst.black,
                                              weight: FontWeight.bold,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.graphic_eq,
                                        color: AppConst.grey,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            Material(
                              elevation: 10,
                              color: AppConst.white,
                              child: Container(
                                width: 250.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  color: AppConst.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 60,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppText(
                                              txt: 'Total purchases',
                                              size: 15,
                                              color: AppConst.grey,
                                              weight: FontWeight.bold,
                                            ),
                                            AppText(
                                              txt: numberFormat
                                                  .format(purchases),
                                              size: 20,
                                              color: AppConst.black,
                                              weight: FontWeight.bold,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.money,
                                        color: AppConst.grey,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            Material(
                              elevation: 10,
                              color: AppConst.white,
                              child: Container(
                                width: 250.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  color: AppConst.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 60,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppText(
                                              txt: 'Total products',
                                              size: 15,
                                              color: AppConst.grey,
                                              weight: FontWeight.bold,
                                            ),
                                            AppText(
                                              txt:
                                                  '${dashboard[0]['totalProduct']}',
                                              size: 20,
                                              color: AppConst.black,
                                              weight: FontWeight.bold,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.propane_tank_rounded,
                                        color: AppConst.grey,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            Material(
                              elevation: 10,
                              color: AppConst.white,
                              child: Container(
                                width: 250.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  color: AppConst.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 60,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppText(
                                              txt: 'Net profit',
                                              size: 15,
                                              color: AppConst.grey,
                                              weight: FontWeight.bold,
                                            ),
                                            AppText(
                                              txt: numberFormat
                                                  .format(netProfit),
                                              size: 20,
                                              color: AppConst.black,
                                              weight: FontWeight.bold,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.money,
                                        color: AppConst.grey,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      MostSoldProducts(sellingProducts: sellingProducts),
                      SizedBox(
                        height: 50,
                      ),
                      BestSuppliers(bestSuppliers: bestSuppliers)
                    ],
                  ));
  }
}
