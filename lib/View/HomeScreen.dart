import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:novaly/Controller/News_Servies.dart';
import 'package:novaly/Controller/firebase.dart';
import 'package:novaly/View/Widget/articlePost.dart';
import 'package:novaly/View/signScreen.dart';

class homeScreen extends StatefulWidget {
  @override
  State<homeScreen> createState() => _homescreenState();
}

class _homescreenState extends State<homeScreen>
    with AutomaticKeepAliveClientMixin<homeScreen> {
  final _newsServies = NewsServies(Dio()).getHeadTitles();
  final ScrollController _scrollController = ScrollController();
  bool _showScrollButton = false;
  final _UserName = firebaseAuth.currentUser!.displayName!;

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
            expandedHeight: MediaQuery.of(context).size.height / 2,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                width: double.infinity,
                height: double.infinity,
                margin: EdgeInsets.only(bottom: 10.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(100.sp),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 25.h,
                        horizontal: 15.w,
                      ),
                      child: Row(
                        spacing: 10.w,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              firebaseAuth.currentUser?.photoURL ??
                                  "https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg",
                            ),
                          ),
                          Text(
                            "Welcome ${_UserName}",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            onPressed: () async {
                              firebaseAuth.signOut();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => signScreen(type: "i"),
                                ),
                              );
                            },
                            icon: Icon(Icons.logout),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Text(
                      "Novaly",
                      style: TextStyle(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ],
                ),
              ),
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
                  return ArticlePost(article: articles[index]);
                }, childCount: articles.length),
              );
            },
          ),
        ],
      ),
    );
  }
}
