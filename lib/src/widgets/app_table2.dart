import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_input_text.dart';
import 'package:erp/src/widgets/app_popover.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';

class ReusableTable2 extends StatefulWidget {
  final List<String> titles;
  final String url;
  final double deleteModalWidth;
  final double deleteModalHeight;
  final double editModalWidth;
  final double editModalHeight;
  final List<Map<String, dynamic>> data;
  final Function fetchData;
  final double columnSpacing;
  final Widget deleteStatement;
  final Widget editStatement;
  final Widget Function(BuildContext, Map<String, dynamic>, String) cellBuilder;
  final Future<void> Function()? onClose;

  const ReusableTable2({
    Key? key,
    required this.deleteModalWidth,
    required this.deleteModalHeight,
    required this.editModalWidth,
    required this.editModalHeight,
    required this.fetchData,
    required this.titles,
    required this.data,
    required this.deleteStatement,
    required this.editStatement,
    required this.cellBuilder,
    required this.url,
    required this.columnSpacing,
    required this.onClose,
  }) : super(key: key);

  @override
  _ReusableTable2State createState() => _ReusableTable2State();
}

class _ReusableTable2State extends State<ReusableTable2> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  List<int> availableRowsPerPage = const <int>[
    PaginatedDataTable.defaultRowsPerPage,
    PaginatedDataTable.defaultRowsPerPage * 2,
    PaginatedDataTable.defaultRowsPerPage * 5,
    PaginatedDataTable.defaultRowsPerPage * 10,
  ];

  void _sort<T>(Comparable<T> Function(Map<String, dynamic> d) getField,
      int columnIndex, bool ascending) {
    widget.data.sort((a, b) {
      if (!ascending) {
        final Map<String, dynamic> c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: PaginatedDataTable(
        headingRowColor: WidgetStateProperty.all(AppConst.grey200),
        columnSpacing: widget.columnSpacing,
        columns: [
          for (int i = 0; i < widget.titles.length; i++)
            DataColumn(
              label: AppText(
                txt: widget.titles[i],
                size: 20,
                color: AppConst.black,
                weight: FontWeight.bold,
              ),
              onSort: (int columnIndex, bool ascending) {
                _sort<String>(
                    (d) => d[widget.titles[columnIndex]
                            .toLowerCase()
                            .replaceAll(' ', '')]
                        .toString(),
                    columnIndex,
                    ascending);
              },
            ),
          DataColumn(
            label: AppText(
              txt: 'Actions',
              size: 20,
              color: AppConst.black,
              weight: FontWeight.bold,
            ),
          ),
        ],
        source: _DataSource(context, widget),
        rowsPerPage: _rowsPerPage,
        availableRowsPerPage: availableRowsPerPage,
        onRowsPerPageChanged: (int? value) {
          setState(() {
            _rowsPerPage = value!;
          });
        },
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAscending,
      ),
    );
  }
}

class _DataSource extends DataTableSource {
  final BuildContext context;
  final ReusableTable2 widget;

  _DataSource(this.context, this.widget);

  @override
  DataRow getRow(int index) {
    final row = widget.data[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        for (String title in widget.titles)
          DataCell(
            title == 'Quantity'
                ? AppInputText(
                    keyboardType: TextInputType.number,
                    textsColor: AppConst.black,
                    ispassword: false,
                    fillcolor: AppConst.white,
                    label: 'Quantity',
                    obscure: false,
                    isemail: false,
                    isPhone: false,
                    initialValue: row['quantity'],
                    onChange: (value) {
                      // Update the quantity in the data
                      final newQuantity = double.tryParse(value) ?? 0;
                      final price = double.tryParse(row['price']) ?? 0;
                      final newTotal = (price * newQuantity).toString();

                      row['quantity'] = value;
                      row['total'] = newTotal;
                      // Notify listeners to refresh the table
                      notifyListeners();
                    },
                  )
                : widget.cellBuilder(context, row, title),
          ),
        DataCell(
          CustomPopover(
            icon: Icons.more_vert,
            items: [
              CustomPopoverItem(
                title: 'Edit',
                icon: Icons.edit,
                onTap: () {
                  // Handle edit action
                },
              ),
              CustomPopoverItem(
                title: 'Delete',
                icon: Icons.delete,
                onTap: () async {
                  // Delete the item
                  // deleteServices deleteService = deleteServices();
                  // await deleteService.delete(context, widget.url, row['id'].toString());
                  await widget.fetchData();
                  if (widget.onClose != null) {
                    await widget.onClose!();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  int get rowCount => widget.data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
