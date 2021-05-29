import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/components/searchPage/searchResults.dart';
import 'package:flutter_application_1/data/readNotes.dart';

enum searchPageStates {
  empty,
  results,
  notFound,
  error,
}

class SearchPage extends StatefulWidget {
  SearchPage({
    required this.token,
    required this.refreshNotes,
  });
  final String token;
  final Function refreshNotes;
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchQueryController = TextEditingController();
  String searchPlaceholder = 'Search by tags';
  var searchPageState;
  DateTime lastOnChangeDateTime = DateTime.now();
  late List<Map<String, dynamic>> searchResults;
  List<String> searchTags = [];

  void updateNote(Map<String, dynamic> note, int index) {
    setState(() {
      searchResults[index] = note;
    });
    widget.refreshNotes();
  }

  void getNewNotes(int offset) {
    readNotes('descending', 20, offset, widget.token, tags: searchTags)
        .then((value) => {
              value.forEach((note) {
                setState(() {
                  searchResults.add(note);
                });
              })
            })
        .catchError((error) => {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("$error")))
            });
  }

  Widget _buildSearchField() {
    return TextField(
        controller: _searchQueryController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: "Search by #tags...",
          border: InputBorder.none,
        ),
        style: TextStyle(fontSize: 16.0),
        onChanged: (query) {
          var onChangeCalledDateTime = DateTime.now();
          var tags = query
              .trim()
              .split(" ")
              .where((element) => element != '')
              .toList();
          if (tags.isEmpty) {
            setState(() {
              if (this.lastOnChangeDateTime.isBefore(onChangeCalledDateTime)) {
                searchPageState = searchPageStates.empty;
                this.lastOnChangeDateTime = onChangeCalledDateTime;
              }
            });
          } else {
            readNotes('descending', 20, 0, widget.token, tags: tags)
                .then((notes) {
              setState(() {
                if (this
                    .lastOnChangeDateTime
                    .isBefore(onChangeCalledDateTime)) {
                  if (notes.length == 0) {
                    searchPageState = searchPageStates.notFound;
                    this.lastOnChangeDateTime = onChangeCalledDateTime;
                  } else {
                    this.searchTags = tags;
                    this.searchResults = notes;
                    searchPageState = searchPageStates.results;
                    this.lastOnChangeDateTime = onChangeCalledDateTime;
                  }
                }
              });
            }).catchError((error) {
              setState(() {
                if (this
                    .lastOnChangeDateTime
                    .isBefore(onChangeCalledDateTime)) {
                  searchPageState = searchPageStates.error;
                  this.lastOnChangeDateTime = onChangeCalledDateTime;
                }
              });
            });
          }
        });
  }

  Widget _buildSearchPage() {
    switch (searchPageState) {
      case searchPageStates.empty:
        return Center(
          child: Icon(
            Icons.search,
            size: 40,
          ),
        );
      case searchPageStates.notFound:
        return Center(
          child: Icon(
            Icons.error,
            size: 40,
          ),
        );
      case searchPageStates.results:
        return SearchResults(
          notes: searchResults,
          stateToken: widget.token,
          getNewNotes: getNewNotes,
          updateNote: updateNote,
          refreshNotes: widget.refreshNotes,
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
        ),
        body: Container(child: _buildSearchPage()));
  }
}
