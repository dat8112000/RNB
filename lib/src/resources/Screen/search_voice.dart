import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:rnb/src/resources/Screen/search_voice_details.dart';
import 'package:rnb/src/resources/api/speech_api.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class searchVoiceScreen extends StatefulWidget {
  const searchVoiceScreen({Key? key}) : super(key: key);

  @override
  _searchVoiceScreenState createState() => _searchVoiceScreenState();
}

class _searchVoiceScreenState extends State<searchVoiceScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future readTutorial(String text) async {
    await Future.delayed(const Duration(seconds: 3));
    await flutterTts.setLanguage("vi-VN");
    await flutterTts.setPitch(0.8);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search by voice"),
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
          Container(
            padding: EdgeInsets.only(top: 10),
            height: double.infinity,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  _text,
                  style: TextStyle(fontSize: 30, fontFamily: "Lora"),
                )
              ],
            ),
          ),
          Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/microphone.png"),
                  fit: BoxFit.scaleDown,
                ),
              ),
              width: double.infinity,
              height: double.infinity,
              child: GestureDetector(
                onLongPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => searchVoice(voice: _text)));
                },
              )),
        ],
      ),
    );
  }

  Future toggleRecording() => SpeechApi.toggleRecording(
        onResult: (text) => setState(() => this._text = text),
        onListening: (isListening) {
          setState(() => this._isListening = isListening);

          if (!_isListening) {
            Future.delayed(Duration(seconds: 1), () {
              if (_text.isEmpty) {
                readTutorial("Vui lòng nhấn lại để nói");
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => searchVoice(voice: _text)));
              }
            });
          }
        },
      );
}
