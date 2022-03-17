import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
class ReadNews extends StatefulWidget {
  const ReadNews({Key? key}) : super(key: key);

  @override
  _ReadNewsState createState() => _ReadNewsState();
}

class _ReadNewsState extends State<ReadNews> {
  FlutterTts flutterTts=FlutterTts();
  final TextEditingController textEditingController= TextEditingController();
  speak(String text)async{
    await flutterTts.setLanguage("vi-VN");
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
    
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: textEditingController,
            ),
            ElevatedButton(
                onPressed: ()=>speak(textEditingController.text),
                child: Text('Đọc bài báo')
            )
          ],
        ),
      ),
    );
  }
}
