import 'package:erp/src/gateway/addUser.dart';
import 'package:erp/src/provider/loadingProvider.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app-dropdown.dart';
import 'package:erp/src/widgets/app_button.dart';
import 'package:erp/src/widgets/app_input_text.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class editCustomerForm extends StatefulWidget {
  final Function fetchData;
  final Map<String, dynamic> data;
  const editCustomerForm({super.key, required this.fetchData, required this.data});

  @override
  State<editCustomerForm> createState() => _editCustomerFormState();
}

class _editCustomerFormState extends State<editCustomerForm> {
  TextEditingController email = TextEditingController();
  TextEditingController fullname = TextEditingController();
  TextEditingController phone = TextEditingController();
  List allData = [];
  var branch;
  var role;
  var id;
  bool marked = false;
  bool dont_show_password = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fullname.text = widget.data['fullname'] ?? '';
    email.text = widget.data['email'] ?? '';
    phone.text = widget.data['phone number'] ?? '';
    branch = widget.data['branchId'];
    role = widget.data['roleId'];
    id = widget.data['id'];
  }

  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<LoadingProvider>(context);
    return widget.data.isNotEmpty
        ? Form(
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
                  isPhone: true,
                ),
                DropdownTextFormField(
                  initialValue: branch.toString(),
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
                  displayField: 'name', allData: allData,
                ),
                DropdownTextFormField(
                  labelText: 'Select Role',
                  fillcolor: AppConst.white,
                  apiUrl: 'getAllRoles',
                  textsColor: AppConst.black,
                  dropdownColor: AppConst.white,
                  dataOrigin: 'roles',
                  initialValue: role.toString(),
                  onChanged: (value) {
                    setState(() {
                      role = value.toString();
                    });
                  },
                  valueField: 'id',
                  displayField: 'name', allData: allData,
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
                                width: 440,
                                height: 50,
                                child: AppButton(
                                  onPress: () async {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }
                                    await addUserService().editUser(
                                        context,
                                        email.text,
                                        fullname.text,
                                        phone.text,
                                        branch,
                                        role,
                                        id.toString());
                                    await widget.fetchData();
                                    Navigator.pop(context);
                                  },
                                  label: 'Edit user',
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
          )
        : AppText(
            txt: 'Loading',
            size: 15,
            color: AppConst.black,
          );
  }
}
