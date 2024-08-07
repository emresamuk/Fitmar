import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitmar/pages/article_page.dart';
import 'package:fitmar/pages/profile.dart';
import 'package:fitmar/widgets/navbar.dart';
import 'package:fitmar/pages/anasayfa.dart';
import 'package:fitmar/pages/Recipe_detail_page.dart';

class Recipe {
  final String title;
  final String imagePath;
  final String description;
  final String name;
  final String ingredients;
  final String recipe;

  Recipe({
    required this.title,
    required this.imagePath,
    required this.description,
    required this.name,
    required this.ingredients,
    required this.recipe,
  });

  factory Recipe.fromFirestore(Map<String, dynamic> data) {
    return Recipe(
      title: data['title'] ?? '',
      imagePath: data['imagePath'] ?? '',
      description: data['description'] ?? '',
      name: data['name'] ?? '',
      ingredients: data['ingredients'] ?? '',
      recipe: data['recipe'] ?? '',
    );
  }
}

class YemekSayfasi extends StatefulWidget {
  @override
  _YemekSayfasiState createState() => _YemekSayfasiState();
}

class _YemekSayfasiState extends State<YemekSayfasi> {
  int _selectedIndex = 1;
  List<Recipe> recipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  Future<void> _fetchRecipes() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('recipes').get();
      setState(() {
        recipes = snapshot.docs.map((doc) => Recipe.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching recipes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('RECIPES')),
        backgroundColor: const Color.fromARGB(255, 10, 61, 113),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                return _buildRecipeCard(context, recipes[index]);
              },
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
                case 2:
                  _navigateToPage(context, const KesfetSayfasi());
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

  Widget _buildRecipeCard(BuildContext context, Recipe recipe) {
    return GestureDetector(
      onTap: () {
        _navigateToRecipeDetail(context, recipe);
      },
      child: Card(
        elevation: 15,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.asset(
                  recipe.imagePath,
                  fit: BoxFit.fill,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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

  void _navigateToRecipeDetail(BuildContext context, Recipe recipe) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => RecipeDetailPage(recipe: recipe),
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
