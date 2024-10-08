import 'dart:convert';
import 'package:erp/src/functions/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/apis.dart';
import '../provider/loadingProvider.dart';
import '../widgets/app_snackbar.dart';

class addUserService {
  final Api api = Api();

  Future<void> addUser(BuildContext context, String email, String fullname,
      String phone, String branch, String role) async {
    final myProvider = Provider.of<LoadingProvider>(context, listen: false);
    myProvider.updateLoging(!myProvider.myLoging);
    SplashFunction splashDetails = SplashFunction();
    final companyId = await splashDetails.getCompanyId();
    Map<String, dynamic> data = {
      'email': email,
      'fullname': fullname,
      'phone': phone,
      'branch': branch,
      'role': role,
      'password': 'Password@1234',
      'companyId': companyId
    };

    final response = await api.post(context, 'register_user', data);
    final newResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      myProvider.updateLoging(!myProvider.myLoging);
      AppSnackbar(
        isError: false,
        response: newResponse['message'],
      ).show(context);
    } else {
      myProvider.updateLoging(!myProvider.myLoging);
      AppSnackbar(
        isError: true,
        response: newResponse['message'],
      ).show(context);
    }
  }

  Future<void> addCustomer(BuildContext context, String email, String fullname,
      String phone, String tin, String vrn, String address, String role) async {
    final myProvider = Provider.of<LoadingProvider>(context, listen: false);
    myProvider.updateLoging(!myProvider.myLoging);
    SplashFunction splashDetails = SplashFunction();
    final companyId = await splashDetails.getCompanyId();
    Map<String, dynamic> data = {
      'email': email,
      'fullname': fullname,
      'phone': phone,
      'role': role,
      'tin': tin,
      'vrn': vrn,
      'address': address,
      'password': 'Password@1234',
      'companyId': companyId
    };

    final response = await api.post(context, 'register_customer', data);
    final newResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      myProvider.updateLoging(!myProvider.myLoging);
      AppSnackbar(
        isError: false,
        response: newResponse['message'],
      ).show(context);
    } else {
      myProvider.updateLoging(!myProvider.myLoging);
      AppSnackbar(
        isError: true,
        response: newResponse['message'],
      ).show(context);
    }
  }

  Future<void> editUser(BuildContext context, String email, String fullname,
      String phone, String branch, String role, String id) async {
    final myProvider = Provider.of<LoadingProvider>(context, listen: false);
    myProvider.updateLoging(!myProvider.myLoging);
    SplashFunction splashDetails = SplashFunction();
    final companyId = await splashDetails.getCompanyId();
    Map<String, dynamic> data = {
      'id': id,
      'email': email,
      'fullname': fullname,
      'phone': phone,
      'branch': branch,
      'role': role,
      'password': 'Password@1234',
      'companyId': companyId
    };

    final response = await api.post(context, 'edit_user', data);
    final newResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      myProvider.updateLoging(!myProvider.myLoging);
      AppSnackbar(
        isError: false,
        response: newResponse['message'],
      ).show(context);
    } else {
      myProvider.updateLoging(!myProvider.myLoging);
      AppSnackbar(
        isError: true,
        response: newResponse['message'],
      ).show(context);
    }
  }
}
