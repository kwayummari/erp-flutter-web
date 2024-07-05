import 'package:erp/src/gateway/dropdown-service.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';

class DropdownTextFormField extends StatefulWidget {
  final String labelText;
  final Icon? icon;
  final Color? fillcolor;
  final Color? dropdownColor;
  final IconButton? suffixicon;
  final String apiUrl;
  final String valueField;
  final String displayField;
  final String dataOrigin;
  final void Function(String?)? onChanged;
  final void Function()? refreshSuppliers;
  final Color? textsColor;
  final bool? enabled;
  final bool? fetchSupplier;
  final double? circle;
  final FontWeight? labelWeight;
  final String? initialValue;

  DropdownTextFormField({
    required this.labelText,
    this.icon,
    this.suffixicon,
    required this.fillcolor,
    required this.dropdownColor,
    required this.apiUrl,
    required this.valueField,
    required this.displayField,
    required this.dataOrigin,
    this.onChanged,
    this.refreshSuppliers,
    this.fetchSupplier,
    this.textsColor,
    this.enabled,
    this.circle,
    this.labelWeight,
    this.initialValue,
  });

  @override
  State<DropdownTextFormField> createState() => _DropdownTextFormFieldState();
}

class _DropdownTextFormFieldState extends State<DropdownTextFormField> {
  late Future<List<DropdownMenuItem<String>>> _itemsFuture;
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    if (widget.fetchSupplier ?? false) {
      _itemsFuture = _getItems();
    }
    _selectedValue = widget.initialValue;
  }

  @override
  void didUpdateWidget(DropdownTextFormField oldWidget) {
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
    final data = await _dropdownService.dropdownPost(context, widget.apiUrl);
    final dropDownData = data[widget.dataOrigin];

    return dropDownData
        .map<DropdownMenuItem<String>>((item) => DropdownMenuItem<String>(
              value: item[widget.valueField].toString(),
              child: AppText(
                txt: item[widget.displayField],
                size: 15,
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
            return const CircularProgressIndicator();
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
                            widget.onChanged!(value);
                          }
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
