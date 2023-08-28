import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  bool _isLoginIn = false;

  bool get isLoggedIn {
    return _isLoginIn;
  }

  void login() {
    _isLoginIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoginIn = false;
    notifyListeners();
  }
}
