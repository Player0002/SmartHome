import 'package:flutter/cupertino.dart';

class MainPositionProvider extends ChangeNotifier {
  int _value = 1;
  int get value => _value;
  set value(val) {
    _value = val;
    notifyListeners();
  }
}
