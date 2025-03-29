import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:novaly/Model/articleModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class bookMarkNotify extends StateNotifier<List<Article>> {
  bookMarkNotify() : super([]) {
    loadBookMark();
  }

  Future<void> loadBookMark() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('BookMark');
    if (jsonString != null) {
      List<dynamic> jsonData = jsonDecode(jsonString);
      state = jsonData.map((json) => Article.fromJson(json)).toList();
    }
  }

  Future<void> saveBookMark() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonData =
        state.map((article) => article.toJson()).toList();
    prefs.setString('BookMark', jsonEncode(jsonData));
  }

  bool togglewatchLaterList(Article item) {
    bool exists = state.any((article) => article.url == item.url);

    if (exists) {
      // Remove existing item
      state = state.where((article) => article.url != item.url).toList();
      saveBookMark();
      return false;
    } else {
      // Add new item
      state = [...state, item];
      saveBookMark();
      return true;
    }
  }
}

final bookMarkProvider = StateNotifierProvider<bookMarkNotify, List<Article>>(
  (ref) => bookMarkNotify(),
);
