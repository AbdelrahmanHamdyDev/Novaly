import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:novaly/Controller/riverpodManager.dart';
import 'package:novaly/View/Widget/articlePost.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class bookmarkScreen extends ConsumerWidget {
  const bookmarkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkedArticles = ref.watch(bookMarkProvider);

    return Scaffold(
      body: Center(
        child:
            (bookmarkedArticles.isNotEmpty)
                ? SizedBox(
                  height: 500.h,
                  child: CardSwiper(
                    isLoop: true,
                    cardsCount: bookmarkedArticles.length,
                    numberOfCardsDisplayed:
                        (bookmarkedArticles.length <= 3)
                            ? bookmarkedArticles.length
                            : 3,
                    cardBuilder:
                        (
                          context,
                          index,
                          percentThresholdX,
                          percentThresholdY,
                        ) => ArticlePost(article: bookmarkedArticles[index]),
                  ),
                )
                : Center(
                  child: Text(
                    "There's no Articles in BookMark\nTry to Add Some",
                  ),
                ),
      ),
    );
  }
}
