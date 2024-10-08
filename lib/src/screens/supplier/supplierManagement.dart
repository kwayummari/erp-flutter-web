import 'package:erp/src/gateway/supplierService.dart';
import 'package:erp/src/provider/rowProvider.dart';
import 'package:erp/src/screens/supplier/addSupplier.dart';
import 'package:erp/src/screens/supplier/editSupplierForm.dart';
import 'package:erp/src/utils/auth_utils.dart';
import 'package:erp/src/utils/routes/route-names.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:erp/src/screens/models/layout/layout.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_button.dart';
import 'package:erp/src/widgets/app_modal.dart';
import 'package:erp/src/widgets/app_table.dart';
import 'package:erp/src/widgets/app_tabular_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class supplierManagement extends StatefulWidget {
  const supplierManagement({super.key});

  @override
  State<supplierManagement> createState() => _supplierManagementState();
}

class _supplierManagementState extends State<supplierManagement> {
  List<Map<String, dynamic>> productData = [];
  bool isLoading = true;
  bool hasError = false;

  Future<void> fetchData() async {
    try {
      supplierServices supplierService = supplierServices();
      final productResponse = await supplierService.getSupplier(context);
      if (productResponse != null && productResponse['suppliers'] != null) {
        setState(() {
          productData = (productResponse['suppliers'] as List).map((product) {
            return {
              'id': product['id'],
              'phone': product['phone'],
              'name': product['name'],
              'tin': product['tin'],
              'vrn': product['vrn'],
              'location': product['branchName'],
              'address': product['address'],
            };
          }).toList();
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

  final List<String> titles = ['Phone', 'Name', 'Tin', 'Vrn', 'Address'];

  @override
  Widget build(BuildContext context) {
    final rowData = Provider.of<RowDataProvider>(context).rowData;
    return layout(
      child: Column(
        children: [
          if (isLoading)
            Center(child: CircularProgressIndicator())
          else if (hasError)
            Center(child: Text('')),
          appTabular(
            title: 'Supplier Management',
            dropDown: Container(),
            button: AppButton(
              onPress: () => {
                ReusableModal.show(
                  width: 500,
                  height: 550,
                  context,
                  AppText(
                      txt: 'Add Supplier', size: 22, weight: FontWeight.bold),
                  onClose: fetchData,
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      addSupplierForm(
                        fetchData: fetchData,
                        buttonWidth: 500,
                      )
                    ],
                  ),
                )
              },
              label: 'Add supplier',
              borderRadius: 5,
              textColor: AppConst.white,
              gradient: AppConst.primaryGradient,
            ),
            child: Column(
              children: [
                if (productData.isNotEmpty)
                  ReusableTable(
                    deleteModalHeight: 300,
                    deleteModalWidth: 500,
                    editModalHeight: 600,
                    editModalWidth: 500,
                    showDetails: true,
                    editStatement: AppText(
                        txt: 'Edit supplier',
                        size: 18,
                        weight: FontWeight.bold),
                    fetchData: fetchData,
                    columnSpacing: 110,
                    titles: titles,
                    data: productData,
                    cellBuilder: (context, row, title) {
                      return Text(
                          row[title.toLowerCase().replaceAll(' ', '')] ?? '');
                    },
                    onClose: fetchData,
                    deleteStatement: AppText(
                        txt: 'Are you sure you want to delete this supplier?',
                        size: 15,
                        weight: FontWeight.bold),
                    url: 'deleteSupplier',
                    editForm: editSupplierForm(
                        fetchData: fetchData, data: rowData ?? {}),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
