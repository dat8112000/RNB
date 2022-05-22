import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:rnb/src/resources/Screen/search_voice_details.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'HomePage.dart';

class SearchVoiceScreen extends StatefulWidget {
  const SearchVoiceScreen({Key? key}) : super(key: key);

  @override
  _SearchVoiceScreenState createState() => _SearchVoiceScreenState();
}

class _SearchVoiceScreenState extends State<SearchVoiceScreen> {
  bool isListening = false;
  String text = '';
  FlutterTts flutterTts = FlutterTts();
  late stt.SpeechToText _speech;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _speech = stt.SpeechToText();
    readTutorial("Bạn đang ở mục tìm kiếm bằng giọng nói");
  }

  Future readTutorial(String text) async {
    await Future.delayed(const Duration(seconds: 1));
    await flutterTts.setLanguage("vi-VN");
    await flutterTts.setPitch(0.8);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Giọng nói")),
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
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xFF363f93),
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.6),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            margin: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width / 3,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Text(
                text,
                style: const TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: GestureDetector(
                onPanUpdate: (details) {
                  if (details.delta.dx < 0) {
                    flutterTts.stop();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const HomePage(),
                      ),
                      (route) => false,
                    );
                  }
                },
                onTap: () {
                  _listen();
                },
              )),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        glowColor: Colors.blueAccent,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
    );
  }

  void _listen() async {
    if (!isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            text = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => isListening = false);
      _speech.stop();
      if (text == "") {
        readTutorial("Vui lòng nói lại để tìm kiếm bài báo");
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SearchVoice(
                      voice: text,
                    )));
      }
    }
  }
}
