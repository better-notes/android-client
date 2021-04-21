import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/components/homePage/HomePageDrawer.dart';
import 'package:flutter_application_1/pages/createNote.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_1/theming.dart' as theming;

class HomePage extends StatefulWidget {
  HomePage({
    required this.notes,
    required this.stateToken,
  });
  final List<Map<String, dynamic>> notes;
  final String stateToken;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final Widget appLogo = SvgPicture.asset(
    'assets/grid-dynamic.svg',
    height: 30,
  );

  List<Map<String, dynamic>> notes = [];

  void deleteNote(Map<String, dynamic> note) {
    // remove note
  }

  void addNote(Map<String, dynamic> note) {
    setState(() {
      notes.insert(0, note);
    });
  }

  void updateNote(Map<String, dynamic> note) {
    // update note
  }

  Widget renderNotes() {
    return new ListView(
        children: notes.map((item) => new Text(item["text"]!)).toList());
  }

  @override
  void initState() {
    super.initState();
    notes = widget.notes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawerEdgeDragWidth: MediaQuery.of(context).size.width,
        drawer: HomePageDrawer(),
        appBar: AppBar(
          title: Text('Better Notes'),
          backgroundColor: theming.headerColor,
          foregroundColor: Colors.white,
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
          child: const Icon(Icons.edit),
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
