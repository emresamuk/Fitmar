import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SifremiUnuttum extends StatelessWidget {
  const SifremiUnuttum({Key? key});

  Future<void> _passwordReset(BuildContext context, String email) async {
    try {
      // Send password reset email via Firebase Authentication
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Provide feedback to user if email was sent successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("A password reset email has been sent. Please check your email."),
        ),
      );
    } catch (e) {
      print("Error sending password reset email: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred while sending the password reset email: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String email = "";

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 100),
              child: Text(
                "Forgot Password",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                "Please write your registered e-mail address in the space below and click the button. The password reset link will be sent to your e-mail shortly.",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(height: 30),
            Container(
              height: 250,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: TextField(
                      onChanged: (value) => email = value,
                      decoration: InputDecoration(
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 2,
                            color: Color.fromRGBO(0, 0, 0, 1),
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        hintText: 'e-mail',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        _passwordReset(context, email);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 319,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(19),
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
                          'Send Link',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
