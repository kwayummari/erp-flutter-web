import 'package:erp/src/provider/rowProvider.dart';
import 'package:erp/src/screens/userManagement/addUserForm.dart';
import 'package:erp/src/screens/userManagement/editUserForm.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:erp/src/gateway/user.dart';
import 'package:erp/src/screens/models/layout/layout.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_button.dart';
import 'package:erp/src/widgets/app_modal.dart';
import 'package:erp/src/widgets/app_table.dart';
import 'package:erp/src/widgets/app_tabular_widget.dart';
import 'package:provider/provider.dart';

class userManagement extends StatefulWidget {
  const userManagement({super.key});

  @override
  State<userManagement> createState() => _userManagementState();
}

class _userManagementState extends State<userManagement> {
  List<Map<String, dynamic>> userData = [];
  bool isLoading = true;
  bool hasError = false;

  Future<void> fetchData() async {
    try {
      userServices userService = userServices();
      final userResponse = await userService.getUser(context);
      if (userResponse != null && userResponse['users'] != null) {
        setState(() {
          userData = (userResponse['users'] as List).map((user) {
            return {
              'id': user['id'],
              'fullname': user['fullname'],
              'email': user['email'],
              'phone number': user['phone'],
              'branch': user['branch_name'],
              'branchId': user['branch'],
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
    fetchData();
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
            Center(child: Text('Error loading data')),
            appTabular(
              title: 'User Management',
              button: AppButton(
                onPress: () => {
                  ReusableModal.show(
                    width: 500,
                    height: 600,
                    context,
                    AppText(txt: 'Add User', size: 22, weight: FontWeight.bold),
                    onClose: fetchData,
                    // addUserForm()
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[addUserForm(fetchData: fetchData)],
                    ),
                    footer: Row(
                      children: [
                        Spacer(),
                        AppButton(
                            onPress: () {
                              Navigator.pop(context);
                            },
                            solidColor: AppConst.black,
                            label: 'Cancel',
                            borderRadius: 5,
                            textColor: AppConst.white),
                      ],
                    ),
                  )
                },
                label: 'Add user',
                borderRadius: 5,
                textColor: AppConst.white,
                gradient: AppConst.primaryGradient,
              ),
              child: Column(
                children: [
                  if (userData.isNotEmpty)
                  ReusableTable(
                    deleteModalHeight: 300,
                    deleteModalWidth: 500,
                    editModalHeight: 550,
                    editModalWidth: 500,
                    editForm:
                        editUserForm(fetchData: fetchData, data: rowData ?? {}),
                    editStatement: AppText(
                        txt: 'Edit user', size: 18, weight: FontWeight.bold),
                    fetchData: fetchData,
                    columnSpacing: 100,
                    titles: titles,
                    data: userData,
                    cellBuilder: (context, row, title) {
                      return Text(row[title.toLowerCase()] ?? '');
                    },
                    onClose: fetchData,
                    deleteStatement: AppText(
                        txt: 'Are you sure you want to delete this user?',
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
