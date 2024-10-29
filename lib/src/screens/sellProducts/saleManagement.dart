import 'package:erp/src/functions/mathFormatter.dart';
import 'package:erp/src/functions/splash.dart';
import 'package:erp/src/gateway/inventoryService.dart';
import 'package:erp/src/screens/models/layout/layout.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/utils/auth_utils.dart';
import 'package:erp/src/utils/routes/route-names.dart';
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

  void toggleCartItem(Map<String, dynamic> product) {
    setState(() {
      // Check if the product is already in the cart
      if (cartItems.any((item) => item['id'] == product['id'])) {
        // Remove the item if it's already in the cart
        cartItems.removeWhere((item) => item['id'] == product['id']);
      } else {
        // Add the item to the cart if not present
        cartItems.add({
          ...product,
          'amount': 0, // Initial amount field for each item
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
      Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  title: AppText(txt: item['name'], size: 18),
                  subtitle: TextField(
                    decoration: InputDecoration(
                      labelText: 'Amount',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        item['amount'] = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: submitCart,
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  void submitCart() async {
    // Prepare data to send to the API
    final receiptId =
        DateTime.now().millisecondsSinceEpoch.toString(); // Unique receipt ID
    final products = cartItems
        .map((item) => {
              'productId': item['id'],
              'amount': item['amount'],
              'receiptId': receiptId,
            })
        .toList();

    // Send data to your API (replace with actual API call)
    print('Sending data: $products');

    // Clear cart after submission
    setState(() {
      cartItems.clear();
    });

    Navigator.of(context).pop(); // Close popup
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
        child: Column(
          children: [
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
                  mainAxisExtent: 150,
                ),
                padding: EdgeInsets.all(15.0),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: productData.length + 1,
                itemBuilder: (context, index) {
                  if (index == productData.length) {
                    return GestureDetector(
                      onTap: showCartPopup,
                      child: Material(
                        elevation: 10,
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          width: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.sell, color: AppConst.white),
                                SizedBox(width: 20),
                                AppText(
                                    txt: 'Sell',
                                    size: 20,
                                    color: Colors.white,
                                    weight: FontWeight.bold),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    final product = productData[index];
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
                                  txt: 'Selling Price : Tsh. ${product['sellingPrice']}/=',
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
