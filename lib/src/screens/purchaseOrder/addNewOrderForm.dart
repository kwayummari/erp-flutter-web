import 'package:erp/src/gateway/purchaseOrderService.dart';
import 'package:erp/src/provider/loadingProvider.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app-dropdown.dart';
import 'package:erp/src/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class AddNewOrderForm extends StatefulWidget {
  final Function fetchData;
  final void Function()? refreshSuppliers;
  final double buttonWidth;
  final String? supplierId;
  final String? orderId;
  const AddNewOrderForm(
      {super.key,
      required this.fetchData,
      required this.buttonWidth,
      this.refreshSuppliers,
      this.supplierId,
      required this.orderId});

  @override
  State<AddNewOrderForm> createState() => _AddNewOrderFormState();
}

class _AddNewOrderFormState extends State<AddNewOrderForm> {
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

  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<LoadingProvider>(context);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              displayField: 'name', allData: allData,),
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
                                purchaseOrderServices().addNewOrder(context, widget.supplierId.toString(),
                              branch.toString(), widget.orderId.toString());
                                await widget.fetchData();
                                Navigator.pop(context);
                                if (widget.refreshSuppliers != null) {
                                  widget.refreshSuppliers!();
                                }
                              },
                              label: 'Add New Order',
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
