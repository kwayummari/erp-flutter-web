import 'package:erp/src/gateway/purchaseOrderService.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app-dropdown.dart';
import 'package:erp/src/widgets/app_text.dart';
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
  var supplier;

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
                  padding: const EdgeInsets.only(left: 20, top: 40, bottom: 40),
                  child: AppText(
                    txt: 'Purchase Order',
                    size: 25,
                    color: AppConst.black,
                    weight: FontWeight.bold,
                  ),
                ),
                DropdownTextFormField(
                    labelText: 'Select Supplier',
                    fillcolor: AppConst.white,
                    apiUrl: 'suppliers',
                    textsColor: AppConst.black,
                    dropdownColor: AppConst.white,
                    dataOrigin: 'suppliers',
                    onChanged: (value) {
                      setState(() {
                        supplier = value.toString();
                      });
                    },
                    valueField: 'id',
                    displayField: 'name'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
