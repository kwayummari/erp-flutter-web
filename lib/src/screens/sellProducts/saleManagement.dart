import 'package:erp/src/functions/splash.dart';
import 'package:erp/src/gateway/inventoryService.dart';
import 'package:erp/src/screens/roles/addRoles.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/utils/auth_utils.dart';
import 'package:erp/src/utils/routes/route-names.dart';
import 'package:erp/src/widgets/app_modal.dart';
import 'package:flutter/material.dart';
import 'package:erp/src/gateway/rolesService.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:erp/src/screens/models/layout/layout.dart';
import 'package:go_router/go_router.dart';

class SaleManagement extends StatefulWidget {
  const SaleManagement({super.key});

  @override
  State<SaleManagement> createState() => _SaleManagementState();
}

class _SaleManagementState extends State<SaleManagement> {
  List productData = [];
  bool isLoading = true;
  bool hasError = false;

  Future<void> fetchData() async {
    try {
      SplashFunction splashDetails = SplashFunction();
      final fetchingBranchId = await splashDetails.getFetchingBranchId();
      final fetchingBranchName = await splashDetails.getFetchingBranchName();

      rolesServices rolesService = rolesServices();
      final rolesResponse = await rolesService.getRoles(context);

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
              Center(child: Text('')),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  mainAxisExtent: 120,
                ),
                padding: EdgeInsets.all(15.0),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: productData.length + 1,
                itemBuilder: (context, index) {
                  if (index == productData.length) {
                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          ReusableModal.show(
                            width: 500,
                            height: 300,
                            context,
                            AppText(
                                txt: 'Add Role',
                                size: 22,
                                weight: FontWeight.bold),
                            onClose: fetchData,
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                addRolesForm(fetchData: fetchData)
                              ],
                            ),
                          );
                        },
                        child: Material(
                          elevation: 10,
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            width: 200, // Fixed width for each grid item
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: AppConst.white,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  AppText(
                                    txt: ' Add Role',
                                    size: 20,
                                    color: Colors.white,
                                    weight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    // Normal grid item
                    return GestureDetector(
                      onTap: () {},
                      child: Material(
                        elevation: 10,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          width: 200,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AppText(
                                  txt: productData[index]['name'] +
                                      '(${productData[index]['sold'].toString()})',
                                  align: TextAlign.center,
                                  size: 18,
                                  color: Colors.black,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AppText(
                                  txt: productData[index]['name'] +
                                      '(${productData[index]['sold'].toString()})',
                                  align: TextAlign.center,
                                  size: 18,
                                  color: Colors.black,
                                  weight: FontWeight.bold,
                                ),
                              ),
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
