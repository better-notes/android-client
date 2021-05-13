import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/pages/about.dart';
import 'package:flutter_application_1/pages/features.dart';
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

  final Widget appLogo = SvgPicture.asset(
    'assets/grid-dynamic.svg',
    height: 40,
    width: 40,
  );

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
                        Center(
                          child: appLogo,
                        ),
                        Center(
                          child: Text(
                            'Better Notes',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Text(
                              'Account:',
                            ),
                            Spacer(),
                            Text(
                              this.userInfo['username'],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Created at:',
                            ),
                            Spacer(),
                            formatDate(userInfo['created_at']),
                          ],
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(),
                ),
                ListTile(
                  leading: Icon(
                    Icons.book,
                  ),
                  title: Text(
                    'About',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.info,
                  ),
                  title: Text(
                    'Better Notes Features',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FeaturesPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                  ),
                  title: Text(
                    'Log out',
                  ),
                  onTap: () async {
                    await removeValue('authToken');
                    setStateToEnter();
                  },
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
                      toggleTheme(value, themeChanger);
                    }),
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
