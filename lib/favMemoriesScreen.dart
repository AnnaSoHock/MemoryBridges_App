import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FavMemoriesScreen extends StatefulWidget {
  @override
  _FavMemoriesScreenState createState() => _FavMemoriesScreenState();
}

class _FavMemoriesScreenState extends State<FavMemoriesScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  Future<void> _getImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = image;
    });
  }

  Future<String?> _uploadImageToFirebaseStorage(File imageFile) async {
    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      final Reference storageRef = storage.ref().child('users/${FirebaseAuth.instance.currentUser!.uid}/photos/${DateTime.now()}.jpg');
      final UploadTask uploadTask = storageRef.putFile(imageFile);

      // Wait for the upload task to complete and retrieve the download URL
      TaskSnapshot taskSnapshot = await uploadTask;
      String? imageUrl = await taskSnapshot.ref.getDownloadURL();

      // Return the download URL
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null; // Return null if an error occurs
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Memories'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_imageFile != null) ...[
              Image.file(File(_imageFile!.path)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String? imageUrl = await _uploadImageToFirebaseStorage(File(_imageFile!.path));
                  if (imageUrl != null) {
                    // Handle imageUrl (e.g., store in database, display in UI)
                    print('Download URL: $imageUrl');
                  } else {
                    // Handle error if imageUrl is null
                    print('Failed to upload image.');
                  }
                },
                child: const Text('Upload Image'),
              ),
            ] else ...[
              const Text('No image selected'),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _getImageFromGallery();
              },
              child: const Text('Select Image'),
            ),
          ],
        ),
      ),
    );
  }
}
