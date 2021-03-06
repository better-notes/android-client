import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/theming.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePageDrawer extends StatelessWidget {
  HomePageDrawer({
    required this.removeValue,
    required this.setStateToEnter,
    required this.userInfo,
    required this.storage,
  });
  final Function(String) removeValue;
  final VoidCallback setStateToEnter;
  final Map<String, dynamic> userInfo;
  final FlutterSecureStorage storage;

  Widget formatDate(String dateString) {
    var date = DateTime.parse(dateString);
    return Text(
      DateFormat('dd-MM-yyyy').format(date),
    );
  }

  bool themeToBoolean(ThemeChanger themechanger) {
    if (themechanger.getTheme == ThemeMode.dark) {
      return true;
    }
    return false;
  }

  toggleTheme(bool value, ThemeChanger themechanger) async {
    if (value == true) {
      themechanger.setTheme(ThemeMode.dark);
      await storage.write(key: 'isDarkModeOn', value: 'true');
    } else {
      themechanger.setTheme(ThemeMode.light);
      await storage.write(key: 'isDarkModeOn', value: 'false');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Spacer(),
                        Center(
                          child: SvgPicture.asset(
                            'assets/icon.svg',
                            height: 40,
                            width: 40,
                            color: Theme.of(context).buttonColor,
                          ),
                        ),
                        Center(
                          child: Text(
                            'Better Notes',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Text('Account: '),
                            Text(
                              '@${this.userInfo["username"]}',
                              style: TextStyle(
                                  color: Theme.of(context).buttonColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColor),
                ),
                SwitchListTile(
                    secondary: Icon(
                      Icons.brightness_2_outlined,
                    ),
                    title: Text(
                      'Dark mode',
                    ),
                    value: themeToBoolean(themeChanger),
                    onChanged: (bool value) {
                      HapticFeedback.vibrate();
                      toggleTheme(value, themeChanger);
                    }),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                  ),
                  title: Text(
                    'Log out',
                  ),
                  onTap: () async {
                    HapticFeedback.vibrate();
                    await removeValue('authToken');
                    setStateToEnter();
                  },
                ),
                Divider(),
              ],
            ),
          ),
          Container(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Better Notes v1.0.0+1',
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
