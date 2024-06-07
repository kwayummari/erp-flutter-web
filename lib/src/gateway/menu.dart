import 'dart:convert';

import 'package:erp/src/api/apis.dart';
import 'package:erp/src/functions/splash.dart';
import 'package:flutter/material.dart';

class menuServices {
  Api api = Api();

  Future getMenu(BuildContext context) async {
    SplashFunction splashDetails = SplashFunction();
    final roleId = await splashDetails.getRoleId();
    print('role Id' + roleId);
    Map<String, dynamic> data = {
      'id': roleId,
    };
    final response = await api.post(context, 'getPermission', data);
    final decodedResponse = jsonDecode(response.body);
    return decodedResponse;
  }
}
