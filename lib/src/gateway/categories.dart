import 'dart:convert';

import 'package:erp/src/api/apis.dart';
import 'package:flutter/material.dart';

class categoriesServices {
  Api api = Api();

  Future getCategories(BuildContext context) async {
    final response = await api.get(context, 'categories');
    final decodedResponse = jsonDecode(response.body);
    return decodedResponse;
  }

  Future getTopCategories(BuildContext context) async {
    final response = await api.get(context, 'getTopContents');
    final decodedResponse = jsonDecode(response.body);
    return decodedResponse;
  }
}
