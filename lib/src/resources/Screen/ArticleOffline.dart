import 'package:flutter/material.dart';
import 'package:rnb/src/resources/db/rnb_database.dart';
import 'package:rnb/src/resources/model/article_model.dart';

class ArticleOffline extends StatefulWidget {
  const ArticleOffline({Key? key}) : super(key: key);

  @override
  _ArticleOfflineState createState() => _ArticleOfflineState();
}

class _ArticleOfflineState extends State<ArticleOffline> {
  final textController = TextEditingController();

  List<Article> article = [];

  late Article currentArticle;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshArticle();
  }
  Future refreshArticle() async {
    this.article = await RnBDatabase.instance.readAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text(
                        "${article[index].date.hour}:${article[index].date.minute}"),
                    title: Text("${article[index].id}"),
                  );
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: article.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
