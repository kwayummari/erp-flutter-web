import 'package:erp/src/gateway/rolesService.dart';
import 'package:erp/src/provider/loadingProvider.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_button.dart';
import 'package:erp/src/widgets/app_input_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class editRole extends StatefulWidget {
  final Function fetchData;
  final Map<String, dynamic> data;
  const editRole({super.key, required this.fetchData, required this.data});

  @override
  State<editRole> createState() => _editRoleState();
}

class _editRoleState extends State<editRole> {
  TextEditingController name = TextEditingController();
  var branch;
  var tax;
  var editId;
  bool marked = false;
  bool dont_show_password = true;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    name.text = widget.data['name'] ?? '';
    editId = widget.data['id'] ?? '';
  }

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
              Icons.production_quantity_limits,
              color: AppConst.black,
            ),
            isemail: false,
            isPhone: false,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 20),
            child: Row(
              children: [
                myProvider.myLoging == true
                    ? SpinKitCircle(
                        color: AppConst.primary,
                      )
                    : Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 240,
                          height: 50,
                          child: AppButton(
                            onPress: () async {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              await rolesServices().editRole(
                                  context, name.text, editId.toString());
                              await widget.fetchData();
                              Navigator.pop(context);
                            },
                            label: 'Edit Role',
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
