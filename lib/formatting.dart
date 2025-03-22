import 'package:flutter/material.dart';

class FormatBuilder extends StatelessWidget {
  final text;
  const FormatBuilder({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    String test = text.replaceAll('**', '__temp__');
    test = test.replaceAll('*', ' - ');
    test = test.replaceAll('__temp__', '**');
    final formattedText = _parseText(test);
    return Text.rich(TextSpan(children: formattedText));
  }
}

List<TextSpan> _parseText(String text) {
  List<TextSpan> children = [];
  final lines = text.split('\n');
  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];
    //Heading
    if (line.startsWith('##')) {
      final headingText = line.substring(2).trim();
      children.add(TextSpan(
          text: headingText,
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20)));
    }
    //Bold and normal
    else {
      final boldText = _applyBold(line);
      children.addAll(boldText);
      if (i < lines.length - 2) {
        children.add(TextSpan(text: '\n'));
      }
    }
  }
  return children;
}

List<TextSpan> _applyBold(String text) {
  List<TextSpan> childrenWords = [];
  final words = text.split('**');
  for (int i = 0; i < words.length; i++) {
    final word = words[i];

    //normal text
    if (i % 2 == 0) {
      childrenWords.add(TextSpan(text: word));
    }
//bolded text
    else {
      childrenWords.add(
          TextSpan(text: word, style: TextStyle(fontWeight: FontWeight.bold)));
    }
  }
  return childrenWords;
}
