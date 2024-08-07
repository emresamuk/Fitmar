import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Login.dart';
import 'Verify_account.dart';

class KayitEkrani extends StatelessWidget {
  const KayitEkrani({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _fullNameController = TextEditingController();
    final TextEditingController _phoneNumberController =
        TextEditingController();

    Future<void> _register(BuildContext context) async {
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // user id returned from firebase authentication
        String userID = userCredential.user!.uid;

        // save user in database
        await FirebaseFirestore.instance.collection('users').doc(userID).set({
          'email': _emailController.text,
          'full_name': _fullNameController.text,
          'phone_number': _phoneNumberController.text,
          'userID': userID,
        });

        await FirebaseFirestore.instance
            .collection('user-properties')
            .doc(userID)
            .set({
          'gender': null, 
          'age': null, 
          'height': null,
          'weight': null, 
          'name': _fullNameController.text, 
        });


        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HesapDogrulama()),
        );
      } catch (e) {
        print(e);
        if (e is FirebaseAuthException) {
          if (e.code == 'email-already-in-use') {
            Fluttertoast.showToast(
              msg: "This email is already in use, please try another one.",
              toastLength: Toast.LENGTH_LONG,
            );
          } else if (e.code == 'weak-password') {
            Fluttertoast.showToast(
              msg: "Password should be at least 6 characters.",
              toastLength: Toast.LENGTH_LONG,
            );
          } else {
            Fluttertoast.showToast(
              msg:
                  "An error occurred during registration. Please try again later.",
              toastLength: Toast.LENGTH_LONG,
            );
          }
        } else {
          Fluttertoast.showToast(
            msg:
                "An error occurred during registration. Please try again later.",
            toastLength: Toast.LENGTH_LONG,
          );
        }
      }
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Create Account",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "To continue our application, please create an account",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(
                fillColor: Color.fromARGB(255, 255, 255, 255),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      width: 2, color: Color.fromRGBO(0, 0, 0, 1)),
                  borderRadius: BorderRadius.circular(50),
                ),
                hintText: 'Name-Surname',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                fillColor: Color.fromARGB(255, 255, 255, 255),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      width: 2, color: Color.fromRGBO(0, 0, 0, 1)),
                  borderRadius: BorderRadius.circular(50),
                ),
                hintText: 'Phone Number*',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                fillColor: const Color.fromARGB(255, 255, 255, 255),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      width: 2, color: Color.fromRGBO(0, 0, 0, 1)),
                  borderRadius: BorderRadius.circular(50),
                ),
                hintText: 'e-Mail',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                fillColor: Color.fromARGB(255, 255, 255, 255),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      width: 2, color: Color.fromRGBO(0, 0, 0, 1)),
                  borderRadius: BorderRadius.circular(50),
                ),
                hintText: 'Password',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 10, 61, 113),
                onPrimary: Colors.white,
                minimumSize: const Size(180, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(103),
                ),
              ),
              onPressed: () async {
                _register(context);
              },
              child: const Text(
                'Register',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Do you have an account?",
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
                            builder: (context) => GirisSayfasi()));
                  },
                  child: const Text(
                    "Log in!",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
