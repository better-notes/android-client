import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/pages/NotePage.dart';

class Note extends StatefulWidget {
  Note({
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
  _NoteState createState() => _NoteState();
}

class _NoteState extends State<Note> {
  Widget getTags() {
    return Padding(
        padding: EdgeInsets.only(top: 5),
        child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            alignment: WrapAlignment.start,
            children: widget.note['tags']
                .map<Widget>((tag) => new Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 1, bottom: 1, left: 10, right: 10),
                        child: Text(
                          tag['name'],
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ))
                .toList()));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NotePage(
                    note: widget.note,
                    index: widget.index,
                    notes: widget.notes,
                    updateNote: widget.updateNote,
                    stateToken: widget.stateToken,
                  )),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.note["text"],
                    maxLines: 20,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: getTags(),
                )
              ],
            )),
      ),
    );
  }
}
