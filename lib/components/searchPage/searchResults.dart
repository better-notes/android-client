import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/homePage/note.dart';
import 'package:flutter_application_1/data/deleteNote.dart';

class SearchResults extends StatefulWidget {
  SearchResults({
    required this.notes,
    required this.stateToken,
    required this.getNewNotes,
    required this.updateNote,
    required this.refreshNotes,
  });
  final List<Map<String, dynamic>> notes;
  final String stateToken;
  final Function(int) getNewNotes;
  final Function(Map<String, dynamic>, int) updateNote;
  final Function refreshNotes;
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: EdgeInsets.only(top: 5, bottom: 20),
      itemCount: widget.notes.length,
      itemBuilder: (note, index) {
        if (index >= widget.notes.length - 1) {
          widget.getNewNotes(widget.notes.length);
        }
        final item = widget.notes[index];
        return Dismissible(
            key: Key(item['id_'].toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              deleteNote(item, widget.stateToken).then((value) {
                widget.refreshNotes();
                setState(() {
                  widget.notes.removeAt(index);
                });
              }).catchError((error) {
                setState(() {
                  widget.notes.removeAt(index);
                });
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("$error")));
              });
            },
            background: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.delete,
                    ),
                  )
                ],
              ),
            ),
            child: Container(
              width: double.infinity,
              child: Note(
                note: item,
                index: index,
                notes: widget.notes,
                updateNote: widget.updateNote,
                stateToken: widget.stateToken,
              ),
            ));
      },
    );
  }
}
