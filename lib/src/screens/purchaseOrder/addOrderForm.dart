import 'package:erp/src/gateway/purchaseOrderService.dart';
import 'package:erp/src/provider/loadingProvider.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app-dropdownV2.dart';
import 'package:erp/src/widgets/app_button.dart';
import 'package:erp/src/widgets/app_input_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class AddOrderForm extends StatefulWidget {
  final Function fetchData;
  final void Function()? refreshSuppliers;
  final double buttonWidth;
  final String? supplierId;
  final String? orderId;
  const AddOrderForm(
      {super.key,
      required this.fetchData,
      required this.buttonWidth,
      this.refreshSuppliers,
      this.supplierId,
      required this.orderId});

  @override
  State<AddOrderForm> createState() => _AddOrderFormState();
}

class _AddOrderFormState extends State<AddOrderForm> {
  TextEditingController description = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController sellingPrice = TextEditingController();
  TextEditingController total = TextEditingController();
  List allData = [];
  var valueHolder;
  var branch;
  var inventoryId;
  bool marked = false;
  bool dontShowPassword = true;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    quantity.text = '1';
  }

  void _updateFields(newData, value) async {
    int newValue = int.parse(value);
    List<Map<String, dynamic>> data = newData;
    String trueValue = value;
    final selectedItem = data.firstWhere(
      (item) => item['id'].toString() == trueValue,
      orElse: () => {},
    );
    setState(() {
      inventoryId = selectedItem['id'].toString();
      description.text = selectedItem['description'] ?? '';
      sellingPrice.text = selectedItem['sellingPrice']?.toString() ?? '';
      quantity.text = '1';
      final price = double.tryParse(sellingPrice.text) ?? 0;
      final qty = double.tryParse(quantity.text) ?? 1;
      final totalAmount = price * qty;
      total.text = totalAmount.toStringAsFixed(2);
    });
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
          DropdownTextFormFieldV2(
            labelText: 'Select Product',
            fillcolor: AppConst.white,
            apiUrl: 'products',
            textsColor: AppConst.black,
            dropdownColor: AppConst.white,
            dataOrigin: 'products',
            onChanged: (value, data) {
              _updateFields(data, value);
            },
            valueField: 'id',
            displayField: 'name',
            allData: allData,
          ),
          AppInputText(
            textsColor: AppConst.black,
            textfieldcontroller: description,
            ispassword: false,
            fillcolor: AppConst.white,
            label: 'Description',
            obscure: false,
            icon: Icon(
              Icons.text_fields,
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
            keyboardType: TextInputType.number,
            onChange: (value) {
              final price = double.tryParse(sellingPrice.text) ?? 0;
              final qty = double.tryParse(value) ?? 1;
              final totalAmount = price * qty;
              total.text = totalAmount.toStringAsFixed(2);
            },
          ),
          AppInputText(
            textsColor: AppConst.black,
            textfieldcontroller: sellingPrice,
            ispassword: false,
            fillcolor: AppConst.white,
            label: 'Price',
            obscure: false,
            icon: Icon(
              Icons.numbers,
              color: AppConst.black,
            ),
            isemail: false,
            isPhone: false,
            keyboardType: TextInputType.number,
            onChange: (value) {
              final price = double.tryParse(value) ?? 0;
              final qty = double.tryParse(quantity.text) ?? 1;
              final totalAmount = price * qty;
              total.text = totalAmount.toStringAsFixed(2);
            },
          ),
          AppInputText(
            textsColor: AppConst.black,
            textfieldcontroller: total,
            ispassword: false,
            fillcolor: AppConst.white,
            label: 'Total',
            obscure: false,
            icon: Icon(
              Icons.numbers,
              color: AppConst.black,
            ),
            isemail: false,
            isPhone: false,
            keyboardType: TextInputType.number,
            enabled: false,
          ),
          if (widget.supplierId != null)
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
                                purchaseOrderServices().addPurchaseOrder(context, inventoryId,
                              quantity.text.toString(), widget.orderId.toString(), widget.orderId.toString());
                                await widget.fetchData();
                                Navigator.pop(context);
                                if (widget.refreshSuppliers != null) {
                                  widget.refreshSuppliers!();
                                }
                              },
                              label: 'Add Order List',
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
