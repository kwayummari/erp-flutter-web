import 'package:erp/src/gateway/addUser.dart';
import 'package:erp/src/provider/loadingProvider.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app-dropdown.dart';
import 'package:erp/src/widgets/app_button.dart';
import 'package:erp/src/widgets/app_input_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class addCustomerForm extends StatefulWidget {
  final Function fetchData;
  final void Function()? refreshSuppliers;
  final double? buttonWidth;
  const addCustomerForm({
    super.key,
    required this.fetchData,
    this.refreshSuppliers,
    this.buttonWidth,
  });

  @override
  State<addCustomerForm> createState() => _addCustomerFormState();
}

class _addCustomerFormState extends State<addCustomerForm> {
  TextEditingController email = TextEditingController();
  TextEditingController fullname = TextEditingController();
  TextEditingController phone = TextEditingController();
  List allData = [];
  var branch;
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
            textfieldcontroller: fullname,
            ispassword: false,
            fillcolor: AppConst.white,
            label: 'Fullname',
            obscure: false,
            icon: Icon(
              Icons.person,
              color: AppConst.black,
            ),
            isemail: false,
            isPhone: false,
          ),
          AppInputText(
            textsColor: AppConst.black,
            textfieldcontroller: email,
            ispassword: false,
            fillcolor: AppConst.white,
            label: 'Email',
            obscure: false,
            icon: Icon(
              Icons.mail,
              color: AppConst.black,
            ),
            isemail: true,
            isPhone: false,
          ),
          AppInputText(
            textsColor: AppConst.black,
            textfieldcontroller: phone,
            ispassword: false,
            fillcolor: AppConst.white,
            label: 'Phone',
            obscure: false,
            icon: Icon(
              Icons.phone_android,
              color: AppConst.black,
            ),
            isemail: false,
            isPhone: false,
          ),
          DropdownTextFormField(
            labelText: 'Select Branch',
            fillcolor: AppConst.white,
            apiUrl: 'getBranch',
            textsColor: AppConst.black,
            dropdownColor: AppConst.white,
            dataOrigin: 'branch',
            onChanged: (value) {
              setState(() {
                branch = value.toString();
              });
            },
            valueField: 'id',
            displayField: 'name',
            allData: allData,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 20),
            child: Row(
              children: [
                myProvider.myLoging == true
                    ? SpinKitCircle(
                        color: AppConst.primary,
                      )
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: widget.buttonWidth ?? 440,
                          height: 50,
                          child: AppButton(
                            onPress: () async {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              addUserService().addUser(context, email.text,
                                  fullname.text, phone.text, branch, '3');
                              await widget.fetchData();
                              Navigator.pop(context);
                              if (widget.refreshSuppliers != null) {
                                widget.refreshSuppliers!();
                              }
                            },
                            label: 'Create customer',
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
