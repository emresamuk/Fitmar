import 'package:fitmar/pages/Edit_profile.dart';
import 'package:fitmar/pages/article_page.dart';
import 'package:flutter/material.dart';
import 'package:fitmar/pages/Settings.dart';
import 'package:fitmar/pages/Privacy_and_Policy.dart';
import 'package:fitmar/pages/Login.dart';
import 'package:fitmar/pages/Recipe_page.dart';
import 'package:fitmar/widgets/navbar.dart';
import 'package:fitmar/pages/MainPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String fullName;
  final String email;
  final int age;
  final double height;
  final double weight;

  UserProfile({
    required this.fullName,
    required this.email,
    required this.age,
    required this.height,
    required this.weight,
  });

  factory UserProfile.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      {DocumentSnapshot<Map<String, dynamic>>? userPropertiesDoc}) {
    final data = doc.data()!;
    final userProperties = userPropertiesDoc?.data() ?? {};

    return UserProfile(
      fullName: data['full_name'] ?? '',
      email: data['email'] ?? '',
      age: userProperties['age'] ?? 0,
      height: (userProperties['height'] ?? 0).toDouble(),
      weight: (userProperties['weight'] ?? 0).toDouble(),
    );
  }
}

class ProfilSayfasi extends StatefulWidget {
  const ProfilSayfasi({Key? key}) : super(key: key);

  @override
  State<ProfilSayfasi> createState() => _ProfilSayfasiState();
}

class _ProfilSayfasiState extends State<ProfilSayfasi> {
  int _selectedIndex = 3;
  UserProfile? user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
            .instance
            .collection('users')
            .doc(currentUser.uid)
            .get();
        DocumentSnapshot<Map<String, dynamic>> userPropertiesDoc =
            await FirebaseFirestore.instance
                .collection('user-properties')
                .doc(currentUser.uid)
                .get();

        print('User Data: ${userDoc.data()}');
        print('User Properties Data: ${userPropertiesDoc.data()}');

        setState(() {
          user = UserProfile.fromFirestore(userDoc,
              userPropertiesDoc: userPropertiesDoc);
        });
      } else {
        print('No user is logged in');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('PROFILE'),
        backgroundColor: const Color.fromARGB(255, 10, 61, 113),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 6.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user != null ? user!.fullName : 'Loading...',
                          style: Theme.of(context).textTheme.headline6?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user != null ? 'E-mail: ${user!.email}' : 'Loading...',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 6.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User Information',
                          style: Theme.of(context).textTheme.headline6?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user != null ? 'Age: ${user!.age}' : 'Loading...',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user != null
                              ? 'Height: ${user!.height} cm'
                              : 'Loading...',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user != null
                              ? 'Weight: ${user!.weight} kg'
                              : 'Loading...',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildProfileOption(
                icon: Icons.edit,
                text: 'Edit Profile',
                onTap: () =>
                    _navigateToPage(context, const EditProfilePage()),
              ),
              _buildProfileOption(
                icon: Icons.privacy_tip,
                text: 'Privacy&Policy',
                onTap: () => _navigateToPage(context, PrivacyPolicyPage()),
              ),
              _buildProfileOption(
                icon: Icons.settings,
                text: 'Settings',
                onTap: () => _navigateToPage(context, Ayarlar()),
              ),
              _buildProfileOption(
                icon: Icons.exit_to_app,
                text: 'Logout',
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => GirisSayfasi()),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navbar(
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          if (_selectedIndex != index) {
            setState(() {
              _selectedIndex = index;
              switch (index) {
                case 0:
                  _navigateToPage(context, const Anasayfa());
                  break;
                case 1:
                  _navigateToPage(context,  YemekSayfasi());
                  break;
                case 2:
                  _navigateToPage(context, KesfetSayfasi());
                  break;
                case 3:
                  _navigateToPage(context, const ProfilSayfasi());
                  break;
              }
            });
          }
        },
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => page,
        transitionsBuilder: (context, animation1, animation2, child) {
          return FadeTransition(
            opacity: animation1,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
