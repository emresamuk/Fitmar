import 'package:fitmar/pages/Height_choosing_page.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KiloSecmeSayfasi extends StatefulWidget {
  const KiloSecmeSayfasi({Key? key}) : super(key: key);

  @override
  State<KiloSecmeSayfasi> createState() => _KiloSecmeSayfasiState();
}

class _KiloSecmeSayfasiState extends State<KiloSecmeSayfasi> {
  int _selectedWeight = 60; // Default weight value

  Future<void> _saveWeightAndProceed(BuildContext context) async {
    try {
      // Get current user ID from Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userID = user.uid;

        // Update user weight in Firestore database
        await FirebaseFirestore.instance
            .collection('user-properties')
            .doc(userID)
            .update({
          'weight': _selectedWeight,
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BoySecmeSayfasi()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in.')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving weight. Please try again later.')),
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
                "Step 3 of 5",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "HOW MUCH DO YOU WEIGH? ",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
            ),
            SizedBox(height: 120),
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
                  value: _selectedWeight,
                  minValue: 30,
                  maxValue: 200,
                  axis: Axis.horizontal,
                  onChanged: (value) {
                    setState(() {
                      _selectedWeight = value;
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
                    await _saveWeightAndProceed(context);
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
