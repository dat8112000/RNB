import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:rnb/src/resources/Screen/search_voice_details.dart';
import 'package:rnb/src/resources/api/speech_api.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SearchVoiceScreen extends StatefulWidget {
  const SearchVoiceScreen({Key? key}) : super(key: key);

  @override
  _SearchVoiceScreenState createState() => _SearchVoiceScreenState();
}

class _SearchVoiceScreenState extends State<SearchVoiceScreen> {
  late stt.SpeechToText _speech;
  bool isListening = false;
  String text = '';
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
            padding: const EdgeInsets.only(top: 10),
            height: double.infinity,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  text,
                  style: const TextStyle(fontSize: 30, fontFamily: "Lora"),
                )
              ],
            ),
          ),
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
          SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: GestureDetector(
                onLongPress: () {
                  toggleRecording();
                },
              )),
        ],
      ),
    );
  }

  Future toggleRecording() => SpeechApi.toggleRecording(
        onResult: (text) => setState(() => this.text = text),
        onListening: (isListening) {
          setState(() => this.isListening = isListening);

          if (!isListening) {
            Future.delayed(const Duration(seconds: 1), () {
              if (text.isEmpty) {
                readTutorial("Vui lòng nhấn lại để nói");
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchVoice(
                              voice: text,
                            )));
              }
            });
          }
        },
      );
}
