import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitmar/pages/Forget_password.dart';
import 'package:fitmar/pages/Gender_choosing_page.dart';
import 'package:fitmar/pages/MainPage.dart';
import 'package:fitmar/pages/Register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GirisSayfasi extends StatelessWidget {
  GirisSayfasi({Key? key}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        if (user.emailVerified) {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('user-properties')
              .doc(user.uid)
              .get();
          if (userDoc.exists && userDoc['gender'] == null) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => CinsiyetSecme()));
          } else {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Anasayfa()));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  "Verify your account. Verification email has been sent."),
            ),
          );
        }
      }
    } catch (e) {
      print("Error logging in: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred while logging in: $e"),
        ),
      );
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null) {
        if (user.emailVerified) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'email': user.email,
            'full_name': user.displayName,
            'phone_number': '',
            'userID': user.uid,
          });

          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('user-properties')
              .doc(user.uid)
              .get();
          if (!userDoc.exists) {
            await FirebaseFirestore.instance
                .collection('user-properties')
                .doc(user.uid)
                .set({
              'gender': null,
              'age': null,
              'height': null,
              'weight': null,
              'name': user.displayName,
            });
          }

          if (userDoc.exists && userDoc['gender'] == null) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => CinsiyetSecme()));
          } else {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Anasayfa()));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  "Verify your account. Verification email has been sent."),
            ),
          );
        }
      }
    }
  } catch (e) {
    print("Error logging in with Google: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("An error occurred while logging in with Google: $e"),
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    String email = "";
    String password = "";

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 80),
            const Text(
              "Welcome to",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
            ),
            const Text(
              "FitMar",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            const Text(
              "Hello there, let’s log in !",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    onChanged: (value) => email = value,
                    decoration: InputDecoration(
                        fillColor: Color.fromARGB(255, 255, 255, 255),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 2, color: Color.fromRGBO(0, 0, 0, 1)),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        hintText: 'Email Address'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    onChanged: (value) => password = value,
                    obscureText: true,
                    decoration: InputDecoration(
                        fillColor: Color.fromARGB(255, 255, 255, 255),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 2, color: Color.fromRGBO(0, 0, 0, 1)),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        hintText: 'Password'),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SifremiUnuttum()),
                        );
                      },
                      child: const Text(
                        "Forgot Password",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(255, 10, 61, 113),
                          onPrimary: Colors.white,
                          minimumSize: Size(193, 44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          )),
                      onPressed: () {
                        _signInWithEmailAndPassword(context, email, password);
                      },
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  const SizedBox(height: 15),
                  const Center(
                    child: Text(
                      "Or",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                  ),
                  SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      _signInWithGoogle(context);
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 4,
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            )
                          ]),
                      child: Image.asset(
                        'assets/google2-removebg-preview.png',
                        scale: 9,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't you have an account?",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => KayitEkrani()),
                          );
                        },
                        child: const Text(
                          "Register!",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

