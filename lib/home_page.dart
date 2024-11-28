import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_notes_apps/Model/note.dart';
import 'package:flutter_crud_notes_apps/add_note_page.dart';
import 'package:flutter_crud_notes_apps/display_note.dart';
import 'package:flutter_crud_notes_apps/theme_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference myNotes =
      FirebaseFirestore.instance.collection('notes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Note App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
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
      body: ListView(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: myNotes.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final notes = snapshot.data!.docs;
              List<DisplayNote> noteCards = [];
              for (var note in notes) {
                var data = note.data() as Map<String, dynamic>?;
                if (data != null) {
                  Note noteObject = Note(
                    id: note.id,
                    title: data['title'] ?? "",
                    note: data['note'] ?? "",
                    createAt: data.containsKey('createAt')
                        ? (data['createAt'] as Timestamp).toDate()
                        : DateTime.now(),
                    updateAt: data.containsKey('updateAt')
                        ? (data['updateAt'] as Timestamp).toDate()
                        : DateTime.now(),
                    color:
                        data.containsKey('color') ? data['color'] : 0xFFFFFFFF,
                  );
                  noteCards.add(
                    DisplayNote(
                      note: noteObject,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddNotePage(note: noteObject),
                          ),
                        );
                      },
                    ),
                  );
                }
              }
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), // Prevents GridView scrolling separately
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: noteCards.length,
                itemBuilder: (context, index) {
                  return noteCards[index];
                },
                padding: const EdgeInsets.all(3),
              );
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNotePage(
                note: Note(
                  id: '',
                  title: '',
                  note: '',
                  createAt: DateTime.now(),
                  updateAt: DateTime.now(),
                ),
              ),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
