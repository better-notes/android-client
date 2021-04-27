import 'dart:convert';
import 'dart:io';
import 'package:flutter_application_1/settings.dart';
import 'package:http/http.dart' as http;

Future<dynamic> editNote(
  Map<String, dynamic> note,
  String authToken,
) async {
  var res;
  Cookie cookie = Cookie("authentication_token", authToken);
  try {
    res = await http.put(
        Uri.http(
          apiUrl,
          '/api/v1/note/update/',
        ),
        headers: {
          "cookie": cookie.toString(),
        },
        body: json.encode([note]));
  } on SocketException {
    throw ('Network error. Note has been updated locally.');
  }
  switch (res.statusCode) {
    case 200:
      List<dynamic> data =
          jsonDecode(Encoding.getByName('utf-8')!.decode(res.bodyBytes));
      List<Map<String, dynamic>> parsedData =
          new List<Map<String, dynamic>>.from(data);
      return parsedData[0];
    case 400:
      Map<String, dynamic> error = jsonDecode(res.body);
      throw (error['detail']);
    default:
      throw ('Failed delete note. Note has been updated locally');
  }
}
