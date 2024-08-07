import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitmar/pages/Age_choosing_page.dart';

class CinsiyetSecme extends StatefulWidget {
  const CinsiyetSecme({Key? key}) : super(key: key);

  @override
  _CinsiyetSecmeState createState() => _CinsiyetSecmeState();
}

class _CinsiyetSecmeState extends State<CinsiyetSecme> {
  String? _selectedGender;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _updateGender() async {
    try {
      User? user = _auth.currentUser;
      if (user != null && _selectedGender != null) {
        await FirebaseFirestore.instance
            .collection('user-properties')
            .doc(user.uid)
            .update({
          'gender': _selectedGender,
        });
      }
    } catch (e) {
      print('Error updating gender: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Step 1 of 5",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "WHAT IS YOUR GENDER? ",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(height: 100),
                GenderButton(
                  icon: Icons.male,
                  label: "Male",
                  isSelected: _selectedGender == "Male",
                  onPressed: () {
                    setState(() {
                      _selectedGender = "Male";
                    });
                  },
                ),
                const SizedBox(height: 20),
                GenderButton(
                  icon: Icons.female,
                  label: "Female",
                  isSelected: _selectedGender == "Female",
                  onPressed: () {
                    setState(() {
                      _selectedGender = "Female";
                    });
                  },
                ),
                const SizedBox(height: 250),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20, right: 20),
                    child: FloatingActionButton(
                      onPressed: () async {
                        await _updateGender();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const YasSecmeSayfasi(),
                          ),
                        );
                      },
                      backgroundColor: const Color.fromARGB(255, 10, 61, 113),
                      child: const Icon(Icons.arrow_forward, size: 30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GenderButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const GenderButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 45),
      child: SizedBox(
        width: 300,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(label),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              isSelected ? Colors.blueGrey : Colors.grey.shade300,
            ),
            elevation: MaterialStateProperty.all<double>(0),
          ),
        ),
      ),
    );
  }
}
