import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitmar/pages/StartWorkoutPage.dart';

class BoySecmeSayfasi extends StatefulWidget {
  const BoySecmeSayfasi({Key? key}) : super(key: key);

  @override
  State<BoySecmeSayfasi> createState() => _BoySecmeSayfasiState();
}

class _BoySecmeSayfasiState extends State<BoySecmeSayfasi> {
  int _selectedHeight = 170; // Default height value

  Future<void> _saveHeightAndProceed(BuildContext context) async {
    try {
      // Get current user ID from Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userID = user.uid;

        // Update user height in Firestore database
        await FirebaseFirestore.instance
            .collection('user-properties')
            .doc(userID)
            .update({
          'height': _selectedHeight,
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StartWorkoutPage()),
        );
      } else {
        // Show error message if user is not logged in
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in.')),
        );
      }
    } catch (e) {
      print(e);
      // Show a message to the user in case of error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving height. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "Step 4 of 5",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "HOW TALL ARE YOU? ",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(height: 155),
            Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey, 
                    width: 2,
                  ),
                ),
                padding: const EdgeInsets.all(8),
                child: NumberPicker(
                  value: _selectedHeight,
                  minValue: 100,
                  maxValue: 250,
                  axis: Axis.horizontal,
                  onChanged: (value) {
                    setState(() {
                      _selectedHeight = value;
                    });
                  },
                  textStyle: const TextStyle(fontSize: 24), 
                ),
              ),
            ),
            const SizedBox(height: 250),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, right: 0),
                child: FloatingActionButton(
                  onPressed: () async {
                    await _saveHeightAndProceed(context);
                  },
                  backgroundColor: const Color.fromARGB(255, 10, 61, 113),
                  child: const Icon(Icons.arrow_forward, size: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
