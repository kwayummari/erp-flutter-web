import 'package:erp/src/gateway/purchaseOrderService.dart';
import 'package:flutter/material.dart';
import 'package:erp/src/screens/models/layout/layout.dart';

class purchaseOrderManagement extends StatefulWidget {
  const purchaseOrderManagement({super.key});

  @override
  State<purchaseOrderManagement> createState() =>
      _purchaseOrderManagementState();
}

class _purchaseOrderManagementState extends State<purchaseOrderManagement> {
  List rolesData = [];
  bool isLoading = true;
  bool hasError = false;
  var supplierId;

  Future<void> fetchData() async {
    try {
      purchaseOrderServices purchaseOrderService = purchaseOrderServices();
      final purchaseOrderResponse =
          await purchaseOrderService.getPurchaseOrder(context, supplierId);
      if (purchaseOrderResponse != null &&
          purchaseOrderResponse['orders'] != null) {
        setState(() {
          rolesData = purchaseOrderResponse['orders'];
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
  }

  @override
  Widget build(BuildContext context) {
    return layout(
      child: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
