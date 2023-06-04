import 'package:flutter/cupertino.dart';

class MCALoginState extends ChangeNotifier {
  bool _isLoggedIn = true;

  bool get isLoggedIn => _isLoggedIn;

  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }
}
