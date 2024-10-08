import 'dart:convert';

import 'package:erp/src/api/apis.dart';
import 'package:erp/src/functions/splash.dart';
import 'package:flutter/material.dart';

class userServices {
  Api api = Api();

  Future getUser(BuildContext context, String branch) async {
    SplashFunction splashDetails = SplashFunction();
    final companyId = await splashDetails.getCompanyId();
    Map<String, dynamic> data = {
      'companyId': companyId,
      'branchId': branch
    };
    final response = await api.post(context, 'getUserByCompanyId', data);
    final decodedResponse = jsonDecode(response.body);
    return decodedResponse;
  }
  Future getCustomer(BuildContext context) async {
    SplashFunction splashDetails = SplashFunction();
    final companyId = await splashDetails.getCompanyId();
    Map<String, dynamic> data = {
      'companyId': companyId,
    };
    final response = await api.post(context, 'getCustomerByCompanyId', data);
    final decodedResponse = jsonDecode(response.body);
    return decodedResponse;
  }
}