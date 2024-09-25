import 'dart:convert';
import 'package:erp/src/api/apis.dart';
import 'package:erp/src/functions/splash.dart';
import 'package:erp/src/provider/loadingProvider.dart';
import 'package:erp/src/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class supplierServices {
  Api api = Api();

  Future getSupplier(BuildContext context, String branch) async {
    SplashFunction splashDetails = SplashFunction();
    final companyId = await splashDetails.getCompanyId();
    Map<String, dynamic> data = {
      'companyId': companyId,
      'branchId': branch,
    };
    final response = await api.post(context, 'suppliers', data);
    final decodedResponse = jsonDecode(response.body);
    return decodedResponse;
  }

  Future<void> addSupplier(BuildContext context, String name, String phone,
      String tin, String vrn, String branch) async {
    final myProvider = Provider.of<LoadingProvider>(context, listen: false);
    myProvider.updateLoging(!myProvider.myLoging);
    SplashFunction splashDetails = SplashFunction();
    final companyId = await splashDetails.getCompanyId();
    Map<String, dynamic> data = {
      'name': name,
      'phone': phone,
      'tin': tin,
      'vrn': vrn,
      'branchId': branch,
      'companyId': companyId
    };
    final response = await api.post(context, 'register_supplier', data);
    final newResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      myProvider.updateLoging(!myProvider.myLoging);
      AppSnackbar(
        isError: false,
        response: newResponse['message'],
      ).show(context);
      Navigator.pop(context);
    } else {
      myProvider.updateLoging(!myProvider.myLoging);
      AppSnackbar(
        isError: true,
        response: newResponse['message'],
      ).show(context);
    }
  }

  Future<void> editSupplier(
      BuildContext context,
      String name,
      String phone,
      String tin,
      String vrn,
      String branch,
      String editId) async {
    final myProvider = Provider.of<LoadingProvider>(context, listen: false);
    myProvider.updateLoging(!myProvider.myLoging);
    SplashFunction splashDetails = SplashFunction();
    final companyId = await splashDetails.getCompanyId();
    Map<String, dynamic> data = {
      'name': name,
      'phone': phone,
      'tin': tin,
      'vrn': vrn,
      'branchId': branch,
      'companyId': companyId,
      'id': editId,
    };
    final response = await api.post(context, 'edit_supplier', data);
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
