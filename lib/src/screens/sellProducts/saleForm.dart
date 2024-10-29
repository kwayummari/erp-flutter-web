import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app-dropdown.dart';
import 'package:erp/src/widgets/app-offlineDropdownFormField.dart';
import 'package:erp/src/widgets/app_button.dart';
import 'package:erp/src/widgets/app_input_text.dart';
import 'package:flutter/material.dart';

class SaleForm extends StatefulWidget {
  List<Map<String, dynamic>> cartItems = [];
  final void Function()? refreshData;
  SaleForm({super.key, required this.cartItems, required this.refreshData});

  @override
  State<SaleForm> createState() => _SaleFormState();
}

class _SaleFormState extends State<SaleForm> {
  var supplierId;
  final _formKey = GlobalKey<FormState>();
  List allData = [];
  String selectedOption = 'Payment by cash';
  List<String> options = [
    'Payment by cash',
    'Payment by credit',
  ];
  void submitCart() async {
    // Prepare data to send to the API
    final receiptId =
        DateTime.now().millisecondsSinceEpoch.toString(); // Unique receipt ID
    final products = widget.cartItems
        .map((item) => {
              'productId': item['id'],
              'amount': item['amount'],
              'receiptId': receiptId,
            })
        .toList();

    // Send data to your API (replace with actual API call)
    print('Sending data: $products');

    // Clear cart after submission
    setState(() {
      widget.cartItems.clear();
    });

    Navigator.of(context).pop(); // Close popup
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return AppInputText(
                  textsColor: AppConst.black,
                  ispassword: false,
                  fillcolor: AppConst.white,
                  label: 'Amount for (${item['name']})',
                  keyboardType: TextInputType.number,
                  obscure: false,
                  onChange: (value) {
                    setState(() {
                      item['amount'] = int.tryParse(value) ?? 0;
                    });
                  },
                  icon: Icon(
                    Icons.production_quantity_limits,
                    color: AppConst.black,
                  ),
                  isemail: false,
                  isPhone: false,
                );
              },
            ),
          ),
          Divider(
            color: AppConst.grey,
          ),
          DropdownTextFormField(
            refreshSuppliers: widget.refreshData,
            labelText: 'Select Customer',
            fillcolor: AppConst.white,
            apiUrl: 'customers',
            textsColor: AppConst.black,
            dropdownColor: AppConst.white,
            dataOrigin: 'customers',
            onChanged: (value) {
              setState(() {
                supplierId = value.toString();
              });
            },
            valueField: 'id',
            displayField: 'fullname',
            allData: allData,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 200,
                  height: 40,
                  child: AppButton(
                    onPress: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      // loginService().login(context, email.text, password.text);
                    },
                    label: 'Submit',
                    borderRadius: 5,
                    textColor: AppConst.white,
                    gradient: AppConst.primaryGradient,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 230,
                  child: AppDropdownTextFormField(
                    labelText: 'Select Payment Method',
                    options: options,
                    value: selectedOption,
                    onChanged: (newValue) {
                      setState(() {
                        selectedOption = newValue!;
                      });
                    },
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
