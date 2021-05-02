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
    required this.removeValue,
    required this.setStateToEnter,
    required this.setStateToHome,
  });
  final String stateToken;
  final Function(String) removeValue;
  final VoidCallback setStateToEnter;
  final VoidCallback setStateToHome;
  @override
  _LoadScreenPageState createState() => _LoadScreenPageState();
}

class _LoadScreenPageState extends State<LoadScreenPage> {
  final Widget appLogo = SvgPicture.asset(
    'assets/grid-dynamic.svg',
    height: 30,
  );

  void returnToEnter() async {
    await widget.removeValue('authToken');
    widget.setStateToEnter();
  }

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
                removeValue: widget.removeValue,
                setStateToEnter: widget.setStateToEnter,
              );
            } else if (snapshot.hasError) {
              switch (snapshot.error) {
                case HttpError.failedToFindSession:
                  child = Center(child: appLogo);
                  returnToEnter();
                  break;
                default:
                  child = Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_off,
                        color: Colors.white,
                        size: 50,
                      ),
                      Text(
                        'Network error. Please try again',
                        style: TextStyle(color: Colors.white),
                      ),
                      ElevatedButton(
                        child: Text('Retry'),
                        onPressed: () {
                          widget.setStateToHome();
                        },
                      )
                    ],
                  ));
                  break;
              }
            } else {
              child = Center(
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    SizedBox(
                      child: CircularProgressIndicator(
                        backgroundColor: theming.headerColor,
                      ),
                      height: 100.0,
                      width: 100.0,
                    ),
                    appLogo,
                  ],
                ),
              );
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
