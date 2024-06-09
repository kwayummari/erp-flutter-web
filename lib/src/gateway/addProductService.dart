import 'dart:convert';
import 'package:erp/src/functions/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/apis.dart';
import '../provider/login-provider.dart';
import '../widgets/app_snackbar.dart';

class addProductService {
  final Api api = Api();
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
    final myProvider = Provider.of<MyProvider>(context, listen: false);
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
}
