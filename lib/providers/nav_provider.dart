import 'package:flutter/material.dart';

class NavProvider extends ChangeNotifier {
  int _index = 0;

  int get index => _index;

  void setIndex(int value) {
    _index = value;
    notifyListeners();
  }

  void clearAllData() {
    _index = 0;

    notifyListeners();
  }
}
