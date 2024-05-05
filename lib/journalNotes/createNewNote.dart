import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key}) : super(key: key);

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New note', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
                hintText: 'Title',
                labelText: 'Title',
                prefixIcon: const Icon(Icons.title),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                )
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _contentController,
            maxLines: 20,
            keyboardType: TextInputType.multiline,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
                hintText: 'Start typing here...',
                labelText: 'Start typing here',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                )
            ),
          )
        ],
      ),
      bottomSheet: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: ElevatedButton(
          onPressed: _saveNote,
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              )
          ),
          child: const Text('Save'),
        ),
      ),
    );
  }

  void _saveNote() {
    String title = _titleController.text;
    String content = _contentController.text;
    Color color = Colors.blue; // You can set the color based on user selection or default value

    // Call the createNotes function to save the note to Firestore
    _createNotes(title, content, color);

    // Clear the text fields after saving the note
    _titleController.clear();
    _contentController.clear();

    // Navigate back to the previous screen (optional)
    Navigator.pop(context);
  }

  void _createNotes(String title, String content, Color color) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String datetime = DateTime.now().toString();
      await FirebaseFirestore.instance
          .collection('users') // Collection for user data
          .doc(currentUser.uid) // Document named after user's UID
          .collection('notes') // Subcollection for user's notes
          .add({
        'title': title,
        'content': content,
        'color': color.value, // Store color as int value
        'date': Timestamp.now(), // Store current date/time
      }).then((value) {
        print('Note saved successfully');
      }).catchError((onError) =>
          print('Failed to add new note due to $onError'));
    } else {
      print('User is not logged in');
      // Handle case where user is not logged in
    }
  }
}
