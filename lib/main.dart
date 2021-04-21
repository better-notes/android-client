import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/pages/enter.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:flutter_application_1/pages/loadScreen.dart';
import 'package:flutter_application_1/pages/preload.dart';
// import 'package:flutter_application_1/images/logo.dart';
import 'package:flutter_application_1/theming.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(
          title: 'BetterNotes',
          theme: ThemeData(canvasColor: Color(0xFF0E1621)),
          home: MyApp())));
}

enum appPageState { home, enter, preload }

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final storage = FlutterSecureStorage();
  var stateToken;

  final Widget appLogo = SvgPicture.asset(
    'assets/grid-dynamic.svg',
    height: 30,
  );
  var _appState = appPageState.preload;

  void _setValue(String key, String value) async {
    stateToken = value;
    await storage.write(key: key, value: value);
  }

  getValue(String key) async {
    var token = await storage.read(key: key);
    return token;
  }

  void _removeValue(String key) async {
    await storage.delete(key: key);
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
    var token = await getValue('authToken');
    if (token == null) {
      setState(() {
        _appState = appPageState.enter;
      });
    } else {
      stateToken = token;
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
        return LoadScreenPage(
          stateToken: stateToken,
        );
      default:
        return PreloadPage();
    }
  }
}
