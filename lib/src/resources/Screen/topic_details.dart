import 'package:flutter/material.dart';
class topicDetails extends StatelessWidget {
  final String link;
  const topicDetails({Key? key,required this.link}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(link),
    );
  }
}

