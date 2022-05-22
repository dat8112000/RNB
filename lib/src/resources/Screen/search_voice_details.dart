import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:rnb/src/resources/Screen/search_voice.dart';

import 'article.dart';

class SearchVoice extends StatefulWidget {
  final String voice;

  const SearchVoice({Key? key, required this.voice}) : super(key: key);

  @override
  _SearchVoiceState createState() => _SearchVoiceState();
}

class _SearchVoiceState extends State<SearchVoice> {
  String link = "https://timkiem.vnexpress.net/?q=";
  String voice = "";
  String linkRequest = "";
  var document;
  bool checkIndex = false;
  var responseArticle;
  var chuoi = "";
  List<String> listLink = [];
  bool isLoading = false;
  int _destinationIndex = 0;
  FlutterTts flutterTts = FlutterTts();

  Future readTutorial(String text) async {
    await Future.delayed(const Duration(seconds: 0));
    await flutterTts.setLanguage("vi-VN");
    await flutterTts.setPitch(0.8);
    await flutterTts.speak(text);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    voice = widget.voice;
    linkRequest = link + voice;
    extractData(linkRequest);
    readTutorial("Bạn đang tìm kiếm các bài báo về chủ đề $voice");
    Future.delayed(const Duration(seconds: 10), () {
      if (responseArticle == null) {
        readTutorial(
            "Không có bài báo liên quan đến nội dung bạn tìm, vuốt từ phải sang trái để đi đến màn hình tìm kiếm");
      }
    });
  }

  void extractData(voice) async {
    final response = await http.Client().get(Uri.parse(voice));
    if (response.statusCode == 200) {
      setState(() {
        document = parser.parse(response.body);
        responseArticle = document
            .getElementsByClassName('width_common list-news-subfolder')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Các bài báo tìm kiếm"),
        elevation: 10,
      ),
      body: SafeArea(
          child: responseArticle == null
              ? Stack(
                  children: [
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          if (details.delta.dx > 0) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const SearchVoiceScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                      ),
                    )
                  ],
                )
              : GestureDetector(
                  onPanUpdate: (details) {
                    if (details.delta.dx > 0) {
                      flutterTts.stop();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const SearchVoiceScreen(),
                        ),
                        (route) => false,
                      );
                    }
                  },
                  onTap: () {
                    flutterTts.stop();
                    setState(() {
                      checkIndex = true;
                      if (_destinationIndex > 0) {
                        _destinationIndex--;
                        if (listLink.length <
                                responseArticle.children.length - 1 &&
                            checkIndex == true) {
                          for (int i = 0;
                              i < responseArticle.children.length;
                              i++) {
                            listLink.add(responseArticle.children[i]
                                .getElementsByTagName("a")[1]
                                .attributes['href']);
                          }
                        }
                      } else {
                        _destinationIndex = responseArticle.children.length - 1;
                      }
                      readTutorial(responseArticle
                          .children[_destinationIndex].children[1].text
                          .trim());
                    });
                  },
                  onDoubleTap: () {
                    flutterTts.stop();
                    setState(() {
                      checkIndex = true;
                      if (responseArticle.children.length - 1 >
                          _destinationIndex) {
                        _destinationIndex++;
                        if (listLink.length <
                                responseArticle.children.length - 1 &&
                            checkIndex == true) {
                          for (int i = 0;
                              i < responseArticle.children.length;
                              i++) {
                            listLink.add(responseArticle.children[i]
                                .getElementsByTagName("a")[1]
                                .attributes['href']);
                          }
                        }
                      } else {
                        _destinationIndex = 0;
                      }
                      readTutorial(responseArticle
                          .children[_destinationIndex].children[1].text
                          .trim());
                    });
                  },
                  onLongPress: () {
                    flutterTts.stop();
                    if (_destinationIndex == 0 && checkIndex == false) {
                      for (int i = 0;
                          i < responseArticle.children.length;
                          i++) {
                        listLink.add(responseArticle.children[i]
                            .getElementByTagName("a")[1]
                            .attributes['href']);
                      }
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ArticleScreen(
                              link: responseArticle.children[_destinationIndex]
                                  .getElementsByTagName("a")[1]
                                  .attributes['href'],
                              listLink: listLink,
                              indexArticle: _destinationIndex,
                            )));
                  },
                  child: Column(
                    children: [
                      Expanded(
                          child: ListView.builder(
                        controller: _scrollController,
                        itemCount: responseArticle.children.length,
                        itemBuilder: (context, index) => SizedBox(
                          child: Card(
                            color: index == _destinationIndex
                                ? Colors.green
                                : Colors.white,
                            child: ListTile(
                              title: Text(responseArticle
                                  .children[index].children[1].text
                                  .trim()),
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                )),
    );
  }
}
