import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/components/homePage/HomePageDrawer.dart';
import 'package:flutter_application_1/components/homePage/note.dart';
import 'package:flutter_application_1/data/deleteNote.dart';
import 'package:flutter_application_1/data/readNotes.dart';
import 'package:flutter_application_1/pages/SearchPage.dart';
import 'package:flutter_application_1/pages/createNote.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_1/theming.dart' as theming;

class HomePage extends StatefulWidget {
  HomePage({
    required this.notes,
    required this.stateToken,
    required this.removeValue,
    required this.setStateToEnter,
  });
  final List<Map<String, dynamic>> notes;
  final String stateToken;
  final Function(String) removeValue;
  final VoidCallback setStateToEnter;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final Widget appLogo = SvgPicture.asset(
    'assets/grid-dynamic.svg',
    height: 30,
  );

  List<Map<String, dynamic>> notes = [];

  void addNote(Map<String, dynamic> note) {
    setState(() {
      notes.insert(0, note);
    });
  }

  void updateNote(Map<String, dynamic> note, int index) {
    setState(() {
      notes[index] = note;
    });
  }

  void getNewNotes(int offset) {
    readNotes('descending', 20, offset, widget.stateToken)
        .then((value) => {
              value.forEach((note) {
                setState(() {
                  notes.add(note);
                });
              })
            })
        .catchError((error) => {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("$error")))
            });
  }

  void refreshNotes() {
    readNotes('descending', 20, 0, widget.stateToken)
        .then((value) => {
              setState(() {
                notes = value;
              })
            })
        .catchError((error) => {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("$error")))
            });
  }

  Widget renderNotes() {
    return RefreshIndicator(
        onRefresh: () async {
          refreshNotes();
        },
        child: ListView.builder(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: EdgeInsets.only(top: 5, bottom: 20),
          itemCount: notes.length,
          itemBuilder: (note, index) {
            if (index >= notes.length - 1) {
              getNewNotes(notes.length);
            }
            final item = notes[index];
            return Dismissible(
                key: Key(item['id_'].toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  deleteNote(item, widget.stateToken).then((value) {
                    setState(() {
                      notes.removeAt(index);
                    });
                  }).catchError((error) {
                    setState(() {
                      notes.removeAt(index);
                    });
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("$error")));
                  });
                },
                background: Container(
                  color: Color(0xFF0E1621),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.delete,
                          color: Colors.redAccent,
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
                    updateNote: updateNote,
                    stateToken: widget.stateToken,
                  ),
                ));
          },
        ));
  }

  @override
  void initState() {
    super.initState();
    notes = widget.notes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawerEdgeDragWidth: 0,
        drawer: HomePageDrawer(
          removeValue: widget.removeValue,
          setStateToEnter: widget.setStateToEnter,
        ),
        appBar: AppBar(
          title: Text('Better Notes'),
          backgroundColor: theming.headerColor,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new AddNotePage(
                        stateToken: widget.stateToken,
                        addNote: addNote,
                      )),
            );
          },
          child: const Icon(Icons.add),
          backgroundColor: theming.inputColor,
        ),
        body: Container(
          decoration: BoxDecoration(color: Color(0xFF0E1621)),
          child: Container(
            child: renderNotes(),
          ),
        ));
  }
}
