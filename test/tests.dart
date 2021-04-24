import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class TestClient extends IOClient {
  late String body;
  late int statusCode;

  TestClient(String body, int statusCode) {
    this.body = body;
    this.statusCode = statusCode;
  }

  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    return http.Response(this.body, this.statusCode);
  }
}

void main() {
  // test('register() function test', () async {
  //   var username = 'Daniil';
  //   var password1 = '2323';
  //   var password2 = '2323';

  //   var testClient = TestClient(
  //       '{"value": "5fb09a004cbfdb649ee543580d5644236823460bbffa3a63f318039dcfd85d7a"}',
  //       200);
  //   // var testClient = IOClient();
  //   var token = await register(testClient, username, password1, password2);
  //   // print(token.value);
  //   expect(
  //       token,
  //       equals(Token(
  //           '5fb09a004cbfdb649ee543580d5644236823460bbffa3a63f318039dcfd85d7a')));
  // });
}
