import 'package:erp/src/gateway/login-services.dart';
import 'package:erp/src/provider/login-provider.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_button.dart';
import 'package:erp/src/widgets/app_input_text.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class loginForm extends StatefulWidget {
  const loginForm({super.key});

  @override
  State<loginForm> createState() => _loginFormState();
}

class _loginFormState extends State<loginForm> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool marked = false;
  bool dont_show_password = true;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<MyProvider>(context);
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(top: 200),
        child: Material(
          elevation: 10.0,
          child: Container(
            width: 500.0,
            height: 400.0,
            decoration: BoxDecoration(
              color: AppConst.white,
              borderRadius: BorderRadius.circular(0.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(txt: 'Login', size: 30, weight: FontWeight.w600,),
                  AppText(txt: 'Sign In to your account', size: 18, color: AppConst.blackOpacity,),
                  AppInputText(
                    textsColor: AppConst.black,
                    textfieldcontroller: email,
                    ispassword: false,
                    fillcolor: AppConst.white,
                    label: 'Email',
                    obscure: false,
                    icon: Icon(
                      Icons.person,
                      color: AppConst.black,
                    ),
                    isemail: true,
                    isPhone: false,
                  ),
                  AppInputText(
                    textsColor: AppConst.black,
                    isemail: false,
                    textfieldcontroller: password,
                    ispassword: dont_show_password,
                    fillcolor: AppConst.white,
                    label: 'Password',
                    obscure: dont_show_password,
                    icon: Icon(
                      Icons.lock,
                      color: AppConst.black,
                    ),
                    suffixicon: IconButton(
                        onPressed: () {
                          setState(() {
                            dont_show_password = !dont_show_password;
                          });
                        },
                        icon: Icon(dont_show_password
                            ? Icons.visibility_off
                            : Icons.visibility)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20, top: 20),
                    child: Row(
                      children: [
                        myProvider.myLoging == true
                      ? SpinKitCircle(
                          color: AppConst.primary,
                        )
                      : Container(
                          width: 100,
                          height: 55,
                          child: AppButton(
                            onPress: () {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              loginService()
                                  .login(context, email.text, password.text);
                            },
                            label: 'LOGIN',
                            borderRadius: 5,
                            textColor: AppConst.white,
                            gradient: AppConst.primaryGradient,
                          ),
                        ),
                        Spacer(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: AppText(
                            txt: 'Forgot password?',
                            size: 15,
                            color: AppConst.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
