import 'package:flutter/material.dart';

class RowDataProvider with ChangeNotifier {
  Map<String, dynamic>? _rowData;

  Map<String, dynamic>? get rowData => _rowData;

  void setRowData(Map<String, dynamic> data) {
    _rowData = data;
    notifyListeners();
  }

  void clearRowData() {
    _rowData = null;
    notifyListeners();
  }
}
