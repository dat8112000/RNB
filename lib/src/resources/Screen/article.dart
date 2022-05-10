import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

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

  void extractData(String linkArticle) async {
    final response = await http.Client().get(Uri.parse(linkArticle));
    if (response.statusCode == 200) {
      setState(() {
        document = parser.parse(response.body);
        responseArticle = document.getElementsByClassName('fck_detail')[0];
        for (int i = 0; i <= responseArticle.children.length - 1; i++) {
          content.add(responseArticle.getElementsByTagName("p")[i].text);
        }
      });
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
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: GestureDetector(
          onPanUpdate: (details) {
            if (details.delta.dx > 0) {
              flutterTts.stop();
              Navigator.pop(context);
            }
          },
          onTap: () {
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
              playing == false
                  ? Icons.play_circle_outline
                  : Icons.pause_circle_outline,
              size: 100,
            ),
          ),
        ),
      ),
    );
  }
}
