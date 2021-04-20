import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/pages/enter.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:flutter_application_1/pages/preload.dart';
// import 'package:flutter_application_1/images/logo.dart';
import 'package:flutter_application_1/theming.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(title: 'BetterNotes', home: MyApp())));
}

enum appPageState { home, enter, preload }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _storage = FlutterSecureStorage();

  final Widget appLogo = SvgPicture.asset(
    'assets/grid-dynamic.svg',
    height: 30,
  );
  var _appState = appPageState.preload;

  void _setValue(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  _getValue(String key) async {
    var token = await _storage.read(key: key);
    return token;
  }

  void _removeValue(String key) async {
    await _storage.delete(key: key);
  }

  void _setAppStateHome() {
    setState(() {
      _appState = appPageState.home;
    });
  }

  void _setAppStateEnter() {
    setState(() {
      _appState = appPageState.enter;
    });
  }

  @override
  void initState() {
    super.initState();
    storeCheck();
  }

  void storeCheck() async {
    var token = await _getValue('authToken');
    print(token);
    if (token == null) {
      setState(() {
        _appState = appPageState.enter;
      });
    } else {
      setState(() {
        _appState = appPageState.home;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_appState) {
      case appPageState.preload:
        return PreloadPage();
      case appPageState.enter:
        return EnterPage(
            setAppStateHome: _setAppStateHome, setValue: _setValue);
      case appPageState.home:
        return HomePage();
      default:
        return PreloadPage();
    }
  }
}
