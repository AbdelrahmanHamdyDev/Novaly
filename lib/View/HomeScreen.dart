import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:novaly/Controller/News_Servies.dart';
import 'package:novaly/View/Widget/articlePost.dart';

class homescreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Novaly",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade400,
                ),
              ),
              centerTitle: true,
            ),
          ),
          FutureBuilder(
            future: NewsServies(Dio()).getHeadTitles(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      "Error loading news",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(child: Text("No news available")),
                );
              }

              var articles = snapshot.data!;
              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return ArticlePost(
                    sourceId: articles[index].sourceId,
                    author: articles[index].author,
                    description: articles[index].description,
                    url: articles[index].url,
                    imageUrl: articles[index].imageUrl,
                  );
                }, childCount: articles.length),
              );
            },
          ),
        ],
      ),
    );
  }
}
