import 'package:erp/src/utils/routes/route-names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashFunction {
  var id;

  Future navigatorToHome(BuildContext context) async {
    await getValidationData();

    await Future.delayed(Duration(seconds: 1), () {});

    if (id == null || id.toString().isEmpty) {
      context.go(RouteNames.login);
    } else {
      context.go(RouteNames.layout);
    }
  }

  Future<void> getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    id = sharedPreferences.getString('id');
  }

  Future<String> getEmail() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var e = sharedPreferences.getString('email');
    return e.toString();
  }

  Future<String> getUserId() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var userId = sharedPreferences.getString('userId');
    return userId.toString();
  }

  Future<String> getRoleId() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var roleId = sharedPreferences.getString('roleId');
    return roleId.toString();
  }

  Future<String> getCompanyId() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var companyId = sharedPreferences.getString('companyId');
    return companyId.toString();
  }
  Future<String> getFullname() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var fullname = sharedPreferences.getString('fullname');
    return fullname.toString();
  }
  Future<String> getBranchId() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var branchId = sharedPreferences.getString('branchId');
    return branchId.toString();
  }
}
