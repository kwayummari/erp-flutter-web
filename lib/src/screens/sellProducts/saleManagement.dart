import 'package:erp/src/functions/mathFormatter.dart';
import 'package:erp/src/functions/splash.dart';
import 'package:erp/src/gateway/inventoryService.dart';
import 'package:erp/src/screens/models/layout/layout.dart';
import 'package:erp/src/screens/sellProducts/saleForm.dart';
import 'package:erp/src/screens/sellProducts/sellProductButton.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/utils/auth_utils.dart';
import 'package:erp/src/utils/routes/route-names.dart';
import 'package:erp/src/widgets/app_input_text.dart';
import 'package:erp/src/widgets/app_modal.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:erp/src/widgets/app_text.dart';

class SaleManagement extends StatefulWidget {
  const SaleManagement({super.key});

  @override
  State<SaleManagement> createState() => _SaleManagementState();
}

class _SaleManagementState extends State<SaleManagement> {
  List productData = [];
  bool isLoading = true;
  bool hasError = false;
  final MathFormatter mathFormatter = MathFormatter();
  List<Map<String, dynamic>> cartItems = [];
  List filteredProductData = [];
  TextEditingController searchController = TextEditingController();

  Future<void> fetchData() async {
    try {
      SplashFunction splashDetails = SplashFunction();
      final fetchingBranchId = await splashDetails.getFetchingBranchId();
      inventoryServices inventoryService = inventoryServices();
      final productResponse =
          await inventoryService.getProduct(context, fetchingBranchId);
      print(productResponse);
      if (productResponse != null && productResponse['products'] != null) {
        setState(() {
          productData = productResponse['products'];
          filteredProductData = productData;
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

  void _filterProducts(String searchTerm) {
    setState(() {
      if (searchTerm.isEmpty) {
        filteredProductData = productData;
      } else {
        filteredProductData = productData.where((product) {
          return product['name']
              .toLowerCase()
              .contains(searchTerm.toLowerCase());
        }).toList();
      }
    });
  }

  void toggleCartItem(Map<String, dynamic> product) {
    setState(() {
      if (cartItems.any((item) => item['id'] == product['id'])) {
        cartItems.removeWhere((item) => item['id'] == product['id']);
      } else {
        cartItems.add({
          ...product,
          'amount': 0,
        });
      }
    });
  }

  void showCartPopup() {
    ReusableModal.show(
      width: 500,
      height: 500,
      context,
      AppText(txt: 'Sell Products', size: 22, weight: FontWeight.bold),
      SaleForm(cartItems: cartItems, refreshData: fetchData),
    );
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    fetchData();
    searchController.addListener(() {
      print("Search Term: ${searchController.text}");
      _filterProducts(searchController.text);
    });
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AppInputText(
                textsColor: AppConst.black,
                ispassword: false,
                fillcolor: AppConst.white,
                label: 'Search products',
                controller: searchController,
                obscure: false,
                icon: Icon(
                  Icons.search,
                  color: AppConst.black,
                ),
                isemail: false,
                isPhone: false,
              ),
            ),
            if (isLoading)
              Center(child: CircularProgressIndicator())
            else if (hasError)
              Center(child: Text('Error loading data')),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  mainAxisExtent: 155,
                ),
                padding: EdgeInsets.all(15.0),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filteredProductData.length + 1,
                itemBuilder: (context, index) {
                  if (index == filteredProductData.length) {
                    return SellProductButton(showCartPopup: showCartPopup);
                  } else {
                    final product = filteredProductData[index];
                    final sold = product['sold'] ?? 0;
                    final received = product['received'] ?? 0;
                    final result = mathFormatter.subtraction(received, sold);

                    return GestureDetector(
                      onTap: () => toggleCartItem(product),
                      child: Material(
                        elevation: 10,
                        color:
                            cartItems.any((item) => item['id'] == product['id'])
                                ? AppConst.black
                                : AppConst.white,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          width: 200,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AppText(
                                  txt: product['name'],
                                  align: TextAlign.center,
                                  size: 18,
                                  color: cartItems.any(
                                          (item) => item['id'] == product['id'])
                                      ? AppConst.white
                                      : AppConst.black,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: AppText(
                                  txt: 'Remainder: ${result.toString()}',
                                  align: TextAlign.center,
                                  size: 15,
                                  color: cartItems.any(
                                          (item) => item['id'] == product['id'])
                                      ? AppConst.white
                                      : AppConst.black,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: AppText(
                                  txt:
                                      'Selling Price : Tsh. ${product['sellingPrice']}/=',
                                  align: TextAlign.center,
                                  size: 15,
                                  color: cartItems.any(
                                          (item) => item['id'] == product['id'])
                                      ? AppConst.white
                                      : AppConst.black,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: AppText(
                                  txt: product['description'],
                                  align: TextAlign.center,
                                  size: 15,
                                  color: cartItems.any(
                                          (item) => item['id'] == product['id'])
                                      ? AppConst.white
                                      : AppConst.black,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: AppText(
                                  txt: product['taxName'],
                                  align: TextAlign.center,
                                  size: 15,
                                  color: cartItems.any(
                                          (item) => item['id'] == product['id'])
                                      ? AppConst.white
                                      : AppConst.black,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
