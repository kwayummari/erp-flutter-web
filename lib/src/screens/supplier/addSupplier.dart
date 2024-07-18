import 'package:erp/src/gateway/supplierService.dart';
import 'package:erp/src/provider/loadingProvider.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app-dropdown.dart';
import 'package:erp/src/widgets/app_button.dart';
import 'package:erp/src/widgets/app_input_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class addSupplierForm extends StatefulWidget {
  final Function fetchData;
  final void Function()? refreshSuppliers;
  final double buttonWidth;
  const addSupplierForm({
    super.key,
    required this.fetchData,
    required this.buttonWidth,
    this.refreshSuppliers,
  });

  @override
  State<addSupplierForm> createState() => _addSupplierFormState();
}

class _addSupplierFormState extends State<addSupplierForm> {
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController tin = TextEditingController();
  TextEditingController vrn = TextEditingController();
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
          AppInputText(
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
          ),
          AppInputText(
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
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          width: widget.buttonWidth - 70,
                          height: 50,
                          child: AppButton(
                            onPress: () async {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              supplierServices().addSupplier(context, name.text,
                                  phone.text, tin.text, vrn.text, branch);
                              await widget.fetchData();
                              Navigator.pop(context);
                              if (widget.refreshSuppliers != null) {
                                widget.refreshSuppliers!();
                              }
                            },
                            label: 'Add Supplier',
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
