import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class ArticlePost extends StatelessWidget {
  const ArticlePost({
    required this.sourceId,
    required this.author,
    required this.description,
    required this.url,
    required this.imageUrl,
  });

  final String sourceId;
  final String author;
  final String description;
  final String url;
  final String imageUrl;

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
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openUrl(url),
      child: Card(
        color: Theme.of(context).colorScheme.surface,
        elevation: 1,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 20,
            children: [
              //post
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 5,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          author,
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (author != "FromInternet")
                        Icon(
                          Icons.check_circle_rounded,
                          color: Colors.blue,
                          size: 20,
                        ),
                      Text(
                        " @$sourceId",
                        style: TextStyle(color: Colors.black26),
                      ),
                    ],
                  ),
                  if (description.isNotEmpty) Text(description),
                ],
              ),
              //image post
              if (imageUrl.isNotEmpty)
                Container(
                  width: 350,
                  height: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.bookmark_add_outlined),
                  ),
                  IconButton(
                    onPressed: () {
                      String content = """📢 *Check this out!*
                      📝 $description  
                      
                      🔗 Read more: $url
                          """;
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
