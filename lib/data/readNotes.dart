import 'dart:convert';
import 'dart:io';
import 'package:flutter_application_1/settings.dart';
import 'package:http/http.dart' as http;

Future<dynamic> readNotes(
  String createdAt,
  int limit,
  int offset,
  String authToken,
) async {
  var res;
  Cookie cookie = Cookie("authentication_token", authToken);
  try {
    res = await http.get(
        Uri.http(apiUrl, '/api/v1/note/read/', {
          'created_at': createdAt,
          'limit': '$limit',
          'offset': '$offset',
        }),
        headers: {
          "cookie": cookie.toString(),
        });
  } on SocketException {
    throw ('Network error. Please try later or check the connection.');
  }
  switch (res.statusCode) {
    case 200:
      print(res.body);
      List<dynamic> data =
          jsonDecode(Encoding.getByName('utf-8')!.decode(res.bodyBytes));
      List<Map<String, dynamic>> parsedData =
          new List<Map<String, dynamic>>.from(data);
      return parsedData;
    case 400:
      Map<String, dynamic> error = jsonDecode(res.body);
      throw (error['detail']);
    default:
      throw ('Failed to fetch notes');
  }
}
