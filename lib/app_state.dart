import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  String? token;
  String? email;

  bool get isLoggedIn => token != null;

  void login(String jwt, String userEmail) {
    token = jwt;
    email = userEmail;
    notifyListeners();
  }

  void logout() {
    token = null;
    email = null;
    notifyListeners();
  }
}
