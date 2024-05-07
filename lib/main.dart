import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'loginScreen.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/HomeAppBackground.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 100.0),
                child: Column(
                  children: [
                    Text(
                      "MemoryBridges",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'LibreBaskerville',
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '"To be forever remembered"',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'LibreBaskerville',
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Builder(
                    builder: (context) => ElevatedButton(
                      onPressed: () {
                        // Navigate to login screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text('Getting Started', style: TextStyle(color: Colors.black, fontFamily: 'LibreBaskerville',)),
                    ),
                  ),

                  const SizedBox(height: 195),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
