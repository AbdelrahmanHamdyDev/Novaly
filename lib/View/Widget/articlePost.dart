import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:novaly/Controller/riverpodManager.dart';
import 'package:novaly/Model/articleModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class ArticlePost extends ConsumerWidget {
  const ArticlePost({required this.article});

  final Article article;

  Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    } else {
      print(
        '===============================Could not launch $url==========================',
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool _IsMarked = ref.watch(bookMarkProvider).contains(article);

    return InkWell(
      onTap: () => openUrl(article.url),
      child: Card(
        color: Theme.of(context).colorScheme.onInverseSurface,
        elevation: 1,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 10.h,
            children: [
              //post
              Row(
                spacing: 3.w,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      article.author,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 18.sp),
                    ),
                  ),
                  if (article.author != "FromInternet")
                    Icon(
                      Icons.check_circle_rounded,
                      color: Colors.lightBlue,
                      size: 18.sp,
                    ),
                  Text(
                    " @${article.sourceId}",
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 150),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              if (article.description.isNotEmpty)
                Flexible(
                  child: Text(
                    article.description,
                    maxLines: 3,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              //image post
              if (article.imageUrl.isNotEmpty)
                Container(
                  width: 350.w,
                  height: 250.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(article.imageUrl),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(20.sp),
                  ),
                ),
              //buttons
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      bool result = ref
                          .watch(bookMarkProvider.notifier)
                          .togglewatchLaterList(article);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            (result)
                                ? "Added To BookMark"
                                : "Removed From BookMark",
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      key: ValueKey(_IsMarked),
                      (_IsMarked)
                          ? Icons.bookmark_remove
                          : Icons.bookmark_add_outlined,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      String content =
                          "📢 *Check this out!*   📝${article.description}   🔗Read more: ${article.url}";
                      Share.share(
                        content,
                        subject: "Interesting Article, I would like to share",
                      );
                    },
                    icon: Icon(Icons.share),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
