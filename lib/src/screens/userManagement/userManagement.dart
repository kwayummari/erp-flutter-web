import 'package:erp/src/gateway/user.dart';
import 'package:erp/src/screens/models/layout/layout.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_button.dart';
import 'package:erp/src/widgets/app_table.dart';
import 'package:erp/src/widgets/app_tabular_widget.dart';
import 'package:flutter/material.dart';

class userManagement extends StatefulWidget {
  const userManagement({super.key});

  @override
  State<userManagement> createState() => _userManagementState();
}

class _userManagementState extends State<userManagement> {
  List<Map<String, dynamic>> data = [];
  bool isLoading = true;
  bool hasError = false;

  Future<void> fetchData() async {
    try {
      userServices userService = userServices();
      final response = await userService.getUser(context);
      print(response);

      if (response != null && response['users'] != null) {
        setState(() {
          data = (response['users'] as List).map((user) {
            return {
              'fullname': user['fullname'],
              'email': user['email'],
              'phone number': user['phone'],
              'branch': user['branch_name'],
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
    return layout(
      child: Column(
        children: [
          if (isLoading)
            Center(child: CircularProgressIndicator())
          else if (hasError)
            Center(child: Text('Error loading data'))
          else if (data.isNotEmpty)
            appTabular(
              title: 'User Management',
              button: AppButton(
                onPress: () => {},
                label: 'Add user',
                borderRadius: 5,
                textColor: AppConst.white,
                gradient: AppConst.primaryGradient,
              ),
              child: Column(
                children: [
                  ReusableTable(
                    columnSpacing: 180,
                    titles: titles,
                    data: data,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
