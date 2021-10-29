import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:signalator/ui/speechtotext/stthistorypage.dart';
import 'package:signalator/widget/raisedbutton.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';

class sttPage extends StatefulWidget {
  const sttPage({Key? key}) : super(key: key);

  @override
  _sttPageState createState() => _sttPageState();
}

class _sttPageState extends State<sttPage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  bool alreadyPress = false;
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
  String _text = 'Please, press the button to start the speaking!';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference sttHistory = firestore.collection("sttHistory");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Speech To Text"),
        backgroundColor: const Color(0xFF1A244C),
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
              backgroundColor: const Color(0xFF1A244C),
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
                    _text = "Please, press the button to start the speaking!";
                  });
                },
              ),
              ElevatedButton(
                style: RaisedButtonStyle,
                child: const Text("Save Text"),
                onPressed: () {
                  if (_text !=
                      "Please, press the button to start the speaking!") {
                    sttHistory.add({
                      "email": currentUser!.email,
                      "text": _text,
                      "language": "en-US",
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'You have successfully saved this text into history')));
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Save Text Problem"),
                        content: const Text(
                            "Can\'t save because it doesn\'t translate to text"),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("Ok"),
                            onPressed: () {
                              Navigator.of(context).pop("Ok");
                            },
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 5),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const sttHistoryPage()),
              );
            },
            child: const Text("See History"),
          ),
          const SizedBox(height: 10),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
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
