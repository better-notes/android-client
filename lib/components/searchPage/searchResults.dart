import 'package:flutter/material.dart';
// import 'package:flutter_application_1/theming.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SearchResults extends StatefulWidget {
  SearchResults({required this.notes});
  final List<Map<String, dynamic>> notes;
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.notes.length,
      separatorBuilder: (context, index) {
        return Divider(
            // color: Colors.grey,
            );
      },
      itemBuilder: (context, index) {
        var item = widget.notes[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return NoteDetailScreen(note: item);
            }));
          },
          child: Hero(
              tag: item['id_'],
              child: Slidable(
                key: Key(item['id_'].toString()),
                dismissal: SlidableDismissal(
                    child: SlidableDrawerDismissal(
                      key: Key(item['id_'].toString()),
                    ),
                    onDismissed: (actionType) {
//
                    }),
                actions: <Widget>[
                  IconSlideAction(
                    caption: 'Archive',
                    // color: Colors.blue,
                    icon: Icons.archive,
                  ),
                ],
                actionPane: SlidableDrawerActionPane(),
                child: ListTile(
                  title: Text(
                    item['text'],
                    // style: TextStyle(color: Colors.white),
                  ),
                ),
              )),
        );
      },
    );
  }
}

class NoteDetailScreen extends StatelessWidget {
  NoteDetailScreen({required this.note});
  final Map<String, dynamic> note;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Note'),
          // backgroundColor: headerColor,
          // foregroundColor: Colors.white,
        ),
        body: Container(
          child: Padding(
            child: Text(
              note['text'],
              // style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            padding: EdgeInsets.all(10),
          ),
        ));
  }
}
