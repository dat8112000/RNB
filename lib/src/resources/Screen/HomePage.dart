import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:rnb/src/resources/Screen/MainHome.dart';
import 'package:rnb/src/resources/Screen/search_voice.dart';
import 'package:rnb/src/resources/Screen/topic_news.dart';
import 'package:rnb/src/resources/api/speech_api.dart';
import 'package:rnb/src/resources/widget/substring_highlighted.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterTts flutterTts = new FlutterTts();
  String text =
      'Bạn đang ở trang chủ tìm kiếm, để tìm kiếm theo nội dung hoặc chủ đề vui lòng nhấn vào màn hình để nói';
  bool isListening = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readTutorial(text);
    // toggleRecording();
  }

  Future readTutorial(String text) async {
    await Future.delayed(Duration(seconds: 5));
    await flutterTts.setLanguage("vi-VN");
    await flutterTts.setPitch(0.8);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Trang chủ"),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/microphone.png"),
              fit: BoxFit.contain,
            ),
          ),
          height: double.infinity,
          child: InkWell(
            hoverColor: Colors.red,
            onLongPress: () {
              setState(() {
                toggleRecording();
              });
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 10),
              child: SubstringHighlight(
                text: text,
                terms: Command.all,
                textStyle: TextStyle(
                  fontSize: 32.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
                textStyleHighlight: TextStyle(
                  fontSize: 32.0,
                  color: Colors.red,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      );

  Future toggleRecording() => SpeechApi.toggleRecording(
        onResult: (text) => setState(() => this.text = text),
        onListening: (isListening) {
          setState(() => this.isListening = isListening);

          if (!isListening) {
            Future.delayed(Duration(seconds: 1), () {
              text = text.toLowerCase();
              if (text.contains(Command.voice)) {
                gotoVoice();
              } else if (text.contains(Command.suggest)) {
                gotoSuggest();
              } else
                readTutorial("Vui lòng nhấn lại để nói");
            });
          }
        },
      );

  gotoVoice() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => searchVoice()));
  }

  gotoSuggest() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => topic_news()));
  }
}
