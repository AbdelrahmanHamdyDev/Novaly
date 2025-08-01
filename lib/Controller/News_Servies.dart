import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:novaly/Model/articleModel.dart';

class NewsServies {
  var dio;
  final StreamController<List<Article>> _searchStreamController =
      StreamController<List<Article>>.broadcast();

  NewsServies(this.dio);

  Stream<List<Article>> get searchResultsStream =>
      _searchStreamController.stream;

  void dispose() {
    _searchStreamController.close();
  }

  void init() {
    Future.delayed(Duration(milliseconds: 200), () {
      _searchStreamController.add([]);
    });
  }

  Future<List<Article>> getHeadTitles() async {
    var response = await dio.get(
      'https://newsapi.org/v2/top-headlines?country=us&apiKey=${dotenv.get('NewsApi')}',
    );

    Map<String, dynamic> jsonData = response.data;
    List<dynamic> articles = jsonData['articles'];
    if (articles.isNotEmpty) {
      return articles
          .map((jsonArticle) => Article.fromJson(jsonArticle))
          .toList();
    }
    return [];
  }

  getSearchResult(String UserText) async {
    String query = Uri.encodeQueryComponent(UserText);
    final response = await dio.get(
      'https://newsapi.org/v2/everything?q=$query&apiKey=${dotenv.get('NewsApi')}',
    );
    Map<String, dynamic> jsonData = response.data;
    List<dynamic> articles = jsonData['articles'];
    if (articles.isNotEmpty) {
      List<Article> articleList =
          articles.map((jsonArticle) => Article.fromJson(jsonArticle)).toList();

      _searchStreamController.add(articleList);
    } else {
      _searchStreamController.add([]);
    }
  }

  // getBookMarked() {
  //   //Provider ( get )
  // }

  // storeArticle() {
  //   //Provider ( store )
  // }
}
