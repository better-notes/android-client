import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/theming.dart' as theming;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Search'),
          backgroundColor: theming.headerColor,
          foregroundColor: Colors.white,
        ),
        body: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Color(0xFF0E1621)),
            child: Column(
              children: [
                Card(
                  child: Text('sdv'),
                )
              ],
            )));
  }
}
