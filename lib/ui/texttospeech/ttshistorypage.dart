import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ttsHistoryPage extends StatefulWidget {
  const ttsHistoryPage({Key? key}) : super(key: key);

  @override
  _ttsHistoryPageState createState() => _ttsHistoryPageState();
}

class _ttsHistoryPageState extends State<ttsHistoryPage> {
  final FlutterTts flutterTts = FlutterTts();
  final currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference ttsHistory =
      FirebaseFirestore.instance.collection("ttsHistory");

  Future<void> _deleteHistory(String historyId) async {
    await ttsHistory.doc(historyId).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a history')));
  }

  @override
  Widget build(BuildContext context) {
    Future _speak(String text, String language) async {
      await flutterTts.setLanguage(language);
      await flutterTts.setPitch(1);
      await flutterTts.speak(text);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Text To Speech History'),
        backgroundColor: const Color(0xFF1A244C),
      ),
      body: StreamBuilder(
        stream: ttsHistory
            .where("email", isEqualTo: currentUser!.email)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['text']),
                    subtitle: Text("Language: " + documentSnapshot['language']),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                              icon: const Icon(Icons.speaker),
                              onPressed: () {
                                _speak(documentSnapshot['text'],
                                    documentSnapshot['language']);
                              }),
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _deleteHistory(documentSnapshot.id);
                              }),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
