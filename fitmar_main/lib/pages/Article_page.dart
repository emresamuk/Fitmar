import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitmar/pages/Article_detail.dart';
import 'package:fitmar/widgets/navbar.dart';
import 'package:fitmar/pages/anasayfa.dart';
import 'package:fitmar/pages/profile.dart';
import 'package:fitmar/pages/Recipe_page.dart';
import 'package:fitmar/models/article.dart'; 

class KesfetSayfasi extends StatefulWidget {
  const KesfetSayfasi({Key? key}) : super(key: key);

  @override
  State<KesfetSayfasi> createState() => _KesfetSayfasiState();
}

class _KesfetSayfasiState extends State<KesfetSayfasi> {
  int _selectedIndex = 2;
  List<Article> articles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('articles').get();
      setState(() {
        articles = snapshot.docs.map((doc) => Article.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching articles: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('ARTICLES')),
        backgroundColor: const Color.fromARGB(255, 10, 61, 113),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return _buildArticleCard(articles[index]);
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
                case 1:
                  _navigateToPage(context, YemekSayfasi());
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

  Widget _buildArticleCard(Article article) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        child: InkWell(
          onTap: () {
            _navigateToArticleDetail(context, article);
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  article.shortExplanation,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToArticleDetail(BuildContext context, Article article) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => ArticleDetailPage(article: article),
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
