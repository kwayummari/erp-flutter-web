import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app-dropdown.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';

class TopGrn extends StatefulWidget {
  final int randomNumber;
  final String todayDate;
  final String? supplierId;
  final String? orderId;
  final String? purchaseOrderId;
  final bool fetchSupplier;
  final List<Map<String, dynamic>> purchaseData;
  final void Function()? refreshSuppliers;
  final Future<void> Function()? fetchData;
  final Function fetchData1;
  final Function(String) onSupplierChanged;

  TopGrn({
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
    required this.purchaseOrderId,
  }) : super(key: key);

  @override
  State<TopGrn> createState() => _TopGrnState();
}

class _TopGrnState extends State<TopGrn> {
  List allData = [];
  bool addOrder = false;
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
            txt: 'Goods Received Notes',
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
                labelText: 'Select Supplier',
                fillcolor: AppConst.white,
                apiUrl: 'suppliers',
                textsColor: AppConst.black,
                dropdownColor: AppConst.white,
                dataOrigin: 'suppliers',
                onChanged: (value) {
                  setState(() {
                    supplierId = value.toString();
                    addOrder = true;
                    widget.purchaseData.clear();
                    widget.onSupplierChanged(value.toString());
                  });
                  widget.fetchData!();
                },
                valueField: 'id',
                displayField: 'name',
                allData: allData,
              ),
            ),
            Spacer(),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
              child: AppText(
                txt: 'Purchase Order #${widget.purchaseOrderId ?? widget.randomNumber}',
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
