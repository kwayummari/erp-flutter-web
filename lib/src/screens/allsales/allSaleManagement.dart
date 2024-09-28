import 'package:erp/src/gateway/salesProductServices.dart';
import 'package:erp/src/utils/auth_utils.dart';
import 'package:erp/src/utils/routes/route-names.dart';
import 'package:erp/src/widgets/app_listview_builder.dart';
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

  Future<void> fetchData() async {
    try {
      salesProductServices productListServices = salesProductServices();
      final orderListResponse =
          await productListServices.getAllSalesServices(context);
      print(orderListResponse['sales']);
      setState(() {
        sales = orderListResponse['sales'];
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
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: AppListviewBuilder(
            itemnumber: sales.length,
            direction: Axis.vertical, // Horizontal scrolling
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Material(
                  elevation: 4,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 100,
                    color: Colors.black,
                    child: Center(child: Text('Item $index')),
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
