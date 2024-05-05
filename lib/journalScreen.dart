import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_memory_bridge/journalNotes/itemNote.dart'; // Import your ItemNote widget
import 'package:app_memory_bridge/journalNotes/createNewNote.dart';
import 'package:app_memory_bridge/journalNotes/fullScreenNote.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // If no user is logged in, return a placeholder widget or redirect to the login screen
      return const Scaffold(
        body: Center(
          child: Text('Please sign in to view your diary.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Diary', style: TextStyle(color: Colors.black, fontFamily: 'LibreBaskerville')),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('notes')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              int? colorValue = data['color'] as int?;
              Color color = Color(colorValue ?? Colors.grey.value);
              Timestamp timestamp = data['date'] as Timestamp;
              DateTime date = timestamp.toDate();
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FullScreenNote(
                        title: data['title'] ?? '',
                        content: data['content'] ?? '',
                        color: color,
                      ),
                    ),
                  );
                },
                child: ItemNote(
                  title: data['title'] ?? '',
                  content: data['content'] ?? '',
                  date: date,
                  onDelete: () {
                    // Delete the note
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(currentUser.uid)
                        .collection('notes')
                        .doc(document.id)
                        .delete();
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NoteScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
