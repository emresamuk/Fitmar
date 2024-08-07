import 'package:fitmar/pages/MainPage.dart';
import 'package:flutter/material.dart';

class StartWorkoutPage extends StatelessWidget {
  const StartWorkoutPage({Key? key}) : super(key: key);

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
            const Padding(padding: EdgeInsets.only(left: 20),
            child: Text(
              "YOU ARE READY FOR WORKOUT",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
            ),
            ),
            const SizedBox(height: 10,),
            const Padding(padding: EdgeInsets.only(left: 20),
            child: Text(
              "Complete your profile in edit profile section for best usage!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),
            ),
            Container(
              padding: EdgeInsets.only(left: 50),
              height: 400,
              width: 400,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/girl_practising.png"),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 10, 61, 113), 
                  minimumSize: const Size(200, 50), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), 
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Anasayfa()), 
                  );
                },
                child: const Text(
                  "Start Workout",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, 
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
