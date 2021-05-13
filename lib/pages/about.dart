import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final Widget appLogo = SvgPicture.asset(
    'assets/grid-dynamic.svg',
    height: 30,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('About'),
        ),
        body: Container(
          child: Container(
            child: Center(child: Text('About')),
          ),
        ));
  }
}
