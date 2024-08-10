import 'dart:convert';

import 'package:erp/src/api/apis.dart';
import 'package:erp/src/functions/splash.dart';
import 'package:flutter/material.dart';

class DashboardServices {
  Api api = Api();

  Future getData(BuildContext context) async {
    SplashFunction splashDetails = SplashFunction();
    final companyId = await splashDetails.getCompanyId();
    Map<String, dynamic> data = {
      'companyId': companyId,
    };
    final response = await api.post(context, 'getData', data);
    final decodedResponse = jsonDecode(response.body);
    return decodedResponse;
  }
  Future getHighSellingProducts(BuildContext context) async {
    SplashFunction splashDetails = SplashFunction();
    final companyId = await splashDetails.getCompanyId();
    Map<String, dynamic> data = {
      'companyId': companyId,
    };
    final response = await api.post(context, 'getHighSellingProducts', data);
    final decodedResponse = jsonDecode(response.body);
    return decodedResponse;
  }
}
