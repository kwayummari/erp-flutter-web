import 'package:erp/src/provider/rowProvider.dart';
import 'package:erp/src/screens/customers/addCustomerForm.dart';
import 'package:erp/src/screens/customers/editCustomerForm.dart';
import 'package:erp/src/utils/auth_utils.dart';
import 'package:erp/src/utils/routes/route-names.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:erp/src/gateway/user.dart';
import 'package:erp/src/screens/models/layout/layout.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_button.dart';
import 'package:erp/src/widgets/app_modal.dart';
import 'package:erp/src/widgets/app_table.dart';
import 'package:erp/src/widgets/app_tabular_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CustomerManagement extends StatefulWidget {
  const CustomerManagement({super.key});

  @override
  State<CustomerManagement> createState() => _CustomerManagementState();
}

class _CustomerManagementState extends State<CustomerManagement> {
  List<Map<String, dynamic>> userData = [];
  bool isLoading = true;
  bool hasError = false;

  Future<void> fetchData() async {
    try {
      userServices userService = userServices();
      final userResponse = await userService.getCustomer(context);
      if (userResponse != null && userResponse['customers'] != null) {
        setState(() {
          userData = (userResponse['customers'] as List).map((user) {
            return {
              'id': user['id'],
              'fullname': user['fullname'],
              'email': user['email'],
              'phone number': user['phone'],
              'companyId': user['companyId'],
              'roleId': user['role'],
              'role': user['role_name'],
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
    'Fullname',
    'Email',
    'Phone number',
    'Branch',
    'Role',
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
            title: 'Customers Management',
            button: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                height: 50,
                child: AppButton(
                  onPress: () => {
                    ReusableModal.show(
                      width: 500,
                      height: 600,
                      context,
                      AppText(
                          txt: 'Add Customer', size: 22, weight: FontWeight.bold),
                      onClose: fetchData,
                      // addUserForm()
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[addCustomerForm(fetchData: fetchData)],
                      ),
                    )
                  },
                  label: 'Add Customer',
                  borderRadius: 5,
                  textColor: AppConst.white,
                  gradient: AppConst.primaryGradient,
                ),
              ),
            ),
            dropDown: Container(),
            child: Column(
              children: [
                if (userData.isNotEmpty)
                  ReusableTable(
                    deleteModalHeight: 300,
                    deleteModalWidth: 500,
                    editModalHeight: 550,
                    editModalWidth: 500,
                    editForm: editCustomerForm(
                        fetchData: fetchData, data: rowData ?? {}),
                    editStatement: AppText(
                        txt: 'Edit Employee',
                        size: 18,
                        weight: FontWeight.bold),
                    fetchData: fetchData,
                    columnSpacing: 100,
                    titles: titles,
                    data: userData,
                    cellBuilder: (context, row, title) {
                      return Text(row[title.toLowerCase()] ?? '');
                    },
                    onClose: fetchData,
                    deleteStatement: AppText(
                        txt: 'Are you sure you want to delete this employee?',
                        size: 18,
                        weight: FontWeight.bold),
                    url: 'deleteUserById',
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
