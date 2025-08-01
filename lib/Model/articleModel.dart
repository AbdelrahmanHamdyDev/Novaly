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
    var source =
        jsonData['source']?['id'] ??
        jsonData['source']?['name'] ??
        jsonData['sourceId'] ??
        "";
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
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQauwIRNRadX_pWnwrvqusofrDqo4FxDtgt9Q&s",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "sourceId": sourceId,
      "author": author,
      "description": description,
      "url": url,
      "urlToImage": imageUrl,
    };
  }
}
