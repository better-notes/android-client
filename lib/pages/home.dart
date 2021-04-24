import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/components/homePage/HomePageDrawer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_1/theming.dart' as theming;

class HomePage extends StatefulWidget {
  HomePage({
    required this.setAppStateEnter,
    required this.storage,
  });
  final VoidCallback setAppStateEnter;
  final FlutterSecureStorage storage;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Widget appLogo = SvgPicture.asset(
    'assets/grid-dynamic.svg',
    height: 30,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: HomePageDrawer(
          setAppStateEnter: widget.setAppStateEnter,
          storage: widget.storage,
        ),
        appBar: AppBar(
          title: Text('Better Notes'),
          backgroundColor: theming.headerColor,
          foregroundColor: Colors.white,
        ),
        body: Container(
          decoration: BoxDecoration(color: Color(0xFF0E1621)),
          child: Container(
            child: Center(child: Text('Home page')),
          ),
        ));
  }
}
