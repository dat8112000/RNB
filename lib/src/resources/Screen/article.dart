import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:rnb/src/resources/db/rnb_database.dart';
import 'package:rnb/src/resources/model/article_model.dart';

class ArticleScreen extends StatefulWidget {
  final String link;

  const ArticleScreen({Key? key, required this.link}) : super(key: key);

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  var document;
  var responseArticle;
  var chuoi = "";
  bool playing = false;
  List<String> content = [];
  bool isLoading = false;
  FlutterTts flutterTts = FlutterTts();
  String contentArticle = "";
  List<Article> article = [];

  String Date = "";
  late Article currentArticle;

  void extractData(String linkArticle) async {
    final response = await http.Client().get(Uri.parse(linkArticle));
    if (response.statusCode == 200) {
      setState(() {
        document = parser.parse(response.body);
        Date = document.getElementsByClassName('date')[0].text;
        responseArticle = document.getElementsByClassName('fck_detail')[0];
        for (int i = 0;
            i < responseArticle.getElementsByTagName("p").length - 1;
            i++) {
          content.add(responseArticle.getElementsByTagName("p")[i].text);
          contentArticle = contentArticle +
              responseArticle.getElementsByTagName("p")[i].text;
        }
        currentArticle = Article(
            id: document.getElementsByClassName('title-detail')[0].text,
            title: document.getElementsByClassName('title-detail')[0].text,
            content: contentArticle,
            date: DateTime.now());
      });
      RnBDatabase.instance.create(currentArticle);
    }
  }

  Future readTutorial(String text) async {
    await Future.delayed(const Duration(seconds: 1));
    await flutterTts.setLanguage("vi-VN");
    await flutterTts.setPitch(0.9);
    await flutterTts.speak(text);
    await flutterTts.awaitSpeakCompletion(true);
  }

  readArticle(List<String> content) async {
    for (int i = 0; i <= content.length - 1; i++) {
      await readTutorial(content[i]);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    extractData(widget.link);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Bài báo"),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          SizedBox(
              height: height * 8 / 10,
              child: GestureDetector(
                onPanUpdate: (details) {
                  if (details.delta.dx > 20) {
                    flutterTts.stop();
                    Navigator.pop(context);
                  }
                },
                onTap: () async {
                  setState(() {
                    playing = !playing;
                    if (playing == true) {
                      readArticle(content);
                    }
                    if (playing == false) {
                      flutterTts.stop();
                    }
                  });
                },
                child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      contentArticle,
                      style: const TextStyle(fontSize: 15),
                      textAlign: TextAlign.justify,
                    )),
              )),
          SizedBox(
            width: width,
            height: height / 10,
            child: GestureDetector(
              onPanUpdate: (details) {
                if (details.delta.dx > 30) {
                  flutterTts.stop();
                  Navigator.pop(context);
                }
              },
              onTap: () async {
                setState(() {
                  playing = !playing;
                  if (playing == true) {
                    readArticle(content);
                  }
                  if (playing == false) {
                    flutterTts.stop();
                  }
                });
              },
              child: InkWell(
                child: Icon(
                  playing == false ? Icons.play_circle : Icons.pause_circle,
                  size: height / 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
