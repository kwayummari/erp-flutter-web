import 'package:erp/src/screens/authentication/loginForm.dart';
import 'package:erp/src/screens/authentication/sideTabFom.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:erp/src/widgets/app_base_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return AppBaseScreen(
      bgcolor: AppConst.white,
      isvisible: false,
      backgroundImage: false,
      backgroundAuth: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              loginForm(),
              sideTabForm(),
            ],
          )
        ],
      ),
    );
  }
}
