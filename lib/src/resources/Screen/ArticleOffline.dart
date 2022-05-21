import 'package:flutter/material.dart';
import 'package:rnb/src/resources/Screen/ReadArticleDB.dart';
import 'package:rnb/src/resources/db/rnb_database.dart';
import 'package:rnb/src/resources/model/article_model.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshArticle();
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
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Expanded(
                child: ListView.builder(
              controller: _scrollController,
              itemCount: article.length,
              itemBuilder: (context, index) => SizedBox(
                child: Card(
                  elevation: 5,
                  color:
                      index == _destinationIndex ? Colors.amber : Colors.white,
                  child: ListTile(
                    leading: Text(
                        "${article[index].date.hour}:${article[index].date.minute}"),
                    title: Text("${article[index].id}"),
                    onLongPress: () {
                      setState(() {
                        String title = article[_destinationIndex].title;
                        String content = article[_destinationIndex].content;
                        print(content);
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
      ),
    );
  }
}
