import 'package:flutter/cupertino.dart';

class FcmProvider extends ChangeNotifier {
  String _token;
  FcmProvider(String token) {
    _token = token;
  }

  String get token => _token;
  set token(String token) {
    _token = token;
    notifyListeners();
  }
}
