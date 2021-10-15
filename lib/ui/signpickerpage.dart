import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signalator/widget/raisedbutton.dart';
import 'package:tflite/tflite.dart';

class PickerScreen extends StatefulWidget {
  @override
  _PickerScreenState createState() => _PickerScreenState();
}

class _PickerScreenState extends State<PickerScreen> {
  late File pickedImage;
  bool isImageLoaded = false;
  late List result;
  String confidence = "";
  late String name;
  String detected = "";
  String sentence = "";

  getImageFromGallery() async {
    var tempStore = await ImagePicker().getImage(source: ImageSource.gallery);

    if (mounted) {
      setState(() {
        pickedImage = File(tempStore!.path);
        isImageLoaded = true;
        applyModelOnImage(File(tempStore.path));
      });
    }
  }

  applyModelOnImage(File file) async {
    var res = await Tflite.runModelOnImage(
      path: file.path,
      numResults: 2,
      threshold: 0.4,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    if (mounted) {
      setState(() {
        result = res!;
        name = result[0]["label"];
        if (name == "26 Nothing") {
          sentence = sentence + "";
          detected = "Nothing";
        } else if (name == "27 Delete") {
          detected = "Delete";
          if (sentence.isNotEmpty) {
            sentence = sentence.substring(0, sentence.length - 1);
          } else {
            sentence = sentence + "";
          }
        } else if (name == "28 Space") {
          sentence = sentence + " ";
          detected = "Space";
        } else {
          if (sentence.isNotEmpty) {
            sentence =
                sentence + name[name.length - 1].toString().toLowerCase();
          } else {
            sentence = sentence + name[name.length - 1].toString();
          }
          detected = name[name.length - 1].toString();
        }
        confidence = result != null
            ? (result[0]['confidence'] * 100.0).toString().substring(0, 2) + "%"
            : "";
      });
    }
  }

  loadMyModel() async {
    var resultant = await Tflite.loadModel(
        model: "assets/tflite/model_unquant.tflite",
        labels: "assets/tflite/labels.txt");

    print('status load model: $resultant');
  }

  @override
  void initState() {
    super.initState();
    loadMyModel();
  }

  @override
  void dispose() {
    super.dispose();
    loadMyModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Language Translator'),
        backgroundColor: const Color(0xFF1A244C),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            isImageLoaded
                ? Center(
                    child: Column(
                      children: [
                        Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(File(pickedImage.path)),
                                  fit: BoxFit.contain)),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Detected Letter: $detected",
                          style: const TextStyle(fontSize: 25.0),
                        ),
                        Text(
                          "Confidence: $confidence",
                          style: const TextStyle(fontSize: 25.0),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: RaisedButtonStyle,
                              child: const Text("Backspace"),
                              onPressed: () {
                                if (sentence.isNotEmpty) {
                                  setState(() {
                                    sentence = sentence.substring(
                                        0, sentence.length - 1);
                                  });
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Blank Text"),
                                      content: const Text(
                                          "Please insert an image to form the text!"),
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
                            const SizedBox(width: 10),
                            ElevatedButton(
                              style: RaisedButtonStyle,
                              child: const Text("Space"),
                              onPressed: () {
                                setState(() {
                                  sentence = sentence + " ";
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Formed Word: \n ",
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          sentence,
                          style: const TextStyle(fontSize: 20.0),
                        )
                      ],
                    ),
                  )
                : Center(
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/img/signalator.png",
                          height: 250,
                          width: 250,
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        const Text(
                          "Pick Image To Translate",
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: RaisedButtonStyle,
                  child: const Text("Clear Text"),
                  onPressed: () {
                    setState(() {
                      sentence = "";
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1A244C),
        onPressed: () {
          getImageFromGallery();
        },
        child: const Icon(
          Icons.photo_library_outlined,
        ),
      ),
    );
  }
}
