import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:rnb/src/resources/Screen/MainHome.dart';
import 'package:rnb/src/resources/Screen/topic_details.dart';
import 'package:rnb/src/resources/model/topic.dart';

class TopicNews extends StatefulWidget {
  const TopicNews({Key? key}) : super(key: key);
  final String title = "Các tin mới nhất";

  @override
  _TopicNewsState createState() => _TopicNewsState();
}

int _destinationIndex = 0;

class _TopicNewsState extends State<TopicNews> {
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readTutorial("Bạn đang ở mục tìm kiếm bài báo theo chủ đề");
  }

  @override
  Widget build(BuildContext context) {
    final _scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Chủ đề"),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              children: <Widget>[
                Expanded(
                    child: ListView.builder(
                  controller: _scrollController,
                  itemCount: Topic.topic.length,
                  itemBuilder: (context, index) => SizedBox(
                    child: Card(
                      color: index == _destinationIndex
                          ? Colors.amber
                          : Colors.white,
                      child: ListTile(
                        title: Text(Topic.topic.keys.elementAt(index)),
                        onLongPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => topicDetails(
                                  topic: Topic.topic.keys.elementAt(_destinationIndex),
                                  link: Topic.topic.values
                                      .elementAt(_destinationIndex),
                                ),
                              ));
                        },
                        trailing: Icon(Icons.volume_up),
                      ),
                    ),
                  ),
                ))
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              flutterTts.stop();
              setState(() {
                if (_destinationIndex > 0) {
                  _destinationIndex--;
                } else {
                  _destinationIndex = Topic.topic.length - 1;
                }
                readTutorial(Topic.topic.keys.elementAt(_destinationIndex));
              });
            },
            onDoubleTap: () {
              flutterTts.stop();
              setState(() {
                if (Topic.topic.length - 1 > _destinationIndex) {
                  _destinationIndex++;
                } else {
                  _destinationIndex = 0;
                }
                readTutorial(Topic.topic.keys.elementAt(_destinationIndex));
              });
            },
            onPanUpdate: (details) {
              if (details.delta.dx > 0) {
                Navigator.pop(context);
              } else if (details.delta.dx < 0) {
                flutterTts.stop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MainHome()));
              }
            },
            onLongPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => topicDetails(
                      topic: Topic.topic.keys.elementAt(_destinationIndex),
                      link: Topic.topic.values.elementAt(_destinationIndex),
                    ),
                  ));
            },
          ),
        ],
      ),
    );
  }

  Future readTutorial(String text) async {
    await Future.delayed(const Duration(seconds: 0));
    await flutterTts.setLanguage("vi-VN");
    await flutterTts.setPitch(0.8);
    await flutterTts.speak(text);
  }
}
