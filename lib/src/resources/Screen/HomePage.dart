import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:rnb/src/resources/Screen/ArticleOffline.dart';
import 'package:rnb/src/resources/Screen/search_voice.dart';
import 'package:rnb/src/resources/Screen/topic_news.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterTts flutterTts = new FlutterTts();
  String text =
      'Bạn đang ở trang chủ tìm kiếm, nhấn một lần vào màn hình để tìm kiếm bằng giọng nói, hai lần để tìm kiếm bằng gợi ý, giữ màn hình để sang mục các bài báo đã đọc';
  bool _isListening = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
          backgroundColor: Colors.amber,
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                      padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                      child: Text(
                        "Nhấn một lần vào màn hình để sang trang tìm kiếm bằng giọng nói",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                ),
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
                      padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                      child: Text(
                        "Nhấn hai lần vào màn hình để sang trang tìm kiếm bằng gợi ý",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                ),
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
                      padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                      child: Text(
                        "Nhấn giữ vào màn hình để đến mục bài báo đã đọc",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: InkWell(
                hoverColor: Colors.red,
                onTap: () {
                  flutterTts.stop();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => SearchVoiceScreen(),
                    ),
                        (route) => false,
                  );
                },
                onDoubleTap: () {
                  flutterTts.stop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const TopicNews(),
                    ),
                  );
                },
                onLongPress: () {
                  flutterTts.stop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const ArticleOffline(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
}
