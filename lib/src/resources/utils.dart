import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rnb/src/resources/Screen/HomePage.dart';
import 'package:rnb/src/resources/Screen/MainHome.dart';
import 'package:rnb/src/resources/Screen/topic_news.dart';

class Command {
  static final all = [voice, suggest];

  static const voice = 'giọng nói';
  static const suggest = 'gợi ý';
}

class Utils {
  static void scanText(String rawText) {
    final text = rawText.toLowerCase();

    if (text.contains(Command.voice)) {
      final voice = _getTextAfterCommand(text: text, command: Command.voice);
      print(voice);
    } else if (text.contains(Command.suggest)) {
      final url = _getTextAfterCommand(text: text, command: Command.suggest);
      Get.to(const topic_news());
    }
    // else if (text.contains(Command.browser2)) {
    //   final url = _getTextAfterCommand(text: text, command: Command.browser2);
    //
    //   openLink(url: url);
    // }
  }

  static String? _getTextAfterCommand({
    required String text,
    required String command,
  }) {
    final indexCommand = text.indexOf(command);
    final indexAfter = indexCommand + command.length;

    if (indexCommand == -1) {
      return null;
    } else {
      return text.substring(indexAfter).trim();
    }
  }


// static Future openEmail({
//   @required String body,
// }) async {
//   final url = 'mailto: ?body=${Uri.encodeFull(body)}';
//   await _launchUrl(url);
// }
//
// static Future _launchUrl(String url) async {
//   if (await canLaunch(url)) {
//     await launch(url);
//   }
// }
}