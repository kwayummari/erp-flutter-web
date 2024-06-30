import 'dart:convert';
import 'package:erp/src/api/apis.dart';
import 'package:erp/src/provider/loadingProvider.dart';
import 'package:erp/src/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class permissionsServices {
  Api api = Api();

  Future getPermissions(BuildContext context, Map<String, dynamic> data) async {
    final myProvider = Provider.of<LoadingProvider>(context, listen: false);
    myProvider.updateLoging(!myProvider.myLoging);
    final response = await api.post(context, 'getPermission', data);
    final newResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      return decodedResponse;
    } else {
      myProvider.updateLoging(!myProvider.myLoging);
      AppSnackbar(
        isError: true,
        response: newResponse['message'],
      ).show(context);
    }
  }

  Future<void> addPermission(
      BuildContext context, Map<String, dynamic> data) async {
    final myProvider = Provider.of<LoadingProvider>(context, listen: false);
    myProvider.updateLoging(!myProvider.myLoging);
    Map<String, dynamic> datas = {
      'permissions': jsonEncode(data['permissions']),
    };
    final response = await api.post(context, 'updateRoles', datas);
    print(response);
    final newResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      myProvider.updateLoging(!myProvider.myLoging);
      AppSnackbar(
        isError: false,
        response: newResponse['message'],
      ).show(context);
    } else {
      myProvider.updateLoging(!myProvider.myLoging);
      print(newResponse['message']);
      AppSnackbar(
        isError: true,
        response: newResponse['message'],
      ).show(context);
    }
  }
}
