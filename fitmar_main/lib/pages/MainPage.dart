import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmar/pages/Recipe_page.dart';
import 'package:fitmar/pages/profile.dart';
import 'package:fitmar/pages/article_page.dart';
import 'package:fitmar/widgets/navbar.dart';
import 'package:fitmar/pages/exercise_detail_page.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({Key? key}) : super(key: key);

  @override
  State<Anasayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<Anasayfa> {
  int _selectedIndex = 0;
  String _userName = '';
  int _selectedDifficulty = 0;
  String _lastClickedExerciseName = '';
  String _lastClickedExerciseImage = '';
  String _lastClickedExerciseDescription = '';
  String _lastClickedExerciseBenefits = '';

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  Future<void> _getUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          setState(() {
            _userName = userDoc['full_name'] as String;
            var lastClickedExercise = userDoc['last_clicked_exercise'] as Map<String, dynamic>;
            _lastClickedExerciseName = lastClickedExercise['name'] as String? ?? '';
            _lastClickedExerciseImage = lastClickedExercise['image'] as String? ?? '';
            _lastClickedExerciseDescription = lastClickedExercise['description'] as String? ?? '';
            _lastClickedExerciseBenefits = lastClickedExercise['benefits'] as String? ?? '';
          });
        }
      }
    } catch (e) {
      print('Error getting user name: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> getExercisesForSelectedDifficulty() {
    String difficulty;
    if (_selectedDifficulty == 1) {
      difficulty = 'Medium';
    } else if (_selectedDifficulty == 2) {
      difficulty = 'Hard';
    } else {
      difficulty = 'Easy';
    }

    return FirebaseFirestore.instance
        .collection('exercises')
        .where('difficulty', isEqualTo: difficulty)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {
                  'name': doc['name'],
                  'image': doc['imagePath'],
                  'description': doc['description'],
                  'benefits': doc['benefits'],
                })
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: _AnaSayfa(
        userName: _userName,
        selectedDifficulty: _selectedDifficulty,
        onDifficultyChanged: (index) {
          setState(() {
            _selectedDifficulty = index;
          });
        },
        exerciseStream: getExercisesForSelectedDifficulty(),
        lastClickedExerciseName: _lastClickedExerciseName,
        lastClickedExerciseImage: _lastClickedExerciseImage,
        lastClickedExerciseDescription: _lastClickedExerciseDescription,
        lastClickedExerciseBenefits: _lastClickedExerciseBenefits,
        onExerciseSelected: (exercise) {
          setState(() {
            _lastClickedExerciseName = exercise['name'] ?? '';
            _lastClickedExerciseImage = exercise['image'] ?? '';
            _lastClickedExerciseDescription = exercise['description'] ?? '';
            _lastClickedExerciseBenefits = exercise['benefits'] ?? '';
          });
        },
      ),
      bottomNavigationBar: Navbar(
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            if (_selectedIndex == index) return;
            _selectedIndex = index;
            switch (index) {
              case 0:
                _navigateToPage(context, Anasayfa());
                break;
              case 1:
                _navigateToPage(context, YemekSayfasi());
                break;
              case 2:
                _navigateToPage(context, KesfetSayfasi());
                break;
              case 3:
                _navigateToPage(context, ProfilSayfasi());
                break;
            }
          });
        },
      ),
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.pushAndRemoveUntil(
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
      (route) => false,
    );
  }
}

class _AnaSayfa extends StatelessWidget {
  final String userName;
  final int selectedDifficulty;
  final ValueChanged<int> onDifficultyChanged;
  final Stream<List<Map<String, dynamic>>> exerciseStream;
  final String lastClickedExerciseName;
  final String lastClickedExerciseImage;
  final String lastClickedExerciseDescription;
  final String lastClickedExerciseBenefits;
  final ValueChanged<Map<String, String?>> onExerciseSelected;

  const _AnaSayfa({
    Key? key,
    required this.userName,
    required this.selectedDifficulty,
    required this.onDifficultyChanged,
    required this.exerciseStream,
    required this.lastClickedExerciseName,
    required this.lastClickedExerciseImage,
    required this.lastClickedExerciseDescription,
    required this.lastClickedExerciseBenefits,
    required this.onExerciseSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 70),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Container(
              alignment: Alignment.topLeft,
              height: 100,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome $userName",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Days with lots of sports 🔥",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Continuing",
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // MY PERSONAL PLAN Widget
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 42),
            child: lastClickedExerciseName.isNotEmpty
                ? InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExerciseDetailPage(
                            exerciseName: lastClickedExerciseName,
                            imagePath: lastClickedExerciseImage,
                            description: lastClickedExerciseDescription,
                            benefits: lastClickedExerciseBenefits,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 300,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                        image: DecorationImage(
                          image: AssetImage(lastClickedExerciseImage),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 8.0,
                            left: 8.0,
                            child: Text(
                              lastClickedExerciseName,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Text('No exercise continuing'),
          ),
          const SizedBox(height: 40),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "All Movements",
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 42),
            child: ToggleButtons(
              children: [
                Container(
                  width: 98,
                  height: 30,
                  alignment: Alignment.center,
                  child: Text("Easy"),
                ),
                Container(
                  width: 98,
                  height: 30,
                  alignment: Alignment.center,
                  child: Text("Medium"),
                ),
                Container(
                  width: 98,
                  height: 30,
                  alignment: Alignment.center,
                  child: Text("Hard"),
                ),
              ],
              isSelected: [selectedDifficulty == 0, selectedDifficulty == 1, selectedDifficulty == 2],
              onPressed: (index) {
                onDifficultyChanged(index);
              },
              borderRadius: BorderRadius.circular(8),
              selectedColor: Colors.blue,
              fillColor: Colors.white,
              borderWidth: 2,
              borderColor: Colors.grey,
              selectedBorderColor: Colors.blue,
            ),
          ),
          const SizedBox(height: 20),
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: exerciseStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No exercises available'));
              }

              return Column(
                children: snapshot.data!.map((exercise) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 45, bottom: 20),
                    child: InkWell(
                      onTap: () async {
                        User? user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .update({
                            'last_clicked_exercise': {
                              'name': exercise['name'],
                              'image': exercise['image'],
                              'description': exercise['description'],
                              'benefits': exercise['benefits'],
                            },
                          });
                        }

                        var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExerciseDetailPage(
                              exerciseName: exercise['name'] as String,
                              imagePath: exercise['image'] as String,
                              description: exercise['description'] as String,
                              benefits: exercise['benefits'] as String,
                            ),
                          ),
                        );

                        if (result != null) {
                          onExerciseSelected(result);
                        }
                      },
                      child: Container(
                        width: 300,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          image: DecorationImage(
                            image: AssetImage(exercise['image'] as String),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 8.0,
                              left: 8.0,
                              child: Text(
                                exercise['name'] as String,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
