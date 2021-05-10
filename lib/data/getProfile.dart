import 'dart:convert';
import 'dart:io';
import 'package:flutter_application_1/settings.dart';
import 'package:http/http.dart' as http;

Future<dynamic> getProfile(
  String authToken,
) async {
  var res;
  Cookie cookie = Cookie("authentication_token", authToken);
  try {
    res = await http.get(
        Uri.http(
          apiUrl,
          '/api/v1/account/profile/',
        ),
        headers: {
          "cookie": cookie.toString(),
        });
  } on SocketException {
    throw ('Network error. Cannot get the user info');
  }
  switch (res.statusCode) {
    case 200:
      var data = jsonDecode(Encoding.getByName('utf-8')!.decode(res.bodyBytes));
      Map<String, dynamic> parsedData = new Map<String, dynamic>.from(data);
      return parsedData;
    case 400:
      Map<String, dynamic> error = jsonDecode(res.body);
      throw (error['detail']);
    case 422:
      Map<String, dynamic> error = jsonDecode(res.body);
      throw (error['detail']);
    default:
      throw ('Failed delete note. Cannot get the user info');
  }
}
