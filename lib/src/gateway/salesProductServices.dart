import 'dart:convert';

import 'package:erp/src/api/apis.dart';
import 'package:erp/src/functions/splash.dart';
import 'package:erp/src/provider/loadingProvider.dart';
import 'package:erp/src/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class salesProductServices {
  Api api = Api();

  Future getSalesServices(BuildContext context, String receiptNo) async {
    SplashFunction splashDetails = SplashFunction();
    final branchId = await splashDetails.getBranchId();
    Map<String, dynamic> data = {'receiptNo': receiptNo, 'branchId': branchId};
    final response = await api.post(context, 'get_sales', data);
    final decodedResponse = jsonDecode(response.body);
    return decodedResponse;
  }

  Future getAllSalesServices(BuildContext context) async {
    SplashFunction splashDetails = SplashFunction();
    final companyId = await splashDetails.getCompanyId();
    Map<String, dynamic> data = {'companyId': companyId};
    final response = await api.post(context, 'get_all_sales', data);
    final decodedResponse = jsonDecode(response.body);
    return decodedResponse;
  }

  Future getReportToday(BuildContext context) async {
    SplashFunction splashDetails = SplashFunction();
    final branchId = await splashDetails.getBranchId();
    final companyId = await splashDetails.getCompanyId();
    Map<String, dynamic> data = {'branchId': branchId, 'companyId': companyId};
    final response = await api.post(context, 'get_today_report', data);
    final decodedResponse = jsonDecode(response.body);
    return decodedResponse;
  }

  Future<Map<String, dynamic>> getReportByDateRange(
    BuildContext context, {
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    SplashFunction splashDetails = SplashFunction();
    final branchId = await splashDetails.getBranchId();
    final companyId = await splashDetails.getCompanyId();
    String formattedStartDate = startDate.toIso8601String().split('T').first;
    String formattedEndDate = endDate.toIso8601String().split('T').first;

    Map<String, dynamic> data = {
      'branchId': branchId,
      'companyId': companyId,
      'startDate': formattedStartDate,
      'endDate': formattedEndDate,
    };
    final response = await api.post(context, 'get_range_report', data);
    final decodedResponse = jsonDecode(response.body);
    return decodedResponse;
  }

  Future<void> editSalesServices(
      BuildContext context, String name, String editId) async {
    final myProvider = Provider.of<LoadingProvider>(context, listen: false);
    myProvider.updateLoging(!myProvider.myLoging);
    Map<String, dynamic> data = {
      'name': name,
      'id': editId,
    };
    final response = await api.post(context, 'edit_branch', data);
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

  Future<void> saveSalesServices(BuildContext context, String purchaseId,
      String supplierId, String branchId, String status) async {
    Map<String, dynamic> data = {
      'purchaseId': purchaseId,
      'supplierId': supplierId,
      'status': status,
      'branchId': branchId
    };
    final response = await api.post(
        context, status == '2' ? 'save_grn' : 'save_purchase', data);
    final newResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      AppSnackbar(
        isError: false,
        response: newResponse['message'],
      ).show(context);
    } else {
      AppSnackbar(
        isError: true,
        response: newResponse['message'],
      ).show(context);
    }
  }

  Future<void> deleteSalesServices(
      BuildContext context, String deleteId) async {
    final myProvider = Provider.of<LoadingProvider>(context, listen: false);
    myProvider.updateLoging(!myProvider.myLoging);
    Map<String, dynamic> data = {
      'id': deleteId,
    };
    final response = await api.post(context, 'delete_branch', data);
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

  Future<void> addNewSalesServices(BuildContext context, String inventoryId,
      String customerId, String receiptNo, String quantity) async {
    final myProvider = Provider.of<LoadingProvider>(context, listen: false);
    myProvider.updateLoging(!myProvider.myLoging);
    SplashFunction splashDetails = SplashFunction();
    final branchId = await splashDetails.getBranchId();
    final companyId = await splashDetails.getCompanyId();
    Map<String, dynamic> data = {
      'inventoryId': inventoryId,
      'customerId': customerId,
      'receiptNo': receiptNo,
      'branchId': branchId,
      'quantity': quantity,
      'companyId': companyId
    };
    final response = await api.post(context, 'add_new_sales', data);
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

  Future<void> sellProductsServices(BuildContext context, Map<String, dynamic> data) async {
    final response = await api.post(
        context, 'sell_products', data);
    final newResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      AppSnackbar(
        isError: false,
        response: newResponse['message'],
      ).show(context);
    } else {
      AppSnackbar(
        isError: true,
        response: newResponse['message'],
      ).show(context);
    }
  }
}
