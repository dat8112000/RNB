import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:rnb/src/resources/db/rnb_database.dart';
import 'package:rnb/src/resources/model/article_model.dart';

import 'ReadArticleDB.dart';

class ArticleOffline extends StatefulWidget {
  const ArticleOffline({Key? key}) : super(key: key);

  @override
  _ArticleOfflineState createState() => _ArticleOfflineState();
}

class _ArticleOfflineState extends State<ArticleOffline> {
  final textController = TextEditingController();
  final _scrollController = ScrollController();
  List<Article> article = [];
  List<Article> articleView = [];
  int _destinationIndex = 0;
  late Article currentArticle;
  FlutterTts flutterTts = FlutterTts();

  Future readTutorial(String text) async {
    await Future.delayed(const Duration(seconds: 0));
    await flutterTts.setLanguage("vi-VN");
    await flutterTts.setPitch(0.8);
    await flutterTts.speak(text);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshArticle();
    readTutorial(
        "Bạn đang ở mục những bài báo đã xem, để xem các bài báo vui lòng nhấn 2 lần vào màn hình");
  }

  Future refreshArticle() async {
    this.articleView = await RnBDatabase.instance.readAllNotes();
    setState(() {
      article = articleView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Các bài báo đã đọc"),
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                  child: ListView.builder(
                controller: _scrollController,
                itemCount: article.length,
                itemBuilder: (context, index) => SizedBox(
                  child: Card(
                    elevation: 5,
                    color: index == _destinationIndex
                        ? Colors.amber
                        : Colors.white,
                    child: ListTile(
                      leading: Text(
                          "${article[index].date.hour}:${article[index].date.minute}"),
                      title: Text("${article[index].id}"),
                      onLongPress: () {
                        flutterTts.stop();
                        setState(() {
                          String title = article[_destinationIndex].title;
                          String content = article[_destinationIndex].content;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReadArticleDB(
                                  title: title,
                                  content: content,
                                  indexArticle: _destinationIndex,
                                ),
                              ));
                        });
                      },
                    ),
                  ),
                ),
              ))
            ],
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {
                flutterTts.stop();
                if (article.length == 0) {
                  readTutorial("Chưa có bài báo nào");
                } else {
                  setState(() {
                    if (_destinationIndex > 0) {
                      _destinationIndex--;
                    } else {
                      _destinationIndex = article.length - 1;
                    }
                    readTutorial(article[_destinationIndex].title);
                  });
                }
              },
              onDoubleTap: () {
                flutterTts.stop();
                if (article.length == 0) {
                  readTutorial("Chưa có bài báo nào");
                } else {
                  setState(() {
                    if (article.length - 1 > _destinationIndex) {
                      _destinationIndex++;
                    } else {
                      _destinationIndex = 0;
                    }
                    readTutorial(article[_destinationIndex].title);
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
