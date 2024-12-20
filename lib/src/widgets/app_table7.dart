import 'package:erp/src/gateway/deleteService.dart';
import 'package:erp/src/gateway/grnServices.dart';
import 'package:erp/src/provider/rowProvider.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_button.dart';
import 'package:erp/src/widgets/app_modal.dart';
import 'package:erp/src/widgets/app_popover.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReusableTable7 extends StatefulWidget {
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
  final Widget editForm;
  final Widget Function(BuildContext, Map<String, dynamic>, String) cellBuilder;
  final Future<void> Function()? onClose;

  const ReusableTable7(
      {Key? key,
      required this.deleteModalWidth,
      required this.deleteModalHeight,
      required this.editModalWidth,
      required this.editModalHeight,
      required this.fetchData,
      required this.editForm,
      required this.titles,
      required this.data,
      required this.deleteStatement,
      required this.editStatement,
      required this.cellBuilder,
      required this.url,
      required this.columnSpacing,
      required this.onClose})
      : super(key: key);

  @override
  _ReusableTable7State createState() => _ReusableTable7State();
}

class _ReusableTable7State extends State<ReusableTable7> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  List<int> availableRowsPerPage = const <int>[
    PaginatedDataTable.defaultRowsPerPage,
    PaginatedDataTable.defaultRowsPerPage * 2,
    PaginatedDataTable.defaultRowsPerPage * 5,
    PaginatedDataTable.defaultRowsPerPage * 10
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
                _sort<String>((d) => d[widget.titles[columnIndex]].toString(),
                    columnIndex, ascending);
              },
            ),
            DataColumn(
            label: AppText(
              txt: 'Reorder Level',
              size: 20,
              color: AppConst.black,
              weight: FontWeight.bold,
            ),
          ),
            DataColumn(
            label: AppText(
              txt: 'Selling Price',
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
  final ReusableTable7 widget;
  _DataSource(this.context, this.widget);
  @override
  DataRow getRow(int index) {
    final row = widget.data[index];
    final controller = TextEditingController(text: row['sellingPrice'].toString());
    final reorderController = TextEditingController(text: row['reorder'].toString());
    return DataRow.byIndex(index: index, cells: [
      for (String title in widget.titles)
        DataCell(Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget.cellBuilder(context, row, title),
        )),
        DataCell(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: TextStyle(color: AppConst.black),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                label: Container(
                  color: AppConst.white,
                  child: AppText(
                    txt: 'Reorder Level',
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
              enabled: true,
              controller: reorderController,
              onChanged: (value) async {
                GrnServices()
                    .editReorderLevel(context, row['id'].toString(), value);
                await widget.fetchData();
              },
            ),
          ),
        ),
        DataCell(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: TextStyle(color: AppConst.black),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                label: Container(
                  color: AppConst.white,
                  child: AppText(
                    txt: 'Selling price',
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
              enabled: true,
              controller: controller,
              onChanged: (value) async {
                GrnServices()
                    .editSellingPrice(context, row['id'].toString(), value);
                await widget.fetchData();
              },
            ),
          ),
        ),
      DataCell(Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomPopover(
          icon: Icons.more_vert,
          items: [
            CustomPopoverItem(
              title: 'Edit',
              icon: Icons.edit,
              onTap: () async {
                final provider =
                    Provider.of<RowDataProvider>(context, listen: false);
                if (provider.isUpdating) return;
                provider.setRowData(row);
                while (provider.isUpdating) {
                  await Future.delayed(Duration(seconds: 5));
                }
                ReusableModal.show(
                  width: widget.editModalWidth,
                  height: widget.editModalHeight,
                  context,
                  widget.editStatement,
                  onClose: widget.onClose,
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[widget.editForm],
                  ),
                  footer: Row(
                    children: [],
                  ),
                );
              },
            ),
            CustomPopoverItem(
              title: 'Delete',
              icon: Icons.delete,
              onTap: () {
                ReusableModal.show(
                  width: widget.deleteModalWidth,
                  height: widget.deleteModalHeight,
                  context,
                  widget.deleteStatement,
                  onClose: widget.onClose,
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.error,
                        color: AppConst.red,
                        size: 100,
                      ),
                      Container(
                        width: 400,
                        height: 50,
                        child: AppButton(
                            onPress: () async {
                              deleteServices deleteService = deleteServices();
                              await deleteService.delete(
                                  context, widget.url, row['id'].toString());
                              widget.fetchData();
                              Navigator.pop(context);
                            },
                            gradient: AppConst.primaryGradient,
                            label: 'Delete',
                            borderRadius: 5,
                            textColor: AppConst.white),
                      ),
                    ],
                  ),
                  footer: Row(
                    children: [],
                  ),
                );
              },
            ),
          ],
        ),
      )),
    ]);
  }

  @override
  int get rowCount => widget.data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
