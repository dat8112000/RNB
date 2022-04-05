import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:rnb/src/resources/Screen/HomePage.dart';
import 'package:rnb/src/resources/Screen/ReadNews.dart';
import 'package:rnb/src/resources/Screen/topic_news.dart';
import 'package:rnb/src/resources/api/speech_api.dart';
import 'package:rnb/src/resources/model/app_styles.dart';
import 'package:rnb/src/resources/model/size_configs.dart';
import 'package:rnb/src/resources/model/topic.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../utils.dart';

class MainHome extends StatefulWidget {
  const MainHome({Key? key}) : super(key: key);

  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  final Map<String, HighlightedWord> _highlights = {
    'giọng nói': HighlightedWord(
      onTap: () => print('giọng nói'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'gợi ý': HighlightedWord(
      onTap: () => print('gợi ý'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
  };
  late stt.SpeechToText _speech;
  bool _isListening = true;
  FlutterTts flutterTts = new FlutterTts();
  String text =
      "Chào mừng bạn đến với ứng dụng đọc báo cho người khiếm thị.Để bắt đầu đọc báo,mời bạn tìm kiếm theo gợi ý hoặc giọng nói";

  bool isListening = true;

  @override
  void initState() {
    readTutorial(text);
    super.initState();
    _speech = stt.SpeechToText();
    toggleRecording();
  }

  Future readTutorial(String text) async {
    await Future.delayed(Duration(seconds: 5));
    await flutterTts.setLanguage("vi-VN");
    await flutterTts.setPitch(0.8);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double sizeH = SizeConfig.blockSizeH!;
    double sizeV = SizeConfig.blockSizeV!;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/background.jpg"),
          fit: BoxFit.cover,
        )),
        child: GestureDetector(
          onPanUpdate: (details) {
            print(details);
            print(details.delta.dx);
            if (details.delta.dx > 0) {
              SystemNavigator.pop();
            } else if (details.delta.dx < 0) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => topic_news()));
              print(Topic.topic.values.elementAt(2));

            }
          },
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                child: Text(""),
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  child:
                      Image.asset("assets/images/main_bottom.png", width: 50)),
              Positioned(
                  top: 0,
                  left: 0,
                  child: Image.asset(
                    "assets/images/main_top.png",
                    width: 150,
                  )),
              Column(
                children: [
                  SizedBox(height: sizeH * 20),
                  Text(
                    "WELCOME TO RNB",
                    style: kTitle1,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: sizeH * 20),
                  Center(child: Text(text, style: kBodyText1))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future toggleRecording() => SpeechApi.toggleRecording(
        onResult: (text) => setState(() => this.text = text),
        onListening: (isListening) {
          setState(() => this.isListening = isListening);
          if (!isListening) {
            Future.delayed(Duration(seconds: 1), () {
              Utils.scanText(text);
            });
          }
        },
      );
}
