class Article {
  String sourceId;
  String author;
  String description;
  String url;
  String imageUrl;

  Article({
    required this.sourceId,
    required this.author,
    required this.description,
    required this.url,
    required this.imageUrl,
  });

  factory Article.fromJson(Map<String, dynamic> jsonData) {
    var source = jsonData['source']?['id'] ?? jsonData['source']?['name'] ?? "";
    return Article(
      sourceId: source,
      author:
          jsonData['author'] ??
          (source == "" ? "From Internet" : "UnKnown Journalist"),
      description: jsonData['description'] ?? "",
      url:
          jsonData['url'] ??
          "https://i.pinimg.com/474x/b7/f0/db/b7f0db1455d5a1fcfdb41ef6a13822e2.jpg",
      imageUrl:
          jsonData['urlToImage'] ??
          "https://cdn-useast1.kapwing.com/static/templates/grandma-finds-the-internet-meme-template-thumbnail-c43f97cb.webp",
    );
  }
}
