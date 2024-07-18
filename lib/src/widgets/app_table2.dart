import 'package:erp/src/gateway/deleteService.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app-dropdown.dart';
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
    final _DataSource dataSource =
        _DataSource(context, widget, _updateParentState);
    return SingleChildScrollView(
      child: PaginatedDataTable(
        dataRowMaxHeight: 70,
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
        source: dataSource,
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

  void _updateParentState() {
    setState(() {
      // Call any necessary updates here
    });
  }
}

class _DataSource extends DataTableSource {
  final BuildContext context;
  final ReusableTable2 widget;
  final VoidCallback updateParentState;

  _DataSource(this.context, this.widget, this.updateParentState);

  void addNewRow() {
    final newRow = <String, dynamic>{};
    for (var title in widget.titles) {
      final key = title.toLowerCase().replaceAll(' ', '');
      newRow[key] = ''; // Initialize new row with empty values
    }
    widget.data.add(newRow);
    notifyListeners();
    updateParentState();
  }

  @override
  DataRow getRow(int index) {
    if (widget.data.isEmpty) {
      return DataRow(
        cells: List<DataCell>.generate(
          widget.titles.length + 1,
          (i) => DataCell(
            i == 0
                ? Center(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'No data at the moment',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: AppConst.black,
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ),
        ),
      );
    }

    if (index >= widget.data.length) {
      return DataRow(cells: []);
    }

    final row = widget.data[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        for (String title in widget.titles)
          DataCell(
            widget.cellBuilder(context, row, title),
          ),
        DataCell(
          CustomPopover(
            icon: Icons.more_vert,
            items: [
              CustomPopoverItem(
                title: 'Delete',
                icon: Icons.delete,
                onTap: () async {
                  deleteServices deleteService = deleteServices();
                  await deleteService.delete(
                      context, widget.url, row['id'].toString());
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
  int get rowCount => widget.data.isEmpty ? 1 : widget.data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
