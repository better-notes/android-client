import 'package:flutter/material.dart';

const headerColor = const Color(0xFF17212B);
const inputColor = const Color(0xFF242F3D);

class ThemeChanger with ChangeNotifier {
  var _themeMode = ThemeMode.light;
  get getTheme => _themeMode;
  setTheme(themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }
}
