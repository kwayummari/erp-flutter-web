import 'dart:math';
import 'package:erp/src/gateway/salesProductServices.dart';
import 'package:erp/src/utils/auth_utils.dart';
import 'package:erp/src/utils/routes/route-names.dart';
import 'package:erp/src/widgets/app_listview_builder.dart';
import 'package:flutter/material.dart';
import 'package:erp/src/screens/models/layout/layout.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AllSalesManagement extends StatefulWidget {
  const AllSalesManagement({super.key});

  @override
  State<AllSalesManagement> createState() => _AllSalesManagementState();
}

class _AllSalesManagementState extends State<AllSalesManagement> {
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

  void refreshSuppliers() {
    setState(() {
      fetchSupplier = !fetchSupplier;
    });
  }

  Future<void> fetchData() async {
    try {
      salesProductServices productListServices = salesProductServices();
      final orderListResponse =
          await productListServices.getAllSalesServices(context);
      print(orderListResponse);
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

  @override
  Widget build(BuildContext context) {
    return layout(
      child: SingleChildScrollView(
        child: Align(
            alignment: Alignment.center,
            child: AppListviewBuilder(
              itemnumber: 10,
              direction: Axis.horizontal, // Horizontal scrolling
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  width: 100,
                  color: Colors.blueAccent,
                  child: Center(child: Text('Item $index')),
                );
              },
            )),
      ),
    );
  }
}
