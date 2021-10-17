import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signalator/ui/signlanguagedictionary/historysignlanguage.dart';
import 'package:signalator/widget/raisedbutton.dart';

class translateToSign extends StatefulWidget {
  const translateToSign({Key? key}) : super(key: key);

  @override
  _translateToSignState createState() => _translateToSignState();
}

class _translateToSignState extends State<translateToSign> {
  final TextEditingController _textEditingController = TextEditingController();
  String signShow = "";
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference signTranslatorHistory =
        firestore.collection("signTranslatorHistory");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Translate To Sign'),
        backgroundColor: const Color(0xFF1A244C),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: TextField(
                        controller: _textEditingController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Enter Text To Translate Sign",
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                          style: RaisedButtonStyle,
                          child: const Icon(
                            Icons.translate_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            bool reminder = false;
                            String checker =
                                "1234567890!@#%^&*()-=_+;:'\",<.>/?`~{[}]|";
                            for (var i = 0; i < checker.length; i++) {
                              if (_textEditingController.text
                                  .contains(checker[i])) {
                                reminder = true;
                              }
                            }
                            if (reminder) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Text Problem"),
                                  content: const Text(
                                      "Please input alphabet only for the translation text to the sign!"),
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
                            } else {
                              setState(() {
                                signShow = _textEditingController.text;
                              });
                              reminder = false;
                            }
                          }),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: signShow.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/img/sign-alphabet/s${signShow[index].toLowerCase()}.png",
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                signShow[index].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: RaisedButtonStyle,
                    child: const Text("Save Text"),
                    onPressed: () {
                      bool reminder = false;
                      String checker =
                          "1234567890!@#%^&*()-=_+;:'\",<.>/?`~{[}]| ";
                      for (var i = 0; i < checker.length; i++) {
                        if (_textEditingController.text.contains(checker[i])) {
                          reminder = true;
                        }
                      }
                      if (reminder) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Saved Text Problem"),
                            content: const Text(
                                "Please input alphabet only for saved this translation"),
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
                      } else {
                        if (_textEditingController.text.isNotEmpty) {
                          signTranslatorHistory.add({
                            "email": currentUser!.email,
                            "text": _textEditingController.text,
                            "detail": "Saved from text to sign translator"
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
                                  "Can't save because it is blank text, please enter the text!"),
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
                        reminder = false;
                      }
                    },
                  ),
                  ElevatedButton(
                    style: RaisedButtonStyle,
                    child: const Text("See History"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const signLanguageHistoryPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
