import 'package:flutter/material.dart';

class ReturnState extends ChangeNotifier{
  int returnCount = 0;

  needReturn() {
    returnCount++;
    notifyListeners();
  }

  returnPressed() {
    returnCount--;
    notifyListeners();
  }

  bool returnNeeded() {
    return returnCount > 0;
  }

  reset() {
    returnCount = 0;
    notifyListeners();
  }
}
