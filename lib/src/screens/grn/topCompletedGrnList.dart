import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';

class TopCompletedGrnList extends StatefulWidget {
  final int randomNumber;
  final String todayDate;
  final Function(String) onSupplierChanged;

  TopCompletedGrnList({
    Key? key,
    required this.randomNumber,
    required this.todayDate,
    required this.onSupplierChanged,
  }) : super(key: key);

  @override
  State<TopCompletedGrnList> createState() => _TopCompletedGrnListState();
}

class _TopCompletedGrnListState extends State<TopCompletedGrnList> {
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
            txt: 'Completed Goods Received Notes',
            size: 25,
            color: AppConst.black,
            weight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
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
