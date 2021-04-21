import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/pages/about.dart';
import 'package:flutter_application_1/pages/features.dart';
import 'package:flutter_application_1/pages/settings.dart';
import 'package:flutter_application_1/theming.dart' as theming;
import 'package:flutter_svg/flutter_svg.dart';

class HomePageDrawer extends StatelessWidget {
  HomePageDrawer({
    required this.setAppStateEnter,
    required this.removeValue,
  });
  final VoidCallback setAppStateEnter;
  final Function(String) removeValue;
  final Widget appLogo = SvgPicture.asset(
    'assets/grid-dynamic.svg',
    height: 30,
  );
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      color: Color(0xFF0E1621),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: appLogo,
            decoration: BoxDecoration(
              color: theming.headerColor,
            ),
          ),
          ListTile(
              title: Text(
                'Settings',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SettingsPage(
                            setAppStateEnter: setAppStateEnter,
                            removeValue: removeValue,
                          )),
                );
              }),
          ListTile(
            title: Text(
              'About',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
          ),
          ListTile(
            title: Text(
              'Better Notes Features',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeaturesPage()),
              );
            },
          ),
          Divider(color: Colors.black),
        ],
      ),
    ));
  }
}
