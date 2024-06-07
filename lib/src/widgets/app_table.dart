import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';

class ReusableTable extends StatelessWidget {
  final List<String> titles;
  final List<Map<String, dynamic>> data;
  final double columnSpacing;
  final double rowHeight;

  const ReusableTable({
    Key? key,
    required this.titles,
    required this.data,
    this.columnSpacing = 16.0,
    this.rowHeight = 56.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: columnSpacing,
        columns: titles
            .map((title) => DataColumn(
                  label: AppText(txt: title, size: 20, weight: FontWeight.bold, color: AppConst.black,),
                ))
            .toList(),
        rows: data.map((row) => _buildDataRow(row)).toList(),
      ),
    );
  }

  DataRow _buildDataRow(Map<String, dynamic> row) {
    return DataRow(
      cells: titles.map((title) {
        return DataCell(
          AppText(txt: row[title.toLowerCase()] ?? '', size: 20, color: AppConst.black,),
          );
      }).toList(),
    );
  }
}
