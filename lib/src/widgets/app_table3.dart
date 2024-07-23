import 'package:erp/src/screens/purchaseOrder/addNewOrderForm.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_button.dart';
import 'package:erp/src/widgets/app_modal.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReusableTable3 extends StatefulWidget {
  final List<String> titles;
  final String url;
  final double deleteModalWidth;
  final double deleteModalHeight;
  final double editModalWidth;
  final double editModalHeight;
  final String? supplierId;
  final String? orderId;
  final String? randomNumber;
  final List<Map<String, dynamic>> data;
  final Function fetchData;
  final Future<void> Function()? fetchData1;
  final double columnSpacing;
  final Widget Function(BuildContext, Map<String, dynamic>, String) cellBuilder;
  final Future<void> Function()? onClose;

  const ReusableTable3({
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
    required this.supplierId,
    required this.orderId,
    required this.randomNumber,
    required this.fetchData1,
  }) : super(key: key);

  @override
  _ReusableTable3State createState() => _ReusableTable3State();
}

class _ReusableTable3State extends State<ReusableTable3> {
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
        headingRowColor: MaterialStateProperty.all(AppConst.grey200),
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
              txt: 'Quantity Received',
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
  final ReusableTable3 widget;
  final VoidCallback updateParentState;
  final Map<int, TextEditingController> _controllers = {};

  _DataSource(this.context, this.widget, this.updateParentState);

  void addNewRow() {
    final newRow = <String, dynamic>{};
    for (var title in widget.titles) {
      final key = title.toLowerCase().replaceAll(' ', '');
      newRow[key] = '';
    }
    widget.data.add(newRow);
    notifyListeners();
    updateParentState();
  }

  Future<void> updateQuantityReceived(String orderedId, String quantityReceived) async {
    final url = '${widget.url}/$orderedId';
    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'quantityReceived': quantityReceived,
      }),
    );

    if (response.statusCode == 200) {
      print('Update successful');
    } else {
      print('Failed to update');
    }
  }

  @override
  DataRow getRow(int index) {
    if (widget.data.isEmpty) {
      return DataRow(
        cells: List<DataCell>.generate(
          widget.titles.length + 1,
          (i) => DataCell(
            i == 2
                ? Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        AppText(
                          txt: widget.supplierId != null
                              ? 'No data at the moment'
                              : 'Please select Supplier',
                          size: 20,
                          fontStyle: FontStyle.italic,
                          color: AppConst.black,
                        ),
                        if (widget.supplierId != null)
                          AppButton(
                            onPress: () {
                              ReusableModal.show(
                                width: 500,
                                height: 250,
                                context,
                                AppText(
                                  txt: 'Add New Order',
                                  size: 22,
                                  weight: FontWeight.bold,
                                ),
                                onClose: widget.fetchData1,
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    AddNewOrderForm(
                                      supplierId: widget.supplierId,
                                      fetchData: widget.fetchData,
                                      randomNumber: widget.randomNumber.toString(),
                                      buttonWidth: 500,
                                    ),
                                  ],
                                ),
                              );
                            },
                            label: 'Create new order',
                            borderRadius: 5,
                            textColor: AppConst.white,
                            solidColor: AppConst.black,
                          )
                      ],
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

    // Initialize the TextEditingController if it doesn't exist
    _controllers.putIfAbsent(index, () => TextEditingController());

    return DataRow.byIndex(
      index: index,
      cells: [
        for (String title in widget.titles)
          DataCell(
            widget.cellBuilder(context, row, title),
          ),
        DataCell(
          TextField(
            controller: _controllers[index],
            onChanged: (value) async {
              row['quantityreceived'] = value;
              await updateQuantityReceived(row['orderedId'].toString(), value);
            },
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
