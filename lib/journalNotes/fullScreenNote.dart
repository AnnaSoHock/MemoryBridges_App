import 'package:flutter/material.dart';

class FullScreenNote extends StatelessWidget {
  final String title;
  final String content;
  final Color color;

  const FullScreenNote({
    required this.title,
    required this.content,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Notes',
          style: TextStyle(color: Colors.black, fontFamily: 'LibreBaskerville'),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
            SizedBox(height: 10),
            Text(
              content,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
