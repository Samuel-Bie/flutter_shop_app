import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;
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

      notifyListeners();
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<void> signup(String email, String password) async {
    const url = 'signUp';
    return _authenticate(email, password, url);
  }

  Future<void> login(String email, String password) async {
    const url = 'signInWithPassword';
    return _authenticate(email, password, url);
  }

  String get token {
    return _token;
  }

  bool get isAuthenticated {
    if (token != null && _expireDate != null) if (_expireDate
        .isAfter(DateTime.now())) return true;
    return false;
  }
}
