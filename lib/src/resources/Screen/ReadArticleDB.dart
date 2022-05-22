import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ReadArticleDB extends StatefulWidget {
  final String title;
  final String content;
  final int indexArticle;

  const ReadArticleDB(
      {Key? key,
      required this.title,
      required this.content,
      required this.indexArticle})
      : super(key: key);

  @override
  _ReadArticleDBState createState() => _ReadArticleDBState();
}

class _ReadArticleDBState extends State<ReadArticleDB> {
  FlutterTts flutterTts = FlutterTts();
  int indexArticle = 0;
  bool playing = false;

  Future readTutorial(String text) async {
    await Future.delayed(const Duration(seconds: 1));
    await flutterTts.setLanguage("vi-VN");
    await flutterTts.setPitch(0.9);
    await flutterTts.speak(text);
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    indexArticle = widget.indexArticle;
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
                  if (details.delta.dx > 10) {
                    flutterTts.stop();
                    Navigator.pop(context);
                  }
                },
                onTap: () async {
                  setState(() {
                    playing = !playing;
                    if (playing == true) {
                      readTutorial(widget.content);
                    }
                    if (playing == false) {
                      flutterTts.stop();
                    }
                  });
                },
                child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      widget.content,
                      style: const TextStyle(fontSize: 15),
                      textAlign: TextAlign.justify,
                    )),
              )),
          SizedBox(
            width: width,
            height: height / 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onPanUpdate: (details) {
                    if (details.delta.dx > 10) {
                      flutterTts.stop();
                      Navigator.pop(context);
                    }
                  },
                  onTap: () async {
                    setState(() {
                      indexArticle--;
                    });
                  },
                  child: InkWell(
                    child: Icon(
                      Icons.skip_previous,
                      size: height / 10,
                    ),
                  ),
                ),
                GestureDetector(
                  onPanUpdate: (details) {
                    if (details.delta.dx > 10) {
                      flutterTts.stop();
                      Navigator.pop(context);
                    }
                  },
                  onTap: () async {
                    setState(() {
                      playing = !playing;
                      if (playing == true) {
                        print("readdddd");
                        readTutorial(widget.content);
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
                GestureDetector(
                  onPanUpdate: (details) {
                    if (details.delta.dx > 10) {
                      flutterTts.stop();
                      Navigator.pop(context);
                    }
                  },
                  onTap: () async {
                    setState(() {
                      indexArticle++;
                    });
                  },
                  child: InkWell(
                    child: Icon(
                      Icons.skip_next,
                      size: height / 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
