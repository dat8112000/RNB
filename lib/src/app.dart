import 'package:flutter/material.dart';
import 'package:rnb/src/resources/Screen/ArticleOffline.dart';
import 'package:rnb/src/resources/Screen/HomePage.dart';
import 'package:rnb/src/resources/Screen/ReadArticleDB.dart';
import 'package:rnb/src/resources/Screen/topic_news.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'RNB APP',
        debugShowCheckedModeBanner: false,
        home: ArticleOffline());
  }
}
