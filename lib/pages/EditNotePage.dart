import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/data/editNote.dart';
import 'package:flutter_application_1/note/parseNote.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            HapticFeedback.vibrate();
            if (editNoteFormKey.currentState!.validate()) {
              var noteText = parseNote(editNoteConroller.text);
              var tags = getNoteTags(noteText);
              var newTag = widget.note;
              newTag['text'] = noteText;
              newTag['tags'] = tags;
              editNote(newTag, widget.stateToken).then((value) {
                widget.updateNote(value, widget.index);
                Navigator.pop(context);
                Navigator.pop(context);
              }).catchError((error) {
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
                );
              });
            }
          },
          child: const Icon(Icons.save),
        ),
        body: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Card(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Form(
                        key: editNoteFormKey,
                        child: TextFormField(
                          controller: editNoteConroller,
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
