import 'package:erp/src/gateway/inventoryService.dart';
import 'package:erp/src/provider/rowProvider.dart';
import 'package:erp/src/screens/inventory/addProduct.dart';
import 'package:erp/src/screens/inventory/editProductForm.dart';
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

class inventoryManagement extends StatefulWidget {
  const inventoryManagement({super.key});

  @override
  State<inventoryManagement> createState() => _inventoryManagementState();
}

class _inventoryManagementState extends State<inventoryManagement> {
  List<Map<String, dynamic>> productData = [];
  bool isLoading = true;
  bool hasError = false;

  Future<void> fetchData() async {
    try {
      inventoryServices inventoryService = inventoryServices();
      final productResponse = await inventoryService.getProduct(context);
      if (productResponse != null && productResponse['products'] != null) {
        setState(() {
          productData = (productResponse['products'] as List).map((product) {
            return {
              'id': product['id'],
              'productno.': product['productNumber'].toString(),
              'name': product['name'],
              'description': product['description'],
              'buyingprice': product['buyingPrice'].toString(),
              'sellingprice': product['sellingPrice'].toString(),
              'branch': product['branchId'][0]['name'].toString(),
              'branchId': product['branchId'][0]['id'].toString(),
              'taxId': product['taxType'].toString(),
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

  final List<String> titles = [
    'Product No.',
    'Name',
    'Description',
    'Buying Price',
    'Selling Price',
    'Branch'
  ];

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
            title: 'Product Management',
            button: AppButton(
              onPress: () => {
                ReusableModal.show(
                  width: 500,
                  height: 800,
                  context,
                  AppText(
                      txt: 'Add Product', size: 22, weight: FontWeight.bold),
                  onClose: fetchData,
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      addProductForm(
                        fetchData: fetchData,
                        buttonWidth: 500,
                      )
                    ],
                  ),
                )
              },
              label: 'Add products',
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
                    editModalHeight: 750,
                    editModalWidth: 500,
                    editStatement: AppText(
                        txt: 'Edit product', size: 18, weight: FontWeight.bold),
                    fetchData: fetchData,
                    columnSpacing: 45,
                    titles: titles,
                    data: productData,
                    cellBuilder: (context, row, title) {
                      return Text(
                          row[title.toLowerCase().replaceAll(' ', '')] ?? '');
                    },
                    onClose: fetchData,
                    deleteStatement: AppText(
                        txt: 'Are you sure you want to delete this product?',
                        size: 15,
                        weight: FontWeight.bold),
                    url: 'delete_product',
                    editForm: editProductForm(
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
