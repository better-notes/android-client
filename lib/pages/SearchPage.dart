import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/data/readNotes.dart';
import 'package:flutter_application_1/theming.dart' as theming;

enum searchPageStates {
  empty,
  results,
  notFound,
  error,
}

class SearchPage extends StatefulWidget {
  SearchPage({required this.token});
  final String token;
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchQueryController = TextEditingController();
  String searchPlaceholder = 'Search by tags';
  var searchPageState;

  Widget _buildSearchField() {
    return TextField(
        controller: _searchQueryController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: "Search by #tags...",
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.white30),
        ),
        style: TextStyle(color: Colors.white, fontSize: 16.0),
        onChanged: (query) async {
          var tags = query
              .trim()
              .split(" ")
              .where((element) => element != '')
              .toList();
          print(tags.length);
          if (tags.isEmpty) {
            await Future.delayed(Duration(milliseconds: 500));
            setState(() {
              print('call');
              searchPageState = searchPageStates.empty;
            });
          } else {
            var notes =
                await readNotes('descending', 20, 0, widget.token, tags: tags);
            if (notes.length == 0) {
              setState(() {
                searchPageState = searchPageStates.notFound;
              });
            } else {
              setState(() {
                searchPageState = searchPageStates.results;
              });
            }
          }
        });
  }

  Widget _buildSearchPage() {
    print('Rebuild $searchPageState');
    switch (searchPageState) {
      case searchPageStates.empty:
        return Center(
          child: Icon(
            Icons.search,
            size: 40,
            color: Colors.grey,
          ),
        );
      case searchPageStates.notFound:
        return Center(
          child: Icon(
            Icons.error,
            size: 40,
            color: Colors.grey,
          ),
        );
      case searchPageStates.results:
        return Center(
          child: Text('Results'),
        );
      case searchPageStates.error:
        return Center(
          child: Text('Error'),
        );
      default:
        return Center(
          child: Text('Error'),
        );
    }
  }

  @override
  void initState() {
    super.initState();
    searchPageState = searchPageStates.empty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _buildSearchField(),
          backgroundColor: theming.headerColor,
        ),
        body: Container(
            decoration: BoxDecoration(color: Color(0xFF0E1621)),
            child: _buildSearchPage()));
  }
}
