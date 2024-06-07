import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

import '../api/apis.dart';
import '../provider/login-provider.dart';
import '../utils/routes/route-names.dart';
import '../widgets/app_snackbar.dart';

class loginService {
  final Api api = Api();

  Future<void> login(
      BuildContext context, String email, String password) async {
    final myProvider = Provider.of<MyProvider>(context, listen: false);
    myProvider.updateLoging(!myProvider.myLoging);
    Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };

    final response = await api.post(context, 'login', data);
    final newResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      myProvider.updateLoging(!myProvider.myLoging);
      AppSnackbar(
        isError: false,
        response: newResponse['message'],
      ).show(context);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      await prefs.setString('userId', newResponse['user']['id'].toString());
      await prefs.setString('companyId', newResponse['user']['companyId']);
      await prefs.setString('roleId', newResponse['user']['role']);
      await prefs.setString('fullname', newResponse['user']['fullname']);
      await prefs.setString('branchId', newResponse['user']['branch']);
      context.go(RouteNames.layout);
    } else {
      myProvider.updateLoging(!myProvider.myLoging);
      AppSnackbar(
        isError: true,
        response: newResponse['message'],
      ).show(context);
    }
  }
}
