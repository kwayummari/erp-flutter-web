import 'package:erp/src/gateway/deleteService.dart';
import 'package:erp/src/gateway/grnServices.dart';
import 'package:erp/src/screens/purchaseOrder/addNewOrderForm.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_button.dart';
import 'package:erp/src/widgets/app_modal.dart';
import 'package:erp/src/widgets/app_popover.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';

class ReusableTable5 extends StatefulWidget {
  final List<String> titles;
  final String url;
  final double deleteModalWidth;
  final double deleteModalHeight;
  final double editModalWidth;
  final double editModalHeight;
  final String? supplierId;
  final String? orderId;
  final String? randomNumber;
  final bool enabled;
  final List<Map<String, dynamic>> data;
  final Function fetchData;
  final Future<void> Function()? fetchData1;
  final double columnSpacing;
  final Widget Function(BuildContext, Map<String, dynamic>, String) cellBuilder;
  final Future<void> Function()? onClose;

  const ReusableTable5({
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
    required this.enabled,
  }) : super(key: key);

  @override
  _ReusableTable5State createState() => _ReusableTable5State();
}

class _ReusableTable5State extends State<ReusableTable5> {
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
              txt: 'Buying Price',
              size: 20,
              color: AppConst.black,
              weight: FontWeight.bold,
            ),
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
  final ReusableTable5 widget;
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

  @override
  DataRow getRow(int index) {
    if (widget.data.isEmpty) {
      return DataRow(
        cells: List<DataCell>.generate(
          widget.titles.length + 2,
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
                                      randomNumber:
                                          widget.randomNumber.toString(),
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
    _controllers.putIfAbsent(index, () {
      final controller = TextEditingController(text: row['buyingPrice'].toString());
      return controller;
    });

    return DataRow.byIndex(
      index: index,
      cells: [
        for (String title in widget.titles)
          DataCell(
            widget.cellBuilder(context, row, title),
          ),
        DataCell(
          TextField(
            style: TextStyle(color: AppConst.black),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              label: Container(
                color: AppConst.white,
                child: AppText(
                  txt: 'Buying price',
                  size: 15,
                  weight: FontWeight.w700,
                  color: AppConst.black,
                ),
              ),
              filled: true,
              fillColor: AppConst.white,
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(color: AppConst.black),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(color: AppConst.black),
              ),
            ),
            enabled: widget.enabled,
            controller: _controllers[index],
            onChanged: (value) async {
              GrnServices()
                  .editBuyingPrice(context, row['id'].toString(), value);
              await widget.fetchData();
            },
          ),
        ),
        DataCell(
          CustomPopover(
            icon: Icons.more_vert,
            items: [
              CustomPopoverItem(
                title: 'Delete',
                icon: Icons.delete,
                onTap: () async {
                  final orderedId = row['orderedId'].toString();
                  deleteServices deleteService = deleteServices();
                  await deleteService.delete(
                      context, widget.url, orderedId.toString());
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
