import 'dart:convert';
import 'package:novaly/Controller/firebase.dart';
import 'package:novaly/Model/articleModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class bookMarkNotify extends StateNotifier<List<Article>> {
  bookMarkNotify() : super([]) {
    loadBookMark();
  }

  Future<void> loadBookMark() async {
    var jsonData = await Firebase_Store().getUserData();

    if (jsonData.isNotEmpty) {
      state = jsonData.map((data) => Article.fromJson(data)).toList();
    } else {
      state = [];
    }
  }

  Future<void> saveBookMark() async {
    final List<Map<String, dynamic>> jsonData =
        state.map((article) => article.toJson()).toList();
    Firebase_Store().addNewUser(jsonEncode(jsonData));
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
