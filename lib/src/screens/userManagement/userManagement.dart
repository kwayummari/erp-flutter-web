import 'package:erp/src/provider/rowProvider.dart';
import 'package:erp/src/screens/userManagement/addUserForm.dart';
import 'package:erp/src/screens/userManagement/editUserForm.dart';
import 'package:erp/src/utils/auth_utils.dart';
import 'package:erp/src/utils/routes/route-names.dart';
import 'package:erp/src/widgets/app-dropdown.dart';
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

class userManagement extends StatefulWidget {
  const userManagement({super.key});

  @override
  State<userManagement> createState() => _userManagementState();
}

class _userManagementState extends State<userManagement> {
  List<Map<String, dynamic>> userData = [];
  bool isLoading = true;
  bool hasError = false;
  String branch = '1';

  Future<void> fetchData() async {
    try {
      userServices userService = userServices();
      final userResponse = await userService.getUser(context, branch);
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
            title: 'Employees Management',
            dropDown: Container(
              width: 200,
              child: DropdownTextFormField(
                labelText: 'Select Branch',
                fillcolor: AppConst.white,
                apiUrl: 'getBranch',
                textsColor: AppConst.black,
                dropdownColor: AppConst.white,
                dataOrigin: 'branch',
                onChanged: (value) {
                  setState(() {
                    branch = value.toString();
                  });
                  fetchData();
                },
                valueField: 'id',
                displayField: 'name',
                allData: [],
              ),
            ),
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
                          txt: 'Add Employee', size: 22, weight: FontWeight.bold),
                      onClose: fetchData,
                      // addUserForm()
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[addUserForm(fetchData: fetchData)],
                      ),
                    )
                  },
                  label: 'Add Employee',
                  borderRadius: 5,
                  textColor: AppConst.white,
                  gradient: AppConst.primaryGradient,
                ),
              ),
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
