import 'package:flutter/material.dart';
import 'package:signalator/ui/speechtotext/spechtotext_page.dart';
import 'package:signalator/ui/speechtotext/stthistorypage.dart';
import 'package:signalator/ui/texttospeech/texttospeech_page.dart';
import 'package:signalator/ui/texttospeech/ttshistorypage.dart';

class cardWidget extends StatelessWidget {
  final name;
  final pictureUrl;

  const cardWidget({Key? key, required this.name, required this.pictureUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Ink.image(
                image: NetworkImage(pictureUrl),
                colorFilter:
                    const ColorFilter.mode(Colors.grey, BlendMode.modulate),
                child: InkWell(
                  onTap: () {
                    if (name == "Text To Speech") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ttsPage(),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const sttPage(),
                        ),
                      );
                    }
                  },
                ),
                height: MediaQuery.of(context).size.height * 0.3,
                fit: BoxFit.cover,
              ),
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              )
            ],
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  if (name == "Text To Speech") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ttsHistoryPage(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const sttHistoryPage(),
                      ),
                    );
                  }
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.history,
                      color: Colors.black,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "See History",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
