import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PreloadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Container(
        child: Center(
          child: SvgPicture.asset(
            'assets/icon.svg',
            height: 40,
            width: 40,
            color: Theme.of(context).buttonColor,
          ),
        ),
      ),
    ));
  }
}
