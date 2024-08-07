class Article {
  final String name;
  final String content;
  final String shortExplanation;
  final String explanation;
  final String link;

  Article({
    required this.name,
    required this.content,
    required this.shortExplanation,
    required this.explanation,
    required this.link,
  });

  factory Article.fromFirestore(Map<String, dynamic> data) {
    return Article(
      name: data['name'] ?? '',
      content: data['content'] ?? '',
      shortExplanation: data['shortExplanation'] ?? '',
      explanation: data['Explanation'] ?? '',
      link: data['link'] ?? '',
    );
  }
}
