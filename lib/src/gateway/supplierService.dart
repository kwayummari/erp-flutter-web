import 'dart:convert';
import 'package:erp/src/api/apis.dart';
import 'package:erp/src/functions/splash.dart';
import 'package:erp/src/provider/loadingProvider.dart';
import 'package:erp/src/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class supplierServices {
  Api api = Api();

  Future getSupplier(BuildContext context) async {
    SplashFunction splashDetails = SplashFunction();
    final companyId = await splashDetails.getCompanyId();
    Map<String, dynamic> data = {
      'companyId': companyId,
    };
    final response = await api.post(context, 'suppliers', data);
    final decodedResponse = jsonDecode(response.body);
    return decodedResponse;
  }

  Future<void> addSupplier(BuildContext context, String name, String phone,
      String tin, String vrn, String address) async {
    final myProvider = Provider.of<LoadingProvider>(context, listen: false);
    myProvider.updateLoging(!myProvider.myLoging);
    SplashFunction splashDetails = SplashFunction();
    final companyId = await splashDetails.getCompanyId();
    Map<String, dynamic> data = {
      'name': name,
      'phone': phone,
      'tin': tin,
      'vrn': vrn,
      'address': address,
      'companyId': companyId
    };
    final response = await api.post(context, 'register_supplier', data);
    final newResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      myProvider.updateLoging(!myProvider.myLoging);
      AppSnackbar(
        isError: false,
        response: newResponse['message'],
      ).show(context);
      Navigator.pop(context);
    } else {
      myProvider.updateLoging(!myProvider.myLoging);
      AppSnackbar(
        isError: true,
        response: newResponse['message'],
      ).show(context);
    }
  }

  Future getSupplierDetails(BuildContext context, String id) async {
    SplashFunction splashDetails = SplashFunction();
    final companyId = await splashDetails.getCompanyId();
    Map<String, dynamic> data = {
      'id': id,
      'companyId': companyId,
    };
    final response = await api.post(context, 'suppliersDetails', data);
    final newResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      AppSnackbar(
        isError: false,
        response: newResponse['message'],
      ).show(context);
      return newResponse;
    } else {
      AppSnackbar(
        isError: true,
        response: newResponse['message'],
      ).show(context);
    }
  }

  Future getCustomerInvoices(BuildContext context, String customerId) async {
    SplashFunction splashDetails = SplashFunction();
    final branchId = await splashDetails.getBranchId();
    Map<String, dynamic> data = {
      'customerId': customerId,
      'branchId': branchId,
    };
    final response = await api.post(context, 'customerPendingInvoices', data);
    final newResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      AppSnackbar(
        isError: false,
        response: newResponse['message'],
      ).show(context);
      return newResponse;
    } else {
      AppSnackbar(
        isError: true,
        response: newResponse['message'],
      ).show(context);
    }
  }

  Future updateInvoices(BuildContext context, String receiptNo) async {
    SplashFunction splashDetails = SplashFunction();
    Map<String, dynamic> data = {'receiptNo': receiptNo};
    final response = await api.post(context, 'updateInvoices', data);
    final newResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      AppSnackbar(
        isError: false,
        response: newResponse['message'],
      ).show(context);
      return newResponse;
    } else {
      AppSnackbar(
        isError: true,
        response: newResponse['message'],
      ).show(context);
    }
  }

  Future<void> editSupplier(BuildContext context, String name, String phone,
      String tin, String vrn, String address, String editId) async {
    final myProvider = Provider.of<LoadingProvider>(context, listen: false);
    myProvider.updateLoging(!myProvider.myLoging);
    SplashFunction splashDetails = SplashFunction();
    final companyId = await splashDetails.getCompanyId();
    Map<String, dynamic> data = {
      'name': name,
      'phone': phone,
      'tin': tin,
      'vrn': vrn,
      'address': address,
      'companyId': companyId,
      'id': editId,
    };
    final response = await api.post(context, 'edit_supplier', data);
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
