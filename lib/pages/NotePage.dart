import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/pages/EditNotePage.dart';

class NotePage extends StatefulWidget {
  NotePage({
    required this.note,
    required this.index,
    required this.notes,
    required this.updateNote,
    required this.stateToken,
  });
  final Map<String, dynamic> note;
  final int index;
  final List<Map<String, dynamic>> notes;
  final Function(Map<String, dynamic>, int) updateNote;
  final String stateToken;

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  Widget getTags() {
    return Padding(
        padding: EdgeInsets.only(top: 5),
        child: Wrap(
            alignment: WrapAlignment.start,
            children: widget.note['tags']
                .map<Widget>((tag) => new Card(
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 1, bottom: 1, left: 10, right: 10),
                        child: Text(
                          tag['name'],
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ))
                .toList()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Note'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            HapticFeedback.vibrate();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new EditNotePage(
                        stateToken: widget.stateToken,
                        updateNote: widget.updateNote,
                        index: widget.index,
                        note: widget.note,
                      )),
            );
          },
          child: const Icon(Icons.edit),
        ),
        body: Container(
          child: Container(
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.note["text"],
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: getTags(),
                    )
                  ],
                )),
          ),
        ));
  }
}
