import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:rnb/src/resources/Screen/search_voice.dart';
import 'package:rnb/src/resources/Screen/topic_news.dart';
import 'package:rnb/src/resources/api/speech_api.dart';
import 'package:rnb/src/resources/widget/substring_highlighted.dart';
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
    setState(() {
      String text =
          'Bạn đang ở trang chủ tìm kiếm, để tìm kiếm theo nội dung hoặc chủ đề vui lòng nhấn vào màn hình để nói';
    });
    readTutorial(text);
  }

  Future readTutorial(String text) async {
    await Future.delayed(const Duration(seconds: 0));
    await flutterTts.setLanguage("vi-VN");
    await flutterTts.setPitch(0.8);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Trang chủ"),
          backgroundColor: Colors.red,
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(
                bottom: 0,
                left: 0,
                child: Image.asset("assets/images/main_bottom.png", width: 50)),
            Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  "assets/images/main_top.png",
                  width: 150,
                )),
            Center(
                child: isListening
                    ? Icon(
                        Icons.mic,
                        size: 200,
                        color: Colors.green,
                      )
                    : Icon(
                        Icons.mic_off,
                        size: 200,
                        color: Colors.red,
                      )),
            Container(
              padding: EdgeInsets.only(top: 20),
              height: double.infinity,
              width: double.infinity,
              child: InkWell(
                hoverColor: Colors.red,
                onDoubleTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchVoiceScreen()));
                },
                onLongPress: () {
                  flutterTts.stop();
                  setState(() {
                    text = "";
                    toggleRecording();
                  });
                },
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                  child: SubstringHighlight(
                    text: text,
                    terms: Command.all,
                    textStyle: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                    textStyleHighlight: TextStyle(
                      fontSize: 20.0,
                      color: Colors.red,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ],
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
                setState(() {
                  text = "";
                });
                gotoVoice();
              } else if (text.contains(Command.suggest)) {
                setState(() {
                  text = "";
                });
                gotoSuggest();
              } else
                readTutorial("Vui lòng nhấn lại để nói");
            });
          }
        },
      );

  gotoVoice() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SearchVoiceScreen()));
  }

  gotoSuggest() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TopicNews()));
  }
}
