import 'package:flutter/material.dart';

class RowDataProvider with ChangeNotifier {
  Map<String, dynamic>? _rowData;
  bool _isUpdating = false;

  Map<String, dynamic>? get rowData => _rowData;
  bool get isUpdating => _isUpdating;

  void setRowData(Map<String, dynamic> data) {
    _isUpdating = true;
    _rowData = data;
    _isUpdating = false;
    notifyListeners();
  }

  void clearRowData() {
    _rowData = null;
    notifyListeners();
  }
}
