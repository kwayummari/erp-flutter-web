import 'package:erp/src/gateway/salesProductServices.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/utils/auth_utils.dart';
import 'package:erp/src/utils/routes/route-names.dart';
import 'package:flutter/material.dart';
import 'package:erp/src/screens/models/layout/layout.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TodayReportManagement extends StatefulWidget {
  const TodayReportManagement({super.key});

  @override
  State<TodayReportManagement> createState() => _TodayReportManagementState();
}

class _TodayReportManagementState extends State<TodayReportManagement> {
  List<Map<String, dynamic>> salesData = [];
  List<Map<String, dynamic>> filteredSalesData = [];
  bool isLoading = true;
  bool hasError = false;
  TextEditingController searchController = TextEditingController();

  Future<void> fetchData() async {
    try {
      salesProductServices productListServices = salesProductServices();
      final reportResponse = await productListServices.getReportToday(context);
      final reportData = reportResponse['report'];

      // Process data to group by inventoryName and sum quantities
      Map<String, Map<String, dynamic>> groupedData = {};
      for (var item in reportData) {
        String inventoryName = item['inventoryName'];
        int quantity = int.parse(item['quantity'].toString());
        if (groupedData.containsKey(inventoryName)) {
          groupedData[inventoryName]!['quantity'] += quantity;
        } else {
          groupedData[inventoryName] = {
            'customerId': item['customerId'],
            'fullname': item['fullname'],
            'branchName': item['branchName'],
            'inventoryName': item['inventoryName'],
            'quantity_received': item['quantity_received'],
            'purchaseBranchId': item['purchaseBranchId'],
            'purchaseCompanyId': item['purchaseCompanyId'],
            'quantity': quantity,
          };
        }
      }

      setState(() {
        salesData = groupedData.values.toList();
        filteredSalesData = salesData;
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
    searchController.addListener(() {
      filterSearchResults(searchController.text);
    });
  }

  Future<void> _checkLoginStatus() async {
    if (!await isUserLoggedIn()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(RouteNames.login);
      });
    }
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredSalesData = salesData;
      });
      return;
    }

    List<Map<String, dynamic>> tempList = [];
    for (var item in salesData) {
      if (item['inventoryName'].toLowerCase().contains(query.toLowerCase())) {
        tempList.add(item);
      }
    }

    setState(() {
      filteredSalesData = tempList;
    });
  }

  var today = DateFormat('EEEE d/MM/yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return layout(
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Align(
                alignment: Alignment.center,
                child: RepaintBoundary(
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
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              labelText: 'Search',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            child: DataTable(
                              headingRowColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                      (Set<WidgetState> states) {
                                return Colors.black;
                              }),
                              headingTextStyle: TextStyle(
                                color: Colors.white,
                              ),
                              columns: const <DataColumn>[
                                DataColumn(label: Text('Full Name')),
                                DataColumn(label: Text('Branch Name')),
                                DataColumn(label: Text('Inventory Name')),
                                DataColumn(label: Text('Quantity Sold')),
                                DataColumn(label: Text('Quantity Remained')),
                                DataColumn(label: Text('Customer ID')),
                                DataColumn(label: Text('Date')),
                              ],
                              rows: filteredSalesData
                                  .map<DataRow>((item) => DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text(
                                              item['customerId'].toString())),
                                          DataCell(Text(item['fullname'])),
                                          DataCell(Text(item['branchName'])),
                                          DataCell(Text(item['inventoryName'])),
                                          DataCell(Text(
                                              item['quantity'].toString())),
                                          DataCell(Text(
                                              item['quantity_received']
                                                  .toString())),
                                          DataCell(Text(today.toString())),
                                        ],
                                      ))
                                  .toList(),
                            ),
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
