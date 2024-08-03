import 'package:erp/src/screens/saleProducts/addSalesProductForm.dart';
import 'package:erp/src/screens/userManagement/addUserForm.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app-dropdown.dart';
import 'package:erp/src/widgets/app_button.dart';
import 'package:erp/src/widgets/app_modal.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';

class TopOfSales extends StatefulWidget {
  final int randomNumber;
  final String todayDate;
  final String? supplierId;
  final String? orderId;
  final bool fetchSupplier;
  final List<Map<String, dynamic>> purchaseData;
  final void Function()? refreshSuppliers;
  final Future<void> Function()? fetchData;
  final Function fetchData1;
  final Function(String) onSupplierChanged;

  TopOfSales({
    Key? key,
    required this.randomNumber,
    required this.todayDate,
    required this.refreshSuppliers,
    required this.fetchSupplier,
    required this.purchaseData,
    required this.supplierId,
    required this.fetchData,
    required this.fetchData1,
    required this.onSupplierChanged,
    required this.orderId,
  }) : super(key: key);

  @override
  State<TopOfSales> createState() => _TopOfSalesState();
}

class _TopOfSalesState extends State<TopOfSales> {
  List allData = [];
  var supplierId;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/logo.png',
            width: 300,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 10),
          child: AppText(
            txt: 'JamSolutions,',
            size: 15,
            color: AppConst.black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 10),
          child: AppText(
            txt: 'Dar Es Salaam,',
            size: 15,
            color: AppConst.black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 10),
          child: AppText(
            txt: '+255 762 996 305',
            size: 15,
            color: AppConst.black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 40, bottom: 20),
          child: AppText(
            txt: 'Sales',
            size: 25,
            color: AppConst.black,
            weight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Container(
              width: 400,
              child: DropdownTextFormField(
                fetchSupplier: widget.fetchSupplier,
                refreshSuppliers: widget.refreshSuppliers,
                labelText: 'Select Customer',
                fillcolor: AppConst.white,
                apiUrl: 'users',
                textsColor: AppConst.black,
                dropdownColor: AppConst.white,
                dataOrigin: 'users',
                onChanged: (value) {
                  setState(() {
                    supplierId = value.toString();
                    widget.purchaseData.clear();
                    widget.onSupplierChanged(value.toString());
                  });
                  widget.fetchData!();
                },
                valueField: 'id',
                displayField: 'fullname',
                allData: allData,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                height: 50,
                child: AppButton(
                  onPress: () {
                    ReusableModal.show(
                      width: 500,
                      height: 550,
                      context,
                      AppText(
                        txt: 'Add Customer',
                        size: 22,
                        weight: FontWeight.bold,
                      ),
                      onClose: widget.fetchData,
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          addUserForm(
                            fetchData: widget.fetchData1,
                            refreshSuppliers: widget.refreshSuppliers,
                            buttonWidth: 420,
                          ),
                        ],
                      ),
                    );
                  },
                  label: 'Add Customer',
                  borderRadius: 8,
                  textColor: AppConst.white,
                  solidColor: AppConst.black,
                ),
              ),
            ),
            Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 15, right: 20),
                child: Container(
                  height: 50,
                  child: AppButton(
                    onPress: () {
                      ReusableModal.show(
                        width: 500,
                        height: 600,
                        context,
                        AppText(
                          txt: 'Add Product',
                          size: 22,
                          weight: FontWeight.bold,
                        ),
                        onClose: widget.fetchData,
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            AddSalesProductForm(
                              receiptNumber: widget.randomNumber.toString(),
                              supplierId: supplierId,
                              fetchData: widget.fetchData1,
                              orderId: widget.orderId,
                              buttonWidth: 500, customerId: supplierId ?? '',
                            ),
                          ],
                        ),
                      );
                    },
                    label: 'Select Product',
                    borderRadius: 8,
                    textColor: AppConst.white,
                    solidColor: AppConst.black,
                  ),
                ),
              ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
              child: AppText(
                txt:
                    'Sales Receipt no. #${ widget.randomNumber}',
                size: 20,
                color: AppConst.black,
                weight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 20, bottom: 20),
              child: AppText(
                txt: 'Date: ${widget.todayDate}',
                size: 20,
                color: AppConst.black,
                weight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
