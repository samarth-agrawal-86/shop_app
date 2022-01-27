import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _userId;
  String? _token;
  DateTime? _tokenExpiry;
  Timer? _authTimer;

  bool get isAuth {
    if (_token != null &&
        _tokenExpiry != null &&
        _tokenExpiry!.isAfter(DateTime.now())) {
      return true;
    } else {
      return false;
    }
  }

  String? get getToken {
    return _token;
  }

  String? get getUserId {
    return _userId;
  }

  void _authenticate(
      {required String email,
      required String password,
      required bool signupFlag}) async {
    const _baseUrl = 'identitytoolkit.googleapis.com';
    Map<String, String> parameters = {
      'key': 'AIzaSyCvOAAeWGtbquAWJI-qHh9Iup5xqJXZTpE',
    };
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    Uri url = Uri.https(
      _baseUrl,
      signupFlag ? '/v1/accounts:signUp' : '/v1/accounts:signInWithPassword',
      parameters,
    );

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );
    final responseData = jsonDecode(response.body);
    //print(responseData);
    if (responseData['error'] != null) {
      //print(responseData['error']['message']);
      throw HttpException(responseData['error']['message']);
    }
    _token = responseData['idToken'];
    _userId = responseData['localId'];
    _tokenExpiry = DateTime.now().add(
      Duration(
        seconds: int.parse(responseData['expiresIn']),
      ),
    );

    final prefs = await SharedPreferences.getInstance();
    // Now we can use prefs to write / read data to shared preferences
    // Write data using SET methods. Read data using GET methods.
    // if you have more comnplex data you can use jsonEncode. which converts into a String
    // Let's have a look at it in 2 step process
    final userData = {
      'token': _token,
      'userId': _userId,
      'tokenExpiry':
          _tokenExpiry == null ? '' : _tokenExpiry!.toIso8601String(),
    };
    // Now we will convert this into json
    final userDataJson = jsonEncode(userData);

    // Now we will store it into a prefs object.
    // This is always stored as key, value pairs
    prefs.setString('userData', userDataJson);
  }

  Future<bool> userAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    // if user is coming first time then they won't have stored data. so let's check that first
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final Map<String, dynamic> prefsExtractedData =
        jsonDecode(prefs.getString('userData')!);
    final expiryDate = DateTime.parse(prefsExtractedData['tokenExpiry']);
    // if token expiry date is in the past then again we return false
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = prefsExtractedData['token'];
    _userId = prefsExtractedData['userId'];
    _tokenExpiry = expiryDate;
    notifyListeners();
    _UserAutoLogout();
    return true;
  }

  Future<void> userLogin(String email, String password) async {
    _authenticate(
      email: email,
      password: password,
      signupFlag: false,
    );
    _UserAutoLogout();
    notifyListeners();
  }

  Future<void> userSignUp(String email, String password) async {
    _authenticate(
      email: email,
      password: password,
      signupFlag: true,
    );
    notifyListeners();
  }

  Future<void> userLogout() async {
    _token = null;
    _userId = null;
    _tokenExpiry = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    //prefs.remove('userData');
    prefs.clear();
    notifyListeners();
  }

  void _UserAutoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    if (_tokenExpiry != null) {
      final timeToExpiry = _tokenExpiry!.difference(DateTime.now()).inSeconds;
      _authTimer = Timer(
        Duration(seconds: timeToExpiry),
        userLogout,
      );
    }
  }
}
