// ignore_for_file: unnecessary_string_escapes

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signalator/ui/signlanguagetranslator/historysigntranslator.dart';
import 'package:signalator/widget/raisedbutton.dart';
import 'package:tflite/tflite.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;

  bool isWorking = false;
  late CameraController controller;
  late List<CameraDescription> cameras;
  late CameraImage imgCamera;
  String name = '';
  String confidence = '';
  String label = '';
  String sentence = '';

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/tflite/model_unquant.tflite",
        labels: "assets/tflite/labels.txt");
  }

  @override
  void initState() {
    loadModel();
    super.initState();
    availableCameras().then((value) {
      cameras = value;
      if (cameras.isNotEmpty) {
        controller = CameraController(cameras[1], ResolutionPreset.high);
        controller.initialize().then((_) {
          if (!mounted) {
            return;
          }
          setState(() {
            controller.startImageStream((imageFromStream) {
              if (!isWorking) {
                isWorking = true;
                imgCamera = imageFromStream;
                runModelOnStreamFrames();
              }
            });
          });
        });
      } else {}
    }).catchError((e) {});
  }

  runModelOnStreamFrames() async {
    var recognitions = await Tflite.runModelOnFrame(
        bytesList: imgCamera.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: imgCamera.height,
        imageWidth: imgCamera.width,
        imageMean: 127.5,
        imageStd: 127.5,
        numResults: 1,
        threshold: 0.6,
        asynch: true);

    recognitions?.forEach((response) {
      label = response["label"];
      name = label.substring(2, label.length);
      confidence =
          ((response["confidence"] as double) * 100).toStringAsFixed(1) + " %";
    });

    if (mounted) {
      setState(() {
        //return result;
      });
    }
    isWorking = false;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Sign Language Translator'),
          backgroundColor: const Color(0xFF1A244C),
          elevation: 0.0,
        ),
        body: cameraPreview());
  }

  Widget cameraPreview() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference signHistory = firestore.collection("signHistory");
    if (controller == null || !controller.value.isInitialized) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            Text(
              'loading',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      );
    }
    return Stack(
      children: [
        Center(
          child: CameraPreview(controller),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                "Detected Letter: " + name + "\nConfidence: " + confidence,
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color(0xFF1A244C),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (name == "26 Nothing") {
                            sentence = sentence + "";
                          } else if (name == "27 Delete") {
                            if (sentence.isNotEmpty) {
                              sentence =
                                  sentence.substring(0, sentence.length - 1);
                            } else {
                              sentence = sentence + "";
                            }
                          } else if (name == "28 Space") {
                            sentence = sentence + " ";
                          } else {
                            if (sentence.isNotEmpty) {
                              sentence = sentence + name.toLowerCase();
                            } else {
                              sentence = sentence + name;
                            }
                          }
                        });
                      },
                      icon: const Icon(
                        Icons.camera,
                        size: 30,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: RaisedButtonStyle,
                    child: const Text("Save Text"),
                    onPressed: () {
                      if (sentence.isNotEmpty) {
                        signHistory.add({
                          "email": currentUser!.email,
                          "text": sentence,
                          "detail": "Saved from image detection"
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
              Card(
                color: Colors.white.withOpacity(0.7),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Formed Text:",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        sentence,
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const signHistoryPage(),
                    ),
                  );
                },
                child: const Text("See History"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
