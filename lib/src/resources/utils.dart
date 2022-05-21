class Command {
  static final all = [voice, suggest];

  static const voice = 'giọng nói';
  static const suggest = 'gợi ý';
  static const wasRead = 'đã đọc';
}

class Utils {
  static void scanText(
      String rawText, Function onSuccessA, Function onSuccessB,Function onSuccessC) {
    final text = rawText.toLowerCase();

    if (text.contains(Command.voice)) {
      onSuccessA();
    }
    if (text.contains(Command.suggest)) {
      onSuccessB();
    }
    if (text.contains(Command.wasRead)) {
      onSuccessC();
    }
  }
}
