import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final DocumentSnapshot<Map<String, dynamic>> userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();
        final data = userDoc.data();
        if (data != null) {
          final String fullName = data['full_name'] ?? '';
          final DocumentSnapshot<Map<String, dynamic>> userPropsDoc =
              await FirebaseFirestore.instance
                  .collection('user-properties')
                  .doc(user.uid)
                  .get();
          final userData = userPropsDoc.data();
          if (userData != null) {
            final int age = userData['age'] ?? 0;
            final int height = userData['height'] ?? 0;
            final int weight = userData['weight'] ?? 0;
            _nameController.text = fullName;
            _ageController.text = age.toString();
            _heightController.text = height.toString();
            _weightController.text = weight.toString();
          }
        }
      } else {
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: const Text('EDIT PROFILE'),
        backgroundColor: const Color.fromARGB(255, 10, 61, 113),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
            ),
            TextFormField(
              controller: _heightController,
              decoration: const InputDecoration(labelText: 'Height'),
            ),
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: 'Weight'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _updateProfile();
              },
              child: const Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 10, 61, 113),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateProfile() async {
  final String fullName = _nameController.text.trim();
  final int age = int.tryParse(_ageController.text.trim()) ?? 0;
  final int height = int.tryParse(_heightController.text.trim()) ?? 0;
  final int weight = int.tryParse(_weightController.text.trim()) ?? 0;
  final User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'full_name': fullName, 
      });

      await FirebaseFirestore.instance
          .collection('user-properties')
          .doc(user.uid)
          .update({
        'name': fullName, 
        'age': age,
        'height': height,
        'weight': weight,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      // Close the EditProfilePage and navigate back to the previous page
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to update profile. Please try again later')),
      );
      print('Failed to update profile: $error');
    }
  }
}


  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}
