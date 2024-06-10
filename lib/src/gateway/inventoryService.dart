import 'dart:convert';

import 'package:erp/src/api/apis.dart';
import 'package:erp/src/functions/splash.dart';
import 'package:erp/src/provider/loadingProvider.dart';
import 'package:erp/src/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class inventoryServices {
  Api api = Api();

  Future getProduct(BuildContext context) async {
    SplashFunction splashDetails = SplashFunction();
    final companyId = await splashDetails.getCompanyId();
    Map<String, dynamic> data = {
      'companyId': companyId,
    };
    final response = await api.post(context, 'products', data);
    final decodedResponse = jsonDecode(response.body);
    return decodedResponse;
  }
  Future<void> addProduct(
      BuildContext context,
      String name,
      String description,
      String quantity,
      String buyingPrice,
      String sellingPrice,
      String productNumber,
      String branch,
      String tax) async {
    print(tax);
    final myProvider = Provider.of<LoadingProvider>(context, listen: false);
    myProvider.updateLoging(!myProvider.myLoging);
    SplashFunction splashDetails = SplashFunction();
    final companyId = await splashDetails.getCompanyId();
    final userId = await splashDetails.getUserId();
    Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'quantity': quantity,
      'buyingPrice': buyingPrice,
      'sellingPrice': sellingPrice,
      'productNumber': productNumber,
      'branchId': branch,
      'taxType': tax,
      'companyId': companyId,
      'userId': userId
    };
    final response = await api.post(context, 'register_product', data);
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

  Future<void> editProduct(BuildContext context,
      String name,
      String description,
      String quantity,
      String buyingPrice,
      String sellingPrice,
      String productNumber,
      String branch,
      String tax,
      String editId) async {
    final myProvider = Provider.of<LoadingProvider>(context, listen: false);
    myProvider.updateLoging(!myProvider.myLoging);
    SplashFunction splashDetails = SplashFunction();
    final companyId = await splashDetails.getCompanyId();
    final userId = await splashDetails.getUserId();
    Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'quantity': quantity,
      'buyingPrice': buyingPrice,
      'sellingPrice': sellingPrice,
      'productNumber': productNumber,
      'branchId': branch,
      'taxType': tax,
      'companyId': companyId,
      'userId': userId,
      'editId': editId,
    };

    final response = await api.post(context, 'edit_product', data);
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