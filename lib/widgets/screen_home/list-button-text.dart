import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ListButtonText extends StatefulWidget {
  final String textToTalk;
  final bool isDetection;

  const ListButtonText(
      {super.key, required this.textToTalk, required this.isDetection});

  @override
  State<ListButtonText> createState() => _ListButtonTextState();
}

class _ListButtonTextState extends State<ListButtonText> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.volume_up,
              color: widget.isDetection ? Colors.grey : Colors.blue),
          onPressed: () {
            speak(widget.textToTalk);
          },
        ),
        Row(
          children: [
            IconButton(
                icon: Icon(Icons.copy,
                    color: widget.isDetection ? Colors.grey : Colors.blue),
                onPressed: widget.isDetection
                    ? null
                    : () {
                        // Copiar al portapapeles
                        Clipboard.setData(
                            ClipboardData(text: widget.textToTalk));
                      }),
            IconButton(
              icon: Icon(Icons.bookmark,
                  color: widget.isDetection ? Colors.grey : Colors.blue),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Future<void> speak(String textToTalk) async {
    if (textToTalk.isNotEmpty) {
      await flutterTts.speak(textToTalk);
    }
  }
}
