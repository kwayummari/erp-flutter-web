import 'package:erp/src/gateway/rolesService.dart';
import 'package:erp/src/provider/loadingProvider.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_button.dart';
import 'package:erp/src/widgets/app_input_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class addRolesForm extends StatefulWidget {
  final Function fetchData;
  const addRolesForm({super.key, required this.fetchData});

  @override
  State<addRolesForm> createState() => _addRolesFormState();
}

class _addRolesFormState extends State<addRolesForm> {
  TextEditingController name = TextEditingController();
  var branch;
  var tax;
  bool marked = false;
  bool dont_show_password = true;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<LoadingProvider>(context);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppInputText(
            textsColor: AppConst.black,
            textfieldcontroller: name,
            ispassword: false,
            fillcolor: AppConst.white,
            label: 'Name',
            obscure: false,
            icon: Icon(
              Icons.history,
              color: AppConst.black,
            ),
            isemail: false,
            isPhone: false,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 20),
            child: Row(
              children: [Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 420,
                        height: 50,
                        child: AppButton(
                            onPress: () async {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              rolesServices().addRole(
                                  context,
                                  name.text);
                              await widget.fetchData();
                              Navigator.pop(context);
                            },
                            label: 'Add Role',
                            borderRadius: 5,
                            textColor: AppConst.white,
                            gradient: AppConst.primaryGradient,
                          ),
                      ),
                    ),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
