import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shop_app/exceptions/http_exception.dart';

class Auth with ChangeNotifier {
  // ignore: unused_field
  String _token;
  // ignore: unused_field
  DateTime _expireDate;
  // ignore: unused_field
  String _userId;

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyB5ipVkw0O6DRaSBhP9L22DroxE8hplcVQ';
    final data = jsonEncode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    });

    try {
      final response = await http.post(url, headers: {}, body: data);
      final responseData = jsonDecode(response.body);

      if (responseData['error'] != null)
        throw HttpExeception(responseData['error']['message']);
      _token = responseData["idToken"];
      _userId = responseData["localId"];
      _expireDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData["expiresIn"])));
      autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final value = jsonEncode({
        'token': _token,
        'userId': _userId,
        'expireDate': _expireDate.toIso8601String(),
      });
      prefs.setString('auth', value);
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.get('auth');
    if (!prefs.containsKey('auth')) return false;

    final data = jsonDecode(prefs.getString('auth'));

    _token = data["token"];
    _userId = data["userId"];
    _expireDate = DateTime.parse(data["expireDate"]);
    notifyListeners();
    autoLogout();
    return isAuthenticated;
  }

  Future<void> signup(String email, String password) async {
    const url = 'signUp';
    return _authenticate(email, password, url);
  }

  Future<void> login(String email, String password) async {
    const url = 'signInWithPassword';
    return _authenticate(email, password, url);
  }

  void logout() {
    _token = null;
    _userId = null;
    _expireDate = null;

    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }

  String get token {
    return _token;
  }

  String get userId {
    return _userId;
  }

  bool get isAuthenticated {
    if (token != null && _expireDate != null) if (_expireDate
        .isAfter(DateTime.now())) return true;
    return false;
  }

  Timer _authTimer;
  void autoLogout() {
    if (_authTimer != null) _authTimer.cancel();
    final timer = _expireDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timer), logout);
  }
}
