import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyQuotesScreen extends StatefulWidget {
  @override
  _DailyQuotesScreenState createState() => _DailyQuotesScreenState();
}

class _DailyQuotesScreenState extends State<DailyQuotesScreen> {
  String _currentImage = 'images/Quotes/quote1.jpeg';
  SharedPreferences? _prefs; // Initialize _prefs to null

  @override
  void initState() {
    super.initState();
    _loadImage();
    // Timer to change photo after every 24hrs in minutes
    Timer.periodic(const Duration(minutes: 1440), (timer) {
      _changeImage();
    });
  }

  Future<void> _loadImage() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentImage = _prefs!.getString('currentImage') ?? 'images/Quotes/quote1.jpeg';
    });
  }

  void _changeImage() {
    // Daily randomization of quote images
    List<String> photoAlbum = ['images/Quotes/quote1.jpeg',
      'images/Quotes/quote2.jpeg',
      'images/Quotes/quote3.jpeg',
      'images/Quotes/quote4.jpeg',
      'images/Quotes/quote5.jpeg',
      'images/Quotes/quote6.jpeg',
      'images/Quotes/quote7.jpeg',
      'images/Quotes/quote8.jpeg',
      'images/Quotes/quote9.jpeg',
      'images/Quotes/quote10.jpeg'];

    Random random = Random();
    String newImage = photoAlbum[random.nextInt(photoAlbum.length)];

    // Save the new image
    _prefs!.setString('currentImage', newImage);

    setState(() {
      _currentImage = newImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Quotes', style: TextStyle(color: Colors.black, fontFamily: 'LibreBaskerville')),
        backgroundColor: Colors.amber[100], // Set AppBar color
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.1), // Set opacity
          ),
          child: Image.asset(
            _currentImage,
            fit: BoxFit.contain, // Adjusts the image to fit within the container
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),
      ),
    );
  }
}