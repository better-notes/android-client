import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/components/homePage/HomePageDrawer.dart';
import 'package:flutter_application_1/components/homePage/note.dart';
import 'package:flutter_application_1/data/deleteNote.dart';
import 'package:flutter_application_1/data/readNotes.dart';
import 'package:flutter_application_1/pages/SearchPage.dart';
import 'package:flutter_application_1/pages/createNote.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  HomePage(
      {required this.notes,
      required this.stateToken,
      required this.removeValue,
      required this.setStateToEnter,
      required this.userInfo,
      required this.storage});
  final List<Map<String, dynamic>> notes;
  final String stateToken;
  final Function(String) removeValue;
  final VoidCallback setStateToEnter;
  final Map<String, dynamic> userInfo;
  final FlutterSecureStorage storage;

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
                  HapticFeedback.vibrate();

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
          userInfo: widget.userInfo,
          storage: widget.storage,
        ),
        appBar: AppBar(
          title: Text(
            'Better Notes',
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                HapticFeedback.vibrate();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchPage(
                            token: widget.stateToken,
                            refreshNotes: refreshNotes,
                          )),
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            HapticFeedback.vibrate();
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
        ),
        body: Container(
          child: Container(
            child: renderNotes(),
          ),
        ));
  }
}
