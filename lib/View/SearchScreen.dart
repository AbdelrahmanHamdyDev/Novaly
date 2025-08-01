import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:novaly/Controller/News_Servies.dart';
import 'package:novaly/Model/articleModel.dart';
import 'package:novaly/View/Widget/articlePost.dart';

class searchScreen extends StatefulWidget {
  @override
  State<searchScreen> createState() => _SearchpageState();
}

class _SearchpageState extends State<searchScreen>
    with AutomaticKeepAliveClientMixin<searchScreen> {
  final TextEditingController _controller = TextEditingController();
  NewsServies newsServies = NewsServies(Dio());
  String enteredText = "";
  final ScrollController _scrollController = ScrollController();
  bool _showScrollButton = false;

  @override
  void initState() {
    super.initState();
    newsServies.init();
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
    super.dispose();
    _controller.dispose();
    newsServies.dispose();
    _scrollController.dispose();
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
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(child: SizedBox(height: 20.h)),
            SliverAppBar(
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: EdgeInsets.only(
                  left: 30.w,
                  right: 30.w,
                  bottom: 10.h,
                ),
                title: SearchBar(
                  controller: _controller,
                  hintText: " Search...",
                  leading: Icon(Icons.search),
                  onSubmitted: (userText) {
                    newsServies.getSearchResult(userText);
                    setState(() {
                      enteredText = userText;
                    });
                  },
                  trailing: [
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        setState(() {
                          enteredText = "";
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 10.h)),
            if (enteredText.isNotEmpty)
              StreamBuilder(
                stream: newsServies.searchResultsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snapshot.hasError) {
                    return SliverToBoxAdapter(
                      child: Center(child: Text("Error: ${snapshot.error}")),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Center(child: Text("No articles found")),
                    );
                  }
                  List<Article> searchArticles = snapshot.data!;
                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return ArticlePost(article: searchArticles[index]);
                    }, childCount: searchArticles.length),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
