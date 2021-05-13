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
                      0xFFF5E0C3,
                      <int, Color>{
                        50: Color(0x1aF5E0C3),
                        100: Color(0xa1F5E0C3),
                        200: Color(0xaaF5E0C3),
                        300: Color(0xafF5E0C3),
                        400: Color(0xffF5E0C3),
                        500: Color(0xffEDD5B3),
                        600: Color(0xffDEC29B),
                        700: Color(0xffC9A87C),
                        800: Color(0xffB28E5E),
                        900: Color(0xff936F3E)
                      },
                    ),
                    primaryColor: Color(0xffEDD5B3),
                    primaryColorBrightness: Brightness.light,
                    primaryColorLight: Color(0x1aF5E0C3),
                    primaryColorDark: Color(0xff936F3E),
                    canvasColor: Color(0xffa8d9f1),
                    accentColor: Color(0xff457BE0),
                    accentColorBrightness: Brightness.light,
                    scaffoldBackgroundColor: Color(0xffB5BFD3),
                    bottomAppBarColor: Color(0xff6D42CE),
                    cardColor: Color(0xaaF5E0C3),
                    dividerColor: Color(0x1f6D42CE),
                    focusColor: Color(0x1aF5E0C3)),
                darkTheme: ThemeData(
                    brightness: Brightness.dark,
                    visualDensity:
                        VisualDensity(vertical: 0.5, horizontal: 0.5),
                    primarySwatch: MaterialColor(
                      0xFFF5E0C3,
                      <int, Color>{
                        50: Color(0x1a5D4524),
                        100: Color(0xa15D4524),
                        200: Color(0xaa5D4524),
                        300: Color(0xaf5D4524),
                        400: Color(0x1a483112),
                        500: Color(0xa1483112),
                        600: Color(0xaa483112),
                        700: Color(0xff483112),
                        800: Color(0xaf2F1E06),
                        900: Color(0xff2F1E06)
                      },
                    ),
                    primaryColor: Color(0xff5D4524),
                    primaryColorBrightness: Brightness.dark,
                    primaryColorLight: Color(0x1a311F06),
                    primaryColorDark: Color(0xff936F3E),
                    canvasColor: Color(0xffE09E45),
                    accentColor: Color(0xff457BE0),
                    accentColorBrightness: Brightness.dark,
                    scaffoldBackgroundColor: Color(0xffB5BFD3),
                    bottomAppBarColor: Color(0xff6D42CE),
                    cardColor: Color(0xaa311F06),
                    dividerColor: Color(0x1f6D42CE),
                    focusColor: Color(0x1a311F06)),
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
