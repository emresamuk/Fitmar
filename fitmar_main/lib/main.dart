import 'package:flutter/material.dart';
import 'package:fitmar/pages/Login.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    home: WelcomeScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            children: [
              _buildPage(
                'Welcome to FitMar',
                'We are here to make Marmara’s students\' activities more effective and comfortable while doing sports.',
                'assets/indir-removebg-preview.png', 
              ),
              _buildPage(
                'Planning',
                'We are planning your sports routine for your day.',
                'assets/network-activity-lines.png', 
              ),
              _buildPage(
                'Health Care',
                'We also care about your health. You can follow your BMI value from the app.',
                'assets/kit-fitness-tracker.png', 
              ),
              _buildPage(
                'Not Only For Fitness',
                'We provide popup advices about other sports, nutrition, etc.',
                'assets/urban-woman-working-out-with-a-fitness-trainer.png', 
              ),
              _buildPage(
                'JOIN US',
                'Join us and make your sports great again!!',
                'assets/indir-removebg-preview.png', 
                isLastPage: true,
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, 
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPageIndex == index ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(String title, String description, String imagePath,
      {bool isLastPage = false}) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250, 
            height: 250, 
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain, 
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          if (isLastPage) ...[
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => GirisSayfasi(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 10, 61, 113),
                onPrimary: Colors.white,
                padding: const EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                fixedSize: const Size(250, 60),
              ),
              child: const Text('Let’s Explore', style: TextStyle(fontSize: 20)),
            ),
          ],
        ],
      ),
    );
  }
}