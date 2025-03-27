import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:novaly/Controller/News_Servies.dart';
import 'package:novaly/View/Widget/articlePost.dart';

class bookmarkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: NewsServies(Dio()).getHeadTitles(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            var bookmarkedArticle = snapshot.data!;
            return SizedBox(
              height: 500.h,
              child: CardSwiper(
                cardsCount: bookmarkedArticle.length,
                numberOfCardsDisplayed: 3,
                cardBuilder:
                    (context, index, percentThresholdX, percentThresholdY) =>
                        ArticlePost(article: bookmarkedArticle[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
