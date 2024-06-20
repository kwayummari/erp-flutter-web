import 'package:erp/src/gateway/inventoryService.dart';
import 'package:erp/src/provider/loadingProvider.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app-dropdown.dart';
import 'package:erp/src/widgets/app_button.dart';
import 'package:erp/src/widgets/app_input_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class editProductForm extends StatefulWidget {
  final Function fetchData;
  final Map<String, dynamic> data;
  const editProductForm(
      {super.key, required this.fetchData, required this.data});

  @override
  State<editProductForm> createState() => _editProductFormState();
}

class _editProductFormState extends State<editProductForm> {
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController buyingPrice = TextEditingController();
  TextEditingController sellingPrice = TextEditingController();
  TextEditingController productNumber = TextEditingController();
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
    description.text = widget.data['description'] ?? '';
    quantity.text = widget.data['quantity'] ?? '';
    buyingPrice.text = widget.data['buyingprice'] ?? '';
    sellingPrice.text = widget.data['sellingprice'] ?? '';
    productNumber.text = widget.data['productno.'] ?? '';
    branch = widget.data['branchId'];
    tax = widget.data['taxId'];
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
            textfieldcontroller: quantity,
            ispassword: false,
            fillcolor: AppConst.white,
            label: 'Quantity',
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
            textfieldcontroller: buyingPrice,
            ispassword: false,
            fillcolor: AppConst.white,
            label: 'Buying Price',
            obscure: false,
            icon: Icon(
              Icons.price_change,
              color: AppConst.black,
            ),
            isemail: false,
            isPhone: false,
          ),
          AppInputText(
            textsColor: AppConst.black,
            textfieldcontroller: sellingPrice,
            ispassword: false,
            fillcolor: AppConst.white,
            label: 'Selling Price',
            obscure: false,
            icon: Icon(
              Icons.price_change,
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
            displayField: 'name',
          ),
          DropdownTextFormField(
              initialValue: tax.toString(),
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
              displayField: 'name'),
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
                                    await inventoryServices().editProduct(
                                           context,
                                  name.text,
                                  description.text,
                                  quantity.text,
                                  buyingPrice.text,
                                  sellingPrice.text,
                                  productNumber.text,
                                  branch,
                                  tax,
                                  editId.toString() );
                              await widget.fetchData();
                              Navigator.pop(context);
                            },
                            label: 'Edit Products',
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
