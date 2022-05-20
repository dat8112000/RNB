import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:rnb/src/resources/Screen/search_voice_details.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

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
        title: const Text("Giọng nói")
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SvgPicture.asset("assets/images/home.svg",fit: BoxFit.fill,),
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
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: GestureDetector(
                onTap: () {
                  print("xxx");
                  _listen();
                },
              )),
        ],
      ),
    );
  }

  void _listen() async {
    print("xxxxxxxxxxxxxxxxxxxxxxxxx");
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
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SearchVoice(
                    voice: text,
                  )));
    }
  }
}
