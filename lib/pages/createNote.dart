import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/data/createNote.dart';
import 'package:flutter_application_1/note/parseNote.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_application_1/theming.dart' as theming;
import 'package:hashtagable/hashtagable.dart';

class AddNotePage extends StatefulWidget {
  AddNotePage({
    required this.stateToken,
    required this.addNote,
  });
  final String stateToken;
  final void Function(Map<String, dynamic>) addNote;
  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final Widget appLogo = SvgPicture.asset(
    'assets/grid-dynamic.svg',
    height: 30,
  );

  final createNoteFormKey = GlobalKey<FormState>();
  final createNoteConroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Note'),
          // backgroundColor: theming.headerColor,
          foregroundColor: Colors.white,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (createNoteFormKey.currentState!.validate()) {
              var noteText = parseNote(createNoteConroller.text);
              var tags = getNoteTags(noteText);
              createNote({"text": noteText, "tags": tags}, widget.stateToken)
                  .then((value) {
                widget.addNote(value);
                Navigator.pop(context);
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error.toString()),
                    duration: Duration(milliseconds: 1500),
                    width: 280.0, // Width of the SnackBar.
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.0), // Inner padding for SnackBar content.
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                );
              });
            }
          },
          child: const Icon(Icons.save),
          // backgroundColor: theming.inputColor,
        ),
        body: Container(
          // decoration: BoxDecoration(color: Color(0xFF0E1621)),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Card(
                    // color: theming.inputColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Form(
                        key: createNoteFormKey,
                        child: TextFormField(
                          controller: createNoteConroller,
                          // style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.multiline,
                          maxLines: 13,
                          maxLength: 10000,
                          decoration: const InputDecoration(
                              hintText: 'Enter your note...',
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: const BorderSide())),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                    )),
              )
            ],
          ),
        ));
  }
}
