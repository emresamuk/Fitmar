
import 'package:fitmar/pages/Login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HesapDogrulama extends StatelessWidget {
  const HesapDogrulama({Key? key}) : super(key: key);

  Future<void> sendVerificationEmail(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Verification email has been sent. Please check your email."),
        ),
      );
    } else if (user != null && user.emailVerified) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Your email address has already been verified.'),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('User not found or email not verified.'),
          );
        },
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
            SizedBox(height: 30),
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GirisSayfasi()));               
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            const SizedBox( height: 40,),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "ACCOUNT VERIFICATION",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(height: 20,),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "Press the button for verification and check your email!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
            ),
            SizedBox(height: 20,),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  sendVerificationEmail(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 200,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.25),
                        offset: Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                    color: const Color.fromARGB(255, 10, 61, 113),
                  ),
                  child: const Text(
                    'Get Link',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 23),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
