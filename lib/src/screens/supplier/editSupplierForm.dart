import 'package:erp/src/gateway/supplierService.dart';
import 'package:erp/src/provider/loadingProvider.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_button.dart';
import 'package:erp/src/widgets/app_input_text.dart';
import 'package:erp/src/widgets/app_input_text2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class editSupplierForm extends StatefulWidget {
  final Function fetchData;
  final Map<String, dynamic> data;
  const editSupplierForm(
      {super.key, required this.fetchData, required this.data});

  @override
  State<editSupplierForm> createState() => _editSupplierFormState();
}

class _editSupplierFormState extends State<editSupplierForm> {
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController tin = TextEditingController();
  TextEditingController vrn = TextEditingController();
  TextEditingController address = TextEditingController();
  List allData = [];
  var branch;
  var editId;
  bool marked = false;
  bool dont_show_password = true;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    print(widget.data);
    name.text = widget.data['name'] ?? '';
    phone.text = widget.data['phone'] ?? '';
    tin.text = widget.data['tin'] ?? '';
    vrn.text = widget.data['vrn'] ?? '';
    branch = widget.data['branchId'];
    editId = widget.data['id'];
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
              Icons.person,
              color: AppConst.black,
            ),
            isemail: false,
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
              Icons.phone,
              color: AppConst.black,
            ),
            isemail: false,
            isPhone: false,
          ),
          AppInputText2(
            textsColor: AppConst.black,
            textfieldcontroller: tin,
            ispassword: false,
            fillcolor: AppConst.white,
            label: 'Tin',
            obscure: false,
            icon: Icon(
              Icons.numbers,
              color: AppConst.black,
            ),
            isemail: false,
            isPhone: false,
            isOcas: true,
          ),
          AppInputText2(
            textsColor: AppConst.black,
            textfieldcontroller: vrn,
            ispassword: false,
            fillcolor: AppConst.white,
            label: 'Vrn',
            obscure: false,
            icon: Icon(
              Icons.numbers,
              color: AppConst.black,
            ),
            isemail: false,
            isPhone: false,
            isOcas: true,
          ),
          AppInputText(
            textsColor: AppConst.black,
            textfieldcontroller: address,
            ispassword: false,
            fillcolor: AppConst.white,
            label: 'Name',
            obscure: false,
            icon: Icon(
              Icons.person,
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
                          width: 440,
                          height: 50,
                          child: AppButton(
                            onPress: () async {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              await supplierServices().editSupplier(
                                  context,
                                  name.text,
                                  phone.text,
                                  tin.text,
                                  vrn.text,
                                  address.text,
                                  editId.toString());
                              await widget.fetchData();
                              Navigator.pop(context);
                            },
                            label: 'Edit Supplier',
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
