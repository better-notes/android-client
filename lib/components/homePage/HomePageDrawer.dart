import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/pages/about.dart';
import 'package:flutter_application_1/pages/features.dart';
import 'package:flutter_application_1/pages/settings.dart';
import 'package:flutter_application_1/theming.dart' as theming;
import 'package:flutter_svg/flutter_svg.dart';

class HomePageDrawer extends StatelessWidget {
  final Widget appLogo = SvgPicture.asset(
    'assets/grid-dynamic.svg',
    height: 10,
    width: 10,
  );
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
              leading: Icon(
                Icons.settings,
                color: Color(0xFFA4A4A4),
              ),
              title: Text(
                'Settings',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              }),
          ListTile(
            leading: Icon(
              Icons.book,
              color: Color(0xFFA4A4A4),
            ),
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
            leading: Icon(
              Icons.info,
              color: Color(0xFFA4A4A4),
            ),
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
    );
  }
}
