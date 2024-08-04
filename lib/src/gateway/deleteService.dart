import 'dart:convert';

import 'package:erp/src/api/apis.dart';
import 'package:erp/src/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';

class deleteServices {
  Api api = Api();

  Future delete(BuildContext context, url, userId) async {
    Map<String, dynamic> data = {
      'id': userId,
    };
    final response = await api.post(context, url, data);
    final decodedResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      AppSnackbar(
        isError: false,
        response: decodedResponse['message'],
      ).show(context);
    } else {
      AppSnackbar(
        isError: true,
        response: decodedResponse['message'],
      ).show(context);
    }
    return decodedResponse;
  }

  Future deleteSalesProduct(BuildContext context, url, id, receiptNo) async {
    Map<String, dynamic> data = {'id': id, 'receiptNo': receiptNo};
    final response = await api.post(context, url, data);
    final decodedResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      AppSnackbar(
        isError: false,
        response: decodedResponse['message'],
      ).show(context);
    } else {
      AppSnackbar(
        isError: true,
        response: decodedResponse['message'],
      ).show(context);
    }
    return decodedResponse;
  }

  Future editSalesProduct(BuildContext context, url, quantity, id) async {
    Map<String, dynamic> data = {'id': id, 'quantity': quantity};
    final response = await api.post(context, url, data);
    final decodedResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      AppSnackbar(
        isError: false,
        response: decodedResponse['message'],
      ).show(context);
    } else {
      AppSnackbar(
        isError: true,
        response: decodedResponse['message'],
      ).show(context);
    }
    return decodedResponse;
  }
}
