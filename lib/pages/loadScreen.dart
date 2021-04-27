import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/data/readNotes.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_1/theming.dart' as theming;
import 'package:flutter_application_1/main.dart';

class LoadScreenPage extends StatefulWidget {
  LoadScreenPage({
    required this.stateToken,
  });
  final String stateToken;
  @override
  _LoadScreenPageState createState() => _LoadScreenPageState();
}

class _LoadScreenPageState extends State<LoadScreenPage> {
  final Widget appLogo = SvgPicture.asset(
    'assets/grid-dynamic.svg',
    height: 30,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(color: theming.headerColor),
      child: Center(
        child: FutureBuilder<dynamic>(
          future: readNotes('descending', 20, 0, widget.stateToken),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            Widget child;
            if (snapshot.hasData) {
              child = HomePage(
                notes: snapshot.data,
                stateToken: widget.stateToken,
              );
            } else if (snapshot.hasError) {
              child = Center(child: appLogo);
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(snapshot.error.toString()),
                    duration: Duration(milliseconds: 15000),
                    width: 280.0, // Width of the SnackBar.
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.0), // Inner padding for SnackBar content.
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                );
              });
            } else {
              child = Center(child: appLogo);
            }
            return Center(
              child: child,
            );
          },
        ),
      ),
    ));
  }
}
