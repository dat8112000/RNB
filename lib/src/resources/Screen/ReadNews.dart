import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:rnb/src/resources/Screen/MainHome.dart';
import 'package:rnb/src/resources/Screen/topic_news.dart';
import 'package:rnb/src/resources/model/topic.dart';

class ReadNews extends StatefulWidget {
  const ReadNews({Key? key}) : super(key: key);

  @override
  _ReadNewsState createState() => _ReadNewsState();
}

class _ReadNewsState extends State<ReadNews> {
  FlutterTts flutterTts = FlutterTts();
  final TextEditingController textEditingController = TextEditingController();

  speak(String text) async {
    await flutterTts.setLanguage("vi-VN");
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.amber,
        child: GestureDetector(
          onPanUpdate: (details) {
            print(details);
            print(details.delta.dx);
            if (details.delta.dx > 3) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => topic_news()));
            } else if (details.delta.dx < 3) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MainHome()));
              print(Topic.topic.length);
            }
          },
        ),
      ),
    );
  }
}
