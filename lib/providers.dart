import 'package:flutter/material.dart';

class FormProvider with ChangeNotifier {
  String? textNameFieldValue = null;
  String? facilityNameFieldValue;
  DateTime? initialDateTimeValue = null;
  DateTime? finalDateTimeValue = null;
  List<List<String>> items = [];
  int position = 0;

  void setTextNameFieldValue(String value) {
    textNameFieldValue = value;
    notifyListeners();
  }

  void setFacilityNameFieldValue(String value) {
    facilityNameFieldValue = value;
    notifyListeners();
  }

  void setInitialDateTimeValue(DateTime? value) {
    initialDateTimeValue = value;
    notifyListeners();
  }

  void setFinalDateTimeValue(DateTime? value) {
    finalDateTimeValue = value;
    notifyListeners();
  }

  void addNewItem(List<String> elements) {
    items.add(elements);
  }

  void setPosition(int value) {
    position = value;
  }
}
