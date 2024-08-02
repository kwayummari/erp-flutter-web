import 'package:flutter/material.dart';

class PurchaseDataNotifier extends ChangeNotifier {
  List<Map<String, dynamic>> data = [];

  void updateData(List<Map<String, dynamic>> newData) {
    data = newData;
    notifyListeners();
  }

  void addNewRow(Map<String, dynamic> newRow) {
    data.add(newRow);
    notifyListeners();
  }
}
