import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PreloadPage extends StatelessWidget {
  final Widget appLogo = SvgPicture.asset(
    'assets/grid-dynamic.svg',
    height: 30,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Container(
        child: Center(child: appLogo),
      ),
    ));
  }
}
