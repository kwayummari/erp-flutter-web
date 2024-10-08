import 'package:erp/src/gateway/inventoryService.dart';
import 'package:erp/src/provider/loadingProvider.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app-dropdown.dart';
import 'package:erp/src/widgets/app_button.dart';
import 'package:erp/src/widgets/app_input_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class addProductForm extends StatefulWidget {
  final Function fetchData;
  final double buttonWidth;
  const addProductForm(
      {super.key, required this.fetchData, required this.buttonWidth});

  @override
  State<addProductForm> createState() => _addProductFormState();
}

class _addProductFormState extends State<addProductForm> {
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController productNumber = TextEditingController();
  List allData = [];
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
              Icons.production_quantity_limits,
              color: AppConst.black,
            ),
            isemail: false,
            isPhone: false,
          ),
          AppInputText(
            textsColor: AppConst.black,
            textfieldcontroller: description,
            ispassword: false,
            fillcolor: AppConst.white,
            label: 'Description',
            obscure: false,
            icon: Icon(
              Icons.description,
              color: AppConst.black,
            ),
            isemail: false,
            isPhone: false,
          ),
          AppInputText(
            textsColor: AppConst.black,
            textfieldcontroller: productNumber,
            ispassword: false,
            fillcolor: AppConst.white,
            label: 'Product Number',
            obscure: false,
            icon: Icon(
              Icons.monetization_on,
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
          DropdownTextFormField(
            labelText: 'Select Tax',
            fillcolor: AppConst.white,
            apiUrl: 'tax',
            textsColor: AppConst.black,
            dropdownColor: AppConst.white,
            dataOrigin: 'tax',
            onChanged: (value) {
              setState(() {
                tax = value.toString();
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
                              inventoryServices().addProduct(
                                  context,
                                  name.text,
                                  description.text,
                                  productNumber.text,
                                  branch,
                                  tax);
                              await widget.fetchData();
                              Navigator.pop(context);
                            },
                            label: 'Add Product',
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
