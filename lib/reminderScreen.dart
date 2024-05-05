import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  TextEditingController _reminderController = TextEditingController();
  bool _isMedication = false;
  TimeOfDay _selectedTime = TimeOfDay.now();
  List<String> _reminders = [];

  @override
  void initState() {
    super.initState();
    _fetchReminders();
  }

  Future<void> _fetchReminders() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('reminders')
            .get();

        setState(() {
          _reminders = querySnapshot.docs.map((doc) => doc['reminderText'] as String).toList();
        });
      } catch (e) {
        print('Error fetching reminders: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Reminders', style: TextStyle(color: Colors.black, fontFamily: 'LibreBaskerville')),
        backgroundColor: Colors.amber[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Add Reminders Here',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _reminderController,
              decoration: InputDecoration(
                labelText: 'Reminder',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: <Widget>[
                const Text(
                  'Is this a medication reminder?',
                  style: TextStyle(color: Colors.black),
                ),
                Switch(
                  value: _isMedication,
                  onChanged: (value) {
                    setState(() {
                      _isMedication = value;
                    });
                  },
                  activeColor: Colors.amber[100],
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              children: <Widget>[
                const Text(
                  'Set time: ',
                  style: TextStyle(color: Colors.black),
                ),
                TextButton(
                  onPressed: () {
                    _selectTime(context);
                  },
                  child: Icon(
                    Icons.access_time,
                    color: Colors.blueGrey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _saveReminder();
              },
              child: const Text('Save Reminder'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Divider(
              color: Colors.grey[400],
              thickness: 2.0,
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Reminders',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: _reminders.isEmpty
                  ? const Center(
                child: Text(
                  'No Reminders',
                  style: TextStyle(fontSize: 18),
                ),
              )
                  : ListView.builder(
                itemCount: _reminders.length,
                itemBuilder: (context, index) {
                  return ReminderItem(
                    reminderText: _reminders[index],
                    onDelete: () => _deleteReminder(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveReminder() {
    String reminder = _reminderController.text;
    String type = _isMedication ? 'Medication' : 'Appointment';
    String time = _formatTime(_selectedTime);
    String reminderText = '$type Reminder: $reminder, Time: $time';
    setState(() {
      _reminders.add(reminderText);
    });
    _reminderController.clear();

    _saveReminderToFirestore(reminderText);
  }

  String _formatTime(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final DateTime dateTime = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return DateFormat.jm().format(dateTime);
  }

  void _saveReminderToFirestore(String reminderText) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('reminders')
            .add({'reminderText': reminderText});
      } catch (e) {
        print('Error saving reminder: $e');
      }
    }
  }

  void _deleteReminder(int index) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('reminders')
            .where('reminderText', isEqualTo: _reminders[index])
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });

        setState(() {
          _reminders.removeAt(index);
        });
      } catch (e) {
        print('Error deleting reminder: $e');
      }
    }
  }
}

class ReminderItem extends StatelessWidget {
  final String reminderText;
  final VoidCallback onDelete;

  ReminderItem({required this.reminderText, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final List<String> splitReminder = reminderText.split(", Time: ");
    final String dateTime = splitReminder[1];
    final String reminderInfo = splitReminder[0];

    final RegExp typeRegExp = RegExp(r'(Medication|Appointment) Reminder:');
    final Match? typeMatch = typeRegExp.firstMatch(reminderInfo);
    final String? reminderType = typeMatch != null ? typeMatch.group(0) : null;

    TextStyle typeTextStyle = const TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.black);
    TextStyle infoTextStyle = const TextStyle(fontStyle: FontStyle.normal, fontWeight: FontWeight.normal,color: Colors.black);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 3,
        margin: EdgeInsets.zero,
        color: Colors.amber[50],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateTime,
                    style: const TextStyle(fontSize: 16.0, color: Colors.orange, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: onDelete,
                    color: Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              RichText(
                text: TextSpan(
                  text: reminderType,
                  style: typeTextStyle,
                  children: <TextSpan>[
                    TextSpan(
                      text: reminderInfo.substring(reminderType!.length),
                      style: infoTextStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ReminderScreen(),
  ));
}
