import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/enter.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:flutter_application_1/pages/preload.dart';
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
    var token = await this._storage.read(key: 'authToken');
    print(token);
    if (token == null) {
      this._setAppStateEnter();
    } else {
      this._setAppStateHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_appState) {
      case appPageState.preload:
        return PreloadPage();
      case appPageState.enter:
        return EnterPage(
            setAppStateHome: this._setAppStateHome, storage: this._storage);
      case appPageState.home:
        return HomePage(
          setAppStateEnter: this._setAppStateEnter,
          storage: this._storage,
        );
      default:
        return PreloadPage();
    }
  }
}
