import 'dart:convert';

import 'package:erp/src/api/apis.dart';
import 'package:erp/src/functions/splash.dart';
import 'package:erp/src/provider/loadingProvider.dart';
import 'package:erp/src/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class branchServices {
  Api api = Api();

  Future getBranch(BuildContext context) async {
    SplashFunction splashDetails = SplashFunction();
    final companyId = await splashDetails.getCompanyId();
    Map<String, dynamic> data = {
      'companyId': companyId,
    };
    final response = await api.post(context, 'getBranch', data);
    final decodedResponse = jsonDecode(response.body);
    return decodedResponse;
  }

  Future<void> editBranch( BuildContext context, String name, String editId ) async {
    final myProvider = Provider.of<LoadingProvider>(context, listen: false);
    myProvider.updateLoging(!myProvider.myLoging);
    Map<String, dynamic> data = {
      'name': name,
      'id': editId,
    };
    final response = await api.post(context, 'edit_branch', data);
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

  Future<void> deleteBranch( BuildContext context, String deleteId ) async {
    final myProvider = Provider.of<LoadingProvider>(context, listen: false);
    myProvider.updateLoging(!myProvider.myLoging);
    Map<String, dynamic> data = {
      'id': deleteId,
    };
    final response = await api.post(context, 'delete_branch', data);
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

  Future<void> addBranch(
      BuildContext context,
      String name) async {
    final myProvider = Provider.of<LoadingProvider>(context, listen: false);
    myProvider.updateLoging(!myProvider.myLoging);
    SplashFunction splashDetails = SplashFunction();
    final companyId = await splashDetails.getCompanyId();
    Map<String, dynamic> data = {
      'name': name,
      'companyId': companyId,
    };

    final response = await api.post(context, 'register_branch', data);
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
