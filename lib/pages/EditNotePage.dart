import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/data/createNote.dart';
import 'package:flutter_application_1/data/editNote.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_1/theming.dart' as theming;
import 'package:hashtagable/hashtagable.dart';

class EditNotePage extends StatefulWidget {
  EditNotePage({
    required this.stateToken,
    required this.updateNote,
    required this.note,
    required this.index,
  });
  final String stateToken;
  final Function(Map<String, dynamic>, int) updateNote;
  final Map<String, dynamic> note;
  final int index;
  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final Widget appLogo = SvgPicture.asset(
    'assets/grid-dynamic.svg',
    height: 30,
  );

  final editNoteFormKey = GlobalKey<FormState>();
  late TextEditingController editNoteConroller;

  @override
  void initState() {
    super.initState();
    editNoteConroller = new TextEditingController(text: widget.note['text']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Note'),
          backgroundColor: theming.headerColor,
          foregroundColor: Colors.white,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (editNoteFormKey.currentState!.validate()) {
              var matches = editNoteConroller.text
                  .toString()
                  .split(' ')
                  .where((f) => f.startsWith('#'))
                  .toList();
              var tags = [];
              matches.forEach(
                  (match) => tags.add({'name': match.toString().substring(1)}));
              print(tags);
              var newTag = widget.note;
              newTag['text'] = editNoteConroller.text;
              newTag['tags'] = tags;
              editNote(newTag, widget.stateToken).then((value) {
                widget.updateNote(value, widget.index);
                Navigator.pop(context);
                Navigator.pop(context);
              }).catchError((error) => {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(error.toString()),
                        duration: Duration(milliseconds: 1500),
                        width: 280.0,
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    )
                  });
            }
          },
          child: const Icon(Icons.save),
          backgroundColor: theming.inputColor,
        ),
        body: Container(
          decoration: BoxDecoration(color: Color(0xFF0E1621)),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Card(
                    color: theming.inputColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Form(
                        key: editNoteFormKey,
                        child: TextFormField(
                          controller: editNoteConroller,
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.multiline,
                          maxLines: 13,
                          maxLength: 10000,
                          decoration: const InputDecoration(
                              hintText: 'Enter your note...',
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.blueGrey))),
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
