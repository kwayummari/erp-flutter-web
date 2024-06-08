import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_popover.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';

class ReusableTable extends StatelessWidget {
  final List<String> titles;
  final List<Map<String, dynamic>> data;
  final double columnSpacing;
  final Widget Function(BuildContext, Map<String, dynamic>, String) cellBuilder;
  final Future<void> Function()? onClose;

  const ReusableTable(
      {Key? key,
      required this.titles,
      required this.data,
      required this.cellBuilder,
      this.columnSpacing = 0,
      required this.onClose})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: {
        for (int i = 0; i < titles.length + 1; i++) i: FlexColumnWidth(),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: AppConst.grey200),
          children: [
            for (String title in titles)
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: AppText(
                    txt: title,
                    size: 20,
                    color: AppConst.black,
                    weight: FontWeight.bold,
                  )),
            SizedBox(width: 10), // Adjust width to control icon column width
          ],
        ),
        for (var row in data)
          TableRow(
            children: [
              for (String title in titles)
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: cellBuilder(context, row, title),
                ),
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: CustomPopover(
                    icon: Icons.more_vert,
                    items: [
                      CustomPopoverItem(
                        title: 'Edit',
                        icon: Icons.edit,
                        onTap: () {
                          // Handle option 1 tap
                        },
                      ),
                      CustomPopoverItem(
                        title: 'Delete',
                        icon: Icons.delete,
                        onTap: () {
                         
                        },
                      ),
                      // Add more items as needed
                    ],
                  )

                  // MouseRegion(
                  //   cursor: SystemMouseCursors.click,
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       final id = row['id'];
                  //       print('More actions for item with id: $id');
                  //     },
                  //     child: Icon(Icons.more_vert, size: 16),
                  //   ),
                  // ),
                  ),
            ],
          ),
      ],
    );
  }
}
