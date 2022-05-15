import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:rnb/src/resources/Screen/article.dart';

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
  var responseArticle;
  var chuoi = "";
  bool isLoading = false;
  int _destinationIndex = 0;
  FlutterTts flutterTts = FlutterTts();

  Future readTutorial(String text) async {
    await Future.delayed(const Duration(seconds: 0));
    await flutterTts.setLanguage("vi-VN");
    await flutterTts.setPitch(0.8);
    await flutterTts.speak(text);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    voice = widget.voice;
    linkRequest = link + voice;
    extractData(linkRequest);
  }

  void extractData(voice) async {
    final response = await http.Client().get(Uri.parse(voice));
    if (response.statusCode == 200) {
      setState(() {
        document = parser.parse(response.body);
        responseArticle = document
            .getElementsByClassName('width_common list-news-subfolder')[0];
        var x = responseArticle.getElementsByTagName("a")[1].attributes['href'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _scrollController = ScrollController();
    return Scaffold(
      body: SafeArea(
          child: document == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : GestureDetector(
                  onDoubleTap: () {
                    setState(() {
                      if (responseArticle.children.length - 1 >
                          _destinationIndex) {
                        _destinationIndex++;
                      } else {
                        _destinationIndex = 0;
                      }
                      readTutorial(responseArticle
                          .children[_destinationIndex].children[1].text
                          .trim());
                    });
                  },
                  onLongPress: () {},
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
                              onLongPress: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ArticleScreen(
                                            link: responseArticle
                                                .getElementsByTagName("a")[1]
                                                .attributes['href'])));
                              },
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                )
          // ListView.builder(
          //         itemCount: responseArticle.children.length,
          //         itemBuilder: (context, int index) => SizedBox(
          //           child: Card(
          //             child: ListTile(
          //               title: Text(responseArticle
          //                   .children[index].children[1].text
          //                   .trim()),
          //             ),
          //           ),
          //         ),
          //       ),
          ),
    );
  }
}
