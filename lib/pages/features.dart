import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_1/theming.dart' as theming;

class FeaturesPage extends StatefulWidget {
  @override
  _FeaturesPageState createState() => _FeaturesPageState();
}

class _FeaturesPageState extends State<FeaturesPage> {
  final Widget appLogo = SvgPicture.asset(
    'assets/grid-dynamic.svg',
    height: 30,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Features'),
          backgroundColor: theming.headerColor,
          foregroundColor: Colors.white,
        ),
        body: Container(
          decoration: BoxDecoration(color: Color(0xFF0E1621)),
          child: Container(
            child: Center(child: Text('Features')),
          ),
        ));
  }
}
