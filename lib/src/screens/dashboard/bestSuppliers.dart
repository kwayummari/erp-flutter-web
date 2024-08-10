import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';

class BestSuppliers extends StatelessWidget {
  final List bestSuppliers;
  const BestSuppliers({super.key, required this.bestSuppliers});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(
          txt: 'Most Sold Products',
          size: 20,
          color: AppConst.grey,
          weight: FontWeight.bold,
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 100, right: 100),
          child: Table(
            border: TableBorder.all(color: Colors.grey),
            columnWidths: {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(5),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(2),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: AppConst.grey),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppText(
                      txt: 'Name',
                      size: 18,
                      color: AppConst.white,
                      weight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppText(
                      txt: 'Phone',
                      size: 18,
                      color: AppConst.white,
                      weight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppText(
                      txt: 'TIN',
                      size: 18,
                      color: AppConst.white,
                      weight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppText(
                      txt: 'VRN',
                      size: 18,
                      color: AppConst.white,
                      weight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              for (var supplier in bestSuppliers)
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppText(
                        txt: supplier['name'],
                        size: 16,
                        color: AppConst.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppText(
                        txt: supplier['phone'],
                        size: 16,
                        color: AppConst.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppText(
                        txt: supplier['tin'],
                        size: 16,
                        color: AppConst.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppText(
                        txt: supplier['vrn'],
                        size: 16,
                        color: AppConst.black,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
