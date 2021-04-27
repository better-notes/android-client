import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_1/theming.dart' as theming;

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Widget appLogo = SvgPicture.asset(
    'assets/grid-dynamic.svg',
    height: 30,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          backgroundColor: theming.headerColor,
          foregroundColor: Colors.white,
        ),
        body: Container(
          decoration: BoxDecoration(color: Color(0xFF0E1621)),
          child: Container(
              child: ListView(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Material(
                    color: theming.inputColor,
                    child: InkWell(
                      onTap: () async {
                        // Navigator.pop(context);
                        // await widget.removeValue('authToken');
                        // widget.setAppStateEnter();
                      },
                      child: ListTile(
                        trailing: Icon(Icons.logout, color: Colors.white),
                        tileColor: Colors.transparent,
                        title: Text(
                          'Log out',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ))
            ],
          )),
        ));
  }
}
