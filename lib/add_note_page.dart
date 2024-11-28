import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_notes_apps/Model/note.dart';
import 'package:flutter_crud_notes_apps/theme_provider.dart';
import 'package:provider/provider.dart';

class AddNotePage extends StatefulWidget {
  final Note note;

  const AddNotePage({super.key, required this.note});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final CollectionReference myNotes =
      FirebaseFirestore.instance.collection('notes');
  late TextEditingController titleController;
  late TextEditingController noteController;
  late Note note;
  String titleString = '';
  String noteString = '';
  late int color;

  @override
  void initState() {
    super.initState();
    note = widget.note;
    titleString = note.title;
    noteString = note.note;
    color = note.color == 0xFFFFFFFF ? generateRandomLightColor() : note.color;
    titleController = TextEditingController(text: titleString);
    noteController = TextEditingController(text: noteString);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<ThemeProvider>(context).themeMode == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                    child: BackButton(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    note.id.isEmpty ? 'Add note' : 'Edit note',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white // Or a lighter color
                            : Colors.black
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            saveNotes();
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.save,
                            color: Colors.white,
                          ),
                        ),
                        if (note.id.isNotEmpty)
                          IconButton(
                            onPressed: () {
                              myNotes.doc(note.id).delete();
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 10,),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Note Title",
                  hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onChanged: (value) {
                  titleString = value;
                },
              ),
              SizedBox(height: 5,),
              Expanded(
                child: TextField(
                  controller: noteController,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Note Description",
                  ),
                  onChanged: (value) {
                    noteString = value;
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void saveNotes() async {
    DateTime now = DateTime.now();
    try {
      if (note.id.isEmpty) {
        await myNotes.add({
          'title': titleString,
          'note': noteString,
          'color': color,
          'createAt': now,
        });
      } else {
        await myNotes.doc(note.id).update({
          'title': titleString,
          'note': noteString,
          'color': color,
          'updateAt': now,
        });
      }
    } catch (e) {
      print('Error saving note: $e');
    }
  }
}
