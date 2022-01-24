import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _tokenExpiry;

  Future<void> userSignIn(String email, String password) async {
    const _baseUrl = 'identitytoolkit.googleapis.com';
    Map<String, String> parameters = {
      'key': 'AIzaSyCvOAAeWGtbquAWJI-qHh9Iup5xqJXZTpE',
    };
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    Uri url = Uri.https(
      _baseUrl,
      '/v1/accounts:signInWithPassword',
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

    if (response.statusCode >= 400) {
      throw 'Error';
    }
    final responseData = jsonDecode(response.body);
    print(responseData);
  }

  Future<void> userSignUp(String email, String password) async {
    const _baseUrl = 'identitytoolkit.googleapis.com';
    Map<String, String> parameters = {
      'key': 'AIzaSyCvOAAeWGtbquAWJI-qHh9Iup5xqJXZTpE',
    };
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    Uri url = Uri.https(
      _baseUrl,
      '/v1/accounts:signUp',
      parameters,
    );
    print(url);
    // final url = Uri.parse(
    //     'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCvOAAeWGtbquAWJI-qHh9Iup5xqJXZTpE');
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

    if (response.statusCode >= 400) {
      throw 'Error';
    }
    final responseData = jsonDecode(response.body);
    print(responseData);
  }
}
