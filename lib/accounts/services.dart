import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../settings.dart';

Future<dynamic> register(
    String username, String password1, String password2) async {
  var res;
  try {
    res = await http.post(
      Uri.http(
        apiUrl,
        '/api/v1/account/register/',
      ),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "username": username,
        "password1": password1,
        "password2": password2,
      }),
    );
  } on SocketException {
    throw ('Network error. Please try later or check the connection.');
  }
  switch (res.statusCode) {
    case 200:
      var setCookie = res.headers["set-cookie"];
      return Cookie.fromSetCookieValue(setCookie!).value;
    case 400:
      Map<String, dynamic> error = jsonDecode(res.body);
      throw (error['detail']);
    default:
      throw ('Failed to register');
  }
}

Future<dynamic> authenticate(String username, String password) async {
  var res;
  try {
    res = await http.post(
      Uri.http(
        apiUrl,
        '/api/v1/account/authenticate/',
      ),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );
  } on SocketException {
    throw ('Network error. Please try later or check the connection.');
  }
  switch (res.statusCode) {
    case 200:
      var setCookie = res.headers["set-cookie"];
      return Cookie.fromSetCookieValue(setCookie!).value;
    case 400:
      Map<String, dynamic> error = jsonDecode(res.body);
      throw (error['detail']);
    default:
      throw ('Failed to register');
  }
}
