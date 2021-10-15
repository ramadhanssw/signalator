import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:signalator/widget/audiovisualizer.dart';
import 'package:signalator/widget/raisedbutton.dart';

class ttsPage extends StatefulWidget {
  const ttsPage({Key? key}) : super(key: key);

  @override
  _ttsPageState createState() => _ttsPageState();
}

class _ttsPageState extends State<ttsPage> {
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController _textEditingController = TextEditingController();
  String dropdownValue = 'English-US';

  @override
  Widget build(BuildContext context) {
    Future _speak(String text, String language) async {
      await flutterTts.setLanguage(language);
      await flutterTts.setPitch(1);
      await flutterTts.speak(text);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Text To Speech'),
        backgroundColor: const Color(0xFF1A244C),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Ink.image(
                  image: const NetworkImage(
                      'https://images.unsplash.com/photo-1580130037321-446dba3cacc2?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=726&q=80'),
                  colorFilter:
                      const ColorFilter.mode(Colors.grey, BlendMode.modulate),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.35,
                  alignment: Alignment.center,
                ),
                Positioned.fill(
                  bottom: 25.0,
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: VisualizerColor(),
                  ),
                ),
                Positioned.fill(
                  bottom: 10.0,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      child: const Icon(Icons.speaker),
                      onPressed: () {
                        if (_textEditingController.text.isNotEmpty) {
                          String languange = "en-US";
                          if (dropdownValue == "Indonesian") {
                            languange = "id-ID";
                          } else if (dropdownValue == "English-UK") {
                            languange = "en-UK";
                          } else if (dropdownValue == "Javanese") {
                            languange = "jv-ID";
                          } else if (dropdownValue == "Sundanese") {
                            languange = "su-ID";
                          } else {
                            languange = "en-US";
                          }
                          _speak(_textEditingController.text, languange);
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Blank Text"),
                              content: const Text(
                                  "Please input the text for translate text to speech!"),
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
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(const CircleBorder()),
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(20)),
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        overlayColor:
                            MaterialStateProperty.resolveWith<Color?>((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.red;
                          }
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter Something to Speak",
                    ),
                  ),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: <String>[
                      'Indonesian',
                      'English-US',
                      'English-UK',
                      'Javanese',
                      'Sundanese',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: RaisedButtonStyle,
                        child: const Text("Save Text"),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
