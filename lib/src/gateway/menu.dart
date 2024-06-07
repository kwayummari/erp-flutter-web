import 'dart:convert';

import 'package:erp/src/api/apis.dart';
import 'package:erp/src/functions/splash.dart';
import 'package:flutter/material.dart';

class menuServices {
  Api api = Api();

  Future getMenu(BuildContext context) async {
    SplashFunction splashDetails =
        SplashFunction();
    final roleId = await splashDetails.getRoleId();
    Map<String, dynamic> data = {
      'roleId': roleId,
    };
    final response = await api.post(context, 'getPermission', data);
    final decodedResponse = jsonDecode(response.body);
    return decodedResponse;
  }
}
