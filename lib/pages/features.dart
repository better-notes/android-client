import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        ),
        body: Container(
          child: Container(
            child: Center(child: Text('Features')),
          ),
        ));
  }
}
