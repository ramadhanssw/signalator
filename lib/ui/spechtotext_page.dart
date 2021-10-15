import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:signalator/widget/raisedbutton.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';

class sttPage extends StatefulWidget {
  const sttPage({Key? key}) : super(key: key);

  @override
  _sttPageState createState() => _sttPageState();
}

class _sttPageState extends State<sttPage> {
  final Map<String, HighlightedWord> _highlights = {
    'signalator': HighlightedWord(
      onTap: () => print('signalator'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Speech To Text"),
        backgroundColor: Color(0xFF1A244C),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AvatarGlow(
            animate: _isListening,
            glowColor: Theme.of(context).primaryColor,
            endRadius: 50.0,
            duration: const Duration(milliseconds: 2000),
            repeatPauseDuration: const Duration(milliseconds: 100),
            repeat: true,
            child: FloatingActionButton(
              onPressed: _listen,
              child: Icon(_isListening ? Icons.mic : Icons.mic_none),
              backgroundColor: Color(0xFF1A244C),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: RaisedButtonStyle,
                child: const Text("Clear Text"),
                onPressed: () {
                  setState(() {
                    _text = "Press the button and start speaking";
                  });
                },
              ),
              ElevatedButton(
                style: RaisedButtonStyle,
                child: const Text("Save Text"),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 15),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            "Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%",
            style: const TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SingleChildScrollView(
            reverse: true,
            child: Container(
              padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
              child: TextHighlight(
                text: _text,
                words: _highlights,
                textStyle: const TextStyle(
                  fontSize: 25.0,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}
