import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:rnb/src/resources/Screen/HomePage.dart';
import 'package:rnb/src/resources/model/app_styles.dart';
import 'package:rnb/src/resources/model/size_configs.dart';

class MainHome extends StatefulWidget {
  const MainHome({Key? key}) : super(key: key);

  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  FlutterTts flutterTts = FlutterTts();
  String text =
      "Chào mừng bạn đến với ứng dụng đọc báo cho người khiếm thị.Để bắt đầu sử dụng vuốt từ trái sang phải để đóng app, vuốt từ phải sang trái để đến trang chủ";

  bool isListening = true;

  @override
  void initState() {
    readTutorial(text);
    super.initState();
  }

  Future readTutorial(String text) async {
    await Future.delayed(const Duration(seconds: 5));
    await flutterTts.setLanguage("vi-VN");
    await flutterTts.setPitch(0.8);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double sizeH = SizeConfig.blockSizeH!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        // decoration: const BoxDecoration(
        //     image: DecorationImage(
        //   image: AssetImage("assets/images/background.jpg"),
        //   fit: BoxFit.cover
        // )),
        child: GestureDetector(
          onPanUpdate: (details) {
            if (details.delta.dx > 0) {
              SystemNavigator.pop();
            } else if (details.delta.dx < 0) {
              flutterTts.stop();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
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
                  SizedBox(height: sizeH * 5),
                  Image.asset("assets/images/news.jpg"),
                  Container(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Center(
                          child: Text(
                              "Hỗ trợ đọc báo cho người khiếm thị",
                              style: kBodyText1,textAlign: TextAlign.center,)))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
