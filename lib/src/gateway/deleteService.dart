import 'dart:convert';

import 'package:erp/src/api/apis.dart';
import 'package:flutter/material.dart';

class deleteServices {
  Api api = Api();

  Future delete(BuildContext context, url, userId) async {
    Map<String, dynamic> data = {
      'id': userId,
    };
    final response = await api.post(context, url, data);
    final decodedResponse = jsonDecode(response.body);
    return decodedResponse;
  }
}
