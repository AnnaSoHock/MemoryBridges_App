import 'package:flutter/material.dart';
import 'package:app_memory_bridge/journalScreen.dart';
import 'package:app_memory_bridge/reminderScreen.dart';
import 'package:app_memory_bridge/dailyQuotesScreen.dart';
import 'package:app_memory_bridge/resourcesScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_memory_bridge/loginScreen.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeState();
}

// Associated names to each SilverBox
class _MainHomeState extends State<MainHomeScreen> {
  final List<String> boxNames = [
    'Daily Affirming Quotes',
    'Journal Entries',
    'Reminders',
    'Resources'
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Memory Bridges',
            style: TextStyle(
              fontFamily: 'LibreBaskerville',
            ),
          ),
          backgroundColor: Colors.amber[100],
          automaticallyImplyLeading: false, // Remove back button
        ),
        body: Column(
          children: [
            const TabBar(
              indicatorColor: Colors.amber,
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  FirstTab(
                    customScrollView: CustomScrollView(
                      slivers: [
                        // SilverToBoxAdapters are associated to numbers, for better functionality of code
                        buildSliverToBoxAdapter(0), // For "Daily Affirming Quotes"
                        buildSliverToBoxAdapter(1), // For "Journal Entries"
                        buildSliverToBoxAdapter(2), // For "Reminders (e.g Appointments, meds)"
                        buildSliverToBoxAdapter(3), // For "Resources"
                      ],
                    ),
                  ),
                  SecondTab(),
                  ThirdTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter buildSliverToBoxAdapter(int index) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: GestureDetector(
            // For user to click on any boxes and it leading to the associated dart page
            onTap: () {
              switch (index) {
                case 0: // For "Daily Affirming Quotes"
                  Navigator.push(context, MaterialPageRoute(builder: (_) => DailyQuotesScreen()));
                  break;
                case 1: // For "Journal Entries"
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const JournalScreen()));
                  break;
                case 2: // For "Reminders (e.g Appointments, meds)"
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ReminderScreen()));
                  break;
                case 3: // For "Resources"
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ResourceScreen()));
                  break;
              }
            },
            child: Container(
              height: 150, // Reduced height to make it more compact
              decoration: BoxDecoration(
                color: Colors.amber[100], // Box background color
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Box shadow color
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // Changes position of shadow
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  boxNames[index], // Display of text on boxes
                  style: const TextStyle(
                    fontFamily: 'LibreBaskerville',
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// For user to scroll on page if it exceeds screen
class FirstTab extends StatelessWidget {
  final Widget customScrollView;

  const FirstTab({required this.customScrollView});

  @override
  Widget build(BuildContext context) {
    return customScrollView;
  }
}

class SecondTab extends StatefulWidget {
  @override
  _SecondTabState createState() => _SecondTabState();
}

// Recognizes text input for medical Information on second Tab
class _SecondTabState extends State<SecondTab> {
  late TextEditingController nameController;
  late TextEditingController birthdayController;
  late TextEditingController caretakerController;
  late TextEditingController emergencyNameController;
  late TextEditingController emergencyNumberController;
  late TextEditingController weightController;
  late TextEditingController bloodTypeController;
  late TextEditingController allergiesController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    birthdayController = TextEditingController();
    caretakerController = TextEditingController();
    emergencyNameController = TextEditingController();
    emergencyNumberController = TextEditingController();
    weightController = TextEditingController();
    bloodTypeController = TextEditingController();
    allergiesController = TextEditingController();

    fetchAndDisplayMedicalInformation();
  }

  @override
  void dispose() {
    nameController.dispose();
    birthdayController.dispose();
    caretakerController.dispose();
    emergencyNameController.dispose();
    emergencyNumberController.dispose();
    weightController.dispose();
    bloodTypeController.dispose();
    allergiesController.dispose();
    super.dispose();
  }

  // Save information to Firebase
  void fetchAndDisplayMedicalInformation() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final uid = user.uid;
        final docSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        final medicalInfo = docSnapshot.data()?['medicalInformation'];

        nameController.text = medicalInfo?['name'] ?? '';
        birthdayController.text = medicalInfo?['birthday'] ?? '';
        caretakerController.text = medicalInfo?['caretaker'] ?? '';
        emergencyNameController.text = medicalInfo?['emergencyContactName'] ?? '';
        emergencyNumberController.text = medicalInfo?['emergencyContactNumber'] ?? '';
        weightController.text = medicalInfo?['weight'] ?? '';
        bloodTypeController.text = medicalInfo?['bloodType'] ?? '';
        allergiesController.text = medicalInfo?['allergies'] ?? '';
      }
    } catch (e) {
      // Display log for debugging purposes
      print('Error fetching medical information: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildPersonalInformationForm();
  }

  Widget buildPersonalInformationForm() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'Medical Information',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Name',
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.amber[50],
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: birthdayController,
          decoration: InputDecoration(
            labelText: 'Birthday',
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.amber[50],
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: caretakerController,
          decoration: InputDecoration(
            labelText: 'Caretaker',
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.amber[50],
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: emergencyNameController,
          decoration: InputDecoration(
            labelText: 'Emergency Contact Name',
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.amber[50],
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: emergencyNumberController,
          decoration: InputDecoration(
            labelText: 'Emergency Contact Number',
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.amber[50],
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: weightController,
          decoration: InputDecoration(
            labelText: 'Weight',
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.amber[50],
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: bloodTypeController,
          decoration: InputDecoration(
            labelText: 'Blood Type',
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.amber[50],
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: allergiesController,
          decoration: InputDecoration(
            labelText: 'Allergies',
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.amber[50],
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            saveMedicalInformation(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  void saveMedicalInformation(BuildContext context) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final uid = user.uid;
        final userData = {
          'name': nameController.text,
          'birthday': birthdayController.text,
          'caretaker': caretakerController.text,
          'emergencyContactName': emergencyNameController.text,
          'emergencyContactNumber': emergencyNumberController.text,
          'weight': weightController.text,
          'bloodType': bloodTypeController.text,
          'allergies': allergiesController.text,
        };

        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'medicalInformation': userData,
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Medical information saved successfully!'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No user signed in!'),
        ));
      }
    } catch (e) {
      print('Error saving medical information: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('An error occurred while saving medical information!'),
      ));
    }
  }
}


class ThirdTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/memoir.jpeg'), // Replace 'images/memoir.jpeg' with your image path
              fit: BoxFit.cover,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 300.0), // Add padding to the top
              child: Center(
                child: Text(
                  '"The mind may not remember, but the heart will never forget."',
                  textAlign: TextAlign.center, // Center text
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 20, // Adjust the bottom position as needed
          left: 20, // Adjust the left position as needed
          right: 20, // Adjust the right position as needed
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                },
                child: const Text('Log Out'),
              ),
              SizedBox(height: 20), // Add some space between the buttons
              ElevatedButton(
                onPressed: () async {
                  // Check if user is signed in
                  if (FirebaseAuth.instance.currentUser != null) {
                    // Delete user account and associated data
                    try {
                      await FirebaseAuth.instance.currentUser!.delete();
                      // After successful deletion, navigate to the login screen
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                    } catch (e) {
                      // Handle any errors here
                      print("Failed to delete account: $e");
                      // You can also show an error dialog or message to the user here
                    }
                  }
                },
                child: const Text('Delete Account'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

