import 'package:flutter/material.dart';
import 'package:rnb/src/resources/Screen/HomePage.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'RNB APP',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
