import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/pages/enter.dart';
import 'package:flutter_application_1/pages/loadScreen.dart';
import 'package:flutter_application_1/pages/preload.dart';
import 'package:flutter_application_1/theming.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MediaQuery(
      data: MediaQueryData(),
      child: ChangeNotifierProvider<ThemeChanger>(
        create: (_) => ThemeChanger(),
        child: Builder(
          builder: (BuildContext context) {
            final themeChanger = Provider.of<ThemeChanger>(context);
            return MaterialApp(
                title: 'BetterNotes',
                themeMode: themeChanger.getTheme,
                theme: ThemeData(
                    brightness: Brightness.light,
                    visualDensity:
                        VisualDensity(vertical: 0.5, horizontal: 0.5),
                    primarySwatch: MaterialColor(
                      0xFF323C59,
                      <int, Color>{
                        50: Color(0xFF323C59),
                        100: Color(0xFF323C59),
                        200: Color(0xFF323C59),
                        300: Color(0xFF323C59),
                        400: Color(0xFF323C59),
                        500: Color(0xFF323C59),
                        600: Color(0xFF323C59),
                        700: Color(0xFF323C59),
                        800: Color(0xFF323C59),
                        900: Color(0xFF323C59)
                      },
                    ),
                    primaryColor: Color(0xffD4D4D4),
                    primaryColorBrightness: Brightness.light,
                    primaryColorLight: Color(0xff7283A6),
                    primaryColorDark: Color(0xff323C59),
                    canvasColor: Colors.white,
                    accentColorBrightness: Brightness.light,
                    scaffoldBackgroundColor: Colors.white,
                    accentColor: Color(0xFF323C59),
                    bottomAppBarColor: Colors.white,
                    cardColor: Colors.white,
                    buttonColor: Color(0xFF323C59),
                    dividerColor: Color(0x1f6D42CE),
                    inputDecorationTheme: InputDecorationTheme(
                      focusColor: Color(0xFF323C59),
                      hoverColor: Color(0xFF323C59),
                    ),
                    primaryIconTheme: IconThemeData(color: Color(0xFF323C59)),
                    accentIconTheme: IconThemeData(color: Color(0xFF323C59)),
                    focusColor: Color(0x1aF5E0C3)),
                darkTheme: ThemeData(
                    brightness: Brightness.dark,
                    visualDensity:
                        VisualDensity(vertical: 0.5, horizontal: 0.5),
                    primaryColor: Color(0xFF424240),
                    primaryColorBrightness: Brightness.dark,
                    primaryColorLight: Color(0xFF424240),
                    primaryColorDark: Color(0xFF424240),
                    canvasColor: Color(0xFF202124),
                    accentColor: Color(0xFFFFC700),
                    accentColorBrightness: Brightness.dark,
                    scaffoldBackgroundColor: Color(0xFF202124),
                    bottomAppBarColor: Color(0xFF202124),
                    cardColor: Color(0xFF202124),
                    buttonColor: Color(0xFFFFC700),
                    primarySwatch: MaterialColor(
                      0xFFFFC700,
                      <int, Color>{
                        50: Color(0xFF323C59),
                        100: Color(0xFF323C59),
                        200: Color(0xFF323C59),
                        300: Color(0xFF323C59),
                        400: Color(0xFF323C59),
                        500: Color(0xFF323C59),
                        600: Color(0xFF323C59),
                        700: Color(0xFF323C59),
                        800: Color(0xFF323C59),
                        900: Color(0xFF323C59)
                      },
                    ),
                    dividerColor: Colors.black,
                    focusColor: Colors.black),
                home: MyApp());
          },
        ),
      )));
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
    var isDarkModeOn = await storage.read(key: 'isDarkModeOn');
    if (isDarkModeOn == null || isDarkModeOn == 'false') {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        final themeChanger = Provider.of<ThemeChanger>(context, listen: false);
        themeChanger.setTheme(ThemeMode.light);
      });
    } else {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        final themeChanger = Provider.of<ThemeChanger>(context, listen: false);
        themeChanger.setTheme(ThemeMode.dark);
      });
    }
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    switch (_appState) {
      case appPageState.preload:
        return PreloadPage();
      case appPageState.enter:
        return EnterPage(
            setAppStateHome: _setAppStateHome, setValue: _setValue);
      case appPageState.home:
        return LoadScreenPage(
          stateToken: stateToken,
          removeValue: _removeValue,
          setStateToEnter: _setAppStateEnter,
          setStateToHome: _setAppStateHome,
          storage: storage,
        );
      default:
        return PreloadPage();
    }
  }
}
