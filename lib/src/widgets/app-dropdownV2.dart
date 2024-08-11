import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:erp/src/gateway/dropdown-service.dart';
import 'package:flutter/material.dart';

class DropdownTextFormFieldV2 extends StatefulWidget {
  final String labelText;
  final Icon? icon;
  final Color? fillcolor;
  final Color? dropdownColor;
  final IconButton? suffixIcon;
  final String apiUrl;
  final String valueField;
  final String displayField;
  final String? displayField2;
  final String dataOrigin;
  final void Function(String?, List<Map<String, dynamic>>)? onChanged;
  final void Function(List<Map<String, dynamic>>)? onDataChanged;
  final Color? textsColor;
  final bool? enabled;
  final double? borderRadius;
  final FontWeight? labelWeight;
  final String? initialValue;
  List<Map<String, dynamic>> allData;

  DropdownTextFormFieldV2({
    required this.labelText,
    this.icon,
    this.suffixIcon,
    required this.fillcolor,
    required this.dropdownColor,
    required this.apiUrl,
    required this.valueField,
    required this.displayField,
    required this.dataOrigin,
    this.displayField2,
    this.onChanged,
    this.onDataChanged,
    this.textsColor,
    this.enabled,
    this.borderRadius,
    this.labelWeight,
    this.initialValue,
    required this.allData,
  });

  @override
  _DropdownTextFormFieldV2State createState() =>
      _DropdownTextFormFieldV2State();
}

class _DropdownTextFormFieldV2State extends State<DropdownTextFormFieldV2> {
  late SingleValueDropDownController _controller;
  List<DropDownValueModel> _dropdownItems = [];

  @override
  void initState() {
    super.initState();
    _controller = SingleValueDropDownController();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    try {
      final dropdownService _dropdownService = await dropdownService();
      final apiResponse =
          await _dropdownService.dropdownPost(context, widget.apiUrl);
      final apiData =
          List<Map<String, dynamic>>.from(apiResponse[widget.dataOrigin]);

      setState(() {
        _dropdownItems = apiData
            .map((item) => DropDownValueModel(
                  name: widget.displayField2 != null
                      ? '${item[widget.displayField]} (${item[widget.displayField2]})'
                      : item[widget.displayField],
                  value: item[widget.valueField],
                ))
            .toList();
        widget.allData = apiData; // Update allData
        if (widget.onDataChanged != null) {
          widget.onDataChanged!(apiData); // Notify with the updated data
        }
      });
    } catch (e) {
      // Handle error appropriately
      print('Error fetching dropdown data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
      child: DropDownTextField(
        controller: _controller,
        clearOption: true,
        enableSearch: true,
        searchKeyboardType: TextInputType.text,
        textFieldDecoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 5.0),
          ),
          label: Container(
            color: widget.fillcolor,
            child: Text(
              widget.labelText,
              style: TextStyle(
                fontSize: 15,
                fontWeight: widget.labelWeight ?? FontWeight.w700,
                color: widget.textsColor ?? Colors.black,
              ),
            ),
          ),
          filled: true,
          fillColor: widget.fillcolor,
          prefixIcon: widget.icon,
          suffixIcon: widget.suffixIcon,
        ),
        dropDownItemCount: 5,
        dropDownList: _dropdownItems,
        onChanged: (value) {
          if (value != null && value is DropDownValueModel) {
            final selectedValue = value.value;
            final selectedItem = widget.allData.firstWhere(
              (item) => item[widget.valueField] == selectedValue,
              orElse: () => {},
            );
            widget.onChanged?.call(selectedValue.toString(), widget.allData);
          }
        },
      ),
    );
  }
}
