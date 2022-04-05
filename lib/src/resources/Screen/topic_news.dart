import 'package:flutter/material.dart';
import 'package:rnb/src/resources/model/topic.dart';


class topic_news extends StatefulWidget {
  const topic_news({Key? key}) : super(key: key);
  final String title = "Các tin mới nhất";

  @override
  _topic_newsState createState() => _topic_newsState();
}

class _topic_newsState extends State<topic_news> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Topic news"),
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: <Widget>[Text("Chủ đề"),
              Expanded(
                child: ListView.builder(
                    itemCount: Topic.topic.length,
                  itemBuilder: (context, index) => Container(
                    child: ListTile(
                      title: Text(Topic.topic.keys.elementAt(index)),
                      onTap: (){},
                      trailing: Icon(Icons.volume_up),
                    ),
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
