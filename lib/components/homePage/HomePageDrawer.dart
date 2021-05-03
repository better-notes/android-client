import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/pages/about.dart';
import 'package:flutter_application_1/pages/features.dart';
import 'package:flutter_application_1/theming.dart' as theming;
import 'package:flutter_svg/flutter_svg.dart';

class HomePageDrawer extends StatelessWidget {
  HomePageDrawer({
    required this.removeValue,
    required this.setStateToEnter,
  });
  final Function(String) removeValue;
  final VoidCallback setStateToEnter;
  final Widget appLogo = SvgPicture.asset(
    'assets/grid-dynamic.svg',
    height: 10,
    width: 10,
  );
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
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
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Color(0xFFA4A4A4),
                  ),
                  title: Text(
                    'Log out',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    await removeValue('authToken');
                    setStateToEnter();
                  },
                ),
                Divider(color: Colors.black),
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
                        style: TextStyle(color: Colors.grey),
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
