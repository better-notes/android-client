import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({
    required this.removeValue,
    required this.setStateToEnter,
  });
  final Function(String) removeValue;
  final VoidCallback setStateToEnter;
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
        ),
        body: Container(
          child: Container(
              child: ListView(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Material(
                    child: InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        await widget.removeValue('authToken');
                        widget.setStateToEnter();
                      },
                      child: ListTile(
                        title: Text(
                          'Log out',
                        ),
                      ),
                    ),
                  ))
            ],
          )),
        ));
  }
}
