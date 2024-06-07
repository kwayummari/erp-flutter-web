import 'package:erp/src/utils/routes/route-names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashFunction {
  var email;
  var id;
  var role;
  var intro;

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
    role = sharedPreferences.getString('role');
    intro = sharedPreferences.getString('intro');
  }

  Future<String> getEmail() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var e = sharedPreferences.getString('email');
    return e.toString();
  }

  Future<String> getId() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var i = sharedPreferences.getString('id');
    return i.toString();
  }

  Future<String> getRole() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var r = sharedPreferences.getString('role');
    return r.toString();
  }

  Future<String> getIntro() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var intr = sharedPreferences.getString('intro');
    return intr.toString();
  }
}
