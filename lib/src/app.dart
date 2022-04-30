import 'package:flutter/material.dart';
import 'package:rnb/src/resources/Screen/article.dart';
import 'package:rnb/src/resources/Screen/search_voice_details.dart';
import 'package:rnb/src/resources/Screen/topic_details.dart';
import 'package:rnb/src/resources/Screen/topic_news.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RNB APP',
      debugShowCheckedModeBanner: false,
      home: ArticleScreen(link: "https://vnexpress.net/vu-an-ba-nguyen-phuong-hang-co-the-do-mot-co-quan-dieu-tra-4455075.html")
    );
  }
}
