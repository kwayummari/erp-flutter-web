import 'package:erp/src/gateway/dropdown-service.dart';
import 'package:erp/src/utils/animations/shimmers/dropdown.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';

class DropdownTextFormFieldV2 extends StatefulWidget {
  final String labelText;
  final Icon? icon;
  final Color? fillcolor;
  final Color? dropdownColor;
  final IconButton? suffixicon;
  final String apiUrl;
  final String valueField;
  final String displayField;
  final String? displayField2;
  final String dataOrigin;
  final void Function(String?, List?)? onChanged;
  final void Function()? refreshSuppliers;
  final void Function(List<Map<String, dynamic>>)? onDataChanged;
  final Color? textsColor;
  final bool? enabled;
  final bool? fetchSupplier;
  final double? circle;
  final labelWeight;
  final String? initialValue;
  String? valueHolder;
  List allData;
  bool? doubleDisplay;

  DropdownTextFormFieldV2(
      {required this.labelText,
      this.icon,
      this.suffixicon,
      required this.fillcolor,
      required this.dropdownColor,
      required this.apiUrl,
      required this.valueField,
      required this.displayField,
      required this.dataOrigin,
      this.displayField2,
      this.onChanged,
      this.refreshSuppliers,
      this.fetchSupplier,
      this.textsColor,
      this.enabled,
      this.circle,
      this.labelWeight,
      this.initialValue,
      required this.allData,
      this.valueHolder,
      this.onDataChanged,
      this.doubleDisplay});

  @override
  State<DropdownTextFormFieldV2> createState() =>
      _DropdownTextFormFieldV2State();
}

class _DropdownTextFormFieldV2State extends State<DropdownTextFormFieldV2> {
  late Future<List<DropdownMenuItem<String>>> _itemsFuture;
  String? _selectedValue;
  late List<Map<String, dynamic>> _apiData;

  @override
  void initState() {
    super.initState();
    _itemsFuture = _getItems();
    _selectedValue = widget.initialValue;
  }

  @override
  void didUpdateWidget(DropdownTextFormFieldV2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.fetchSupplier != oldWidget.fetchSupplier &&
        widget.fetchSupplier == true) {
      setState(() {
        _itemsFuture = _getItems();
        widget.refreshSuppliers;
      });
    }
  }

  Future<List<DropdownMenuItem<String>>> _getItems() async {
    final dropdownService _dropdownService = await dropdownService();
    final apiResponse =
        await _dropdownService.dropdownPost(context, widget.apiUrl);
    _apiData = List<Map<String, dynamic>>.from(apiResponse[widget.dataOrigin]);

    // Update allData with the fetched data
    widget.allData = _apiData;
    if (widget.onDataChanged != null) {
      widget.onDataChanged!(_apiData);
    }

    return _apiData
        .map<DropdownMenuItem<String>>((item) => DropdownMenuItem<String>(
              value: item[widget.valueField].toString(),
              child: AppText(
                txt: widget.doubleDisplay == true
                    ? item[widget.displayField] +
                        '(' +
                        item[widget.displayField2] +
                        ')'
                    : item[widget.displayField],
                size: 12,
                color: AppConst.black,
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
      child: FutureBuilder<List<DropdownMenuItem<String>>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return dropdownShimmer(width: 400, height: 50, borderRadius: 5.0);
          } else if (snapshot.hasError) {
            return Text('Failed to fetch items: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final items = snapshot.data!;
            if (items.isNotEmpty) {
              return DropdownButtonFormField<String>(
                value: _selectedValue,
                dropdownColor: widget.dropdownColor,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.circle ?? 5.0),
                  ),
                  label: Container(
                    color: widget.fillcolor,
                    child: AppText(
                      txt: widget.labelText,
                      size: 15,
                      weight: widget.labelWeight ?? FontWeight.w700,
                      color: widget.textsColor ?? AppConst.white,
                    ),
                  ),
                  filled: true,
                  fillColor: widget.fillcolor,
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.circle ?? 5.0),
                    borderSide: BorderSide(color: AppConst.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.circle ?? 5.0),
                    borderSide: BorderSide(color: AppConst.black),
                  ),
                  prefixIcon: widget.icon,
                  suffixIcon: widget.suffixicon,
                ),
                items: items,
                onChanged: widget.enabled ?? true
                    ? (value) {
                        setState(() {
                          _selectedValue = value;
                          if (widget.onChanged != null) {
                            widget.onChanged!(value, widget.allData);
                          }
                          widget.valueHolder = value;
                          final selectedItem = _apiData.firstWhere(
                            (item) =>
                                item[widget.valueField].toString() == value,
                            orElse: () => {},
                          );
                          setState(() {
                            widget.allData = [selectedItem];
                          });
                        });
                      }
                    : null,
              );
            } else {
              return Text('No items found');
            }
          } else {
            return Text('Unexpected state');
          }
        },
      ),
    );
  }
}
