import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:novaly/Controller/News_Servies.dart';
import 'package:novaly/View/Widget/articlePost.dart';

class homeScreen extends StatefulWidget {
  @override
  State<homeScreen> createState() => _homescreenState();
}

class _homescreenState extends State<homeScreen>
    with AutomaticKeepAliveClientMixin<homeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollButton = false;
  var _newsServies = NewsServies(Dio()).getHeadTitles();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 0 && !_showScrollButton) {
        setState(() {
          _showScrollButton = true;
        });
      } else if (_scrollController.offset == 0 && _showScrollButton) {
        setState(() {
          _showScrollButton = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.decelerate,
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton:
          (_showScrollButton)
              ? FloatingActionButton(
                onPressed: _scrollToTop,
                child: Icon(Icons.arrow_upward_outlined),
              )
              : null,
      body: CustomScrollView(
        controller: _scrollController,
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
            future: _newsServies,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      "Error while loading news ${snapshot.error}",
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
