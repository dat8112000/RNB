import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:rnb/src/resources/Screen/topic_details.dart';
import 'package:rnb/src/resources/model/topic.dart';

class topic_news extends StatefulWidget {
  const topic_news({Key? key}) : super(key: key);
  final String title = "Các tin mới nhất";

  @override
  _topic_newsState createState() => _topic_newsState();
}

int _destinationIndex = 0;

class _topic_newsState extends State<topic_news> {
  FlutterTts flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    final _scrollController = ScrollController();
    return Scaffold(
      body: GestureDetector(
        onDoubleTap: () {
          setState(() {
            if (Topic.topic.length - 1 > _destinationIndex) {
              _destinationIndex++;
            } else {
              _destinationIndex = 0;
            }
            readTutorial(Topic.topic.keys.elementAt(_destinationIndex));
          });
        },
        onLongPress: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => topicDetails(
                  link: Topic.topic.values.elementAt(_destinationIndex),
                ),
              ));
        },
        child: Center(
          child: Column(
            children: <Widget>[
              Text("Chủ đề"),
              Expanded(
                  child: ListView.builder(
                controller: _scrollController,
                itemCount: Topic.topic.length,
                itemBuilder: (context, index) => SizedBox(
                  child: Card(
                    color: index == _destinationIndex
                        ? Colors.amber
                        : Colors.blueAccent,
                    child: ListTile(
                      title: Text(Topic.topic.keys.elementAt(index)),
                      onLongPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => topicDetails(
                                link: Topic.topic.values.elementAt(_destinationIndex),
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
      ),
    );
  }

  Future readTutorial(String text) async {
    await Future.delayed(Duration(seconds: 0));
    await flutterTts.setLanguage("vi-VN");
    await flutterTts.setPitch(0.7);
    await flutterTts.speak(text);
  }
}
