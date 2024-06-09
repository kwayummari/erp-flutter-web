import 'dart:convert';

import 'package:erp/src/api/apis.dart';
import 'package:erp/src/functions/splash.dart';
import 'package:flutter/material.dart';

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
}