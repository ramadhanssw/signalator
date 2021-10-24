import 'package:flutter/material.dart';
import 'package:signalator/ui/signlanguagedictionary/dictionarypage.dart';
import 'package:signalator/ui/signlanguagedictionary/historysignlanguage.dart';
import 'package:signalator/ui/signlanguagetranslator/historysigntranslator.dart';
import 'package:signalator/ui/signlanguagetranslator/signcamerapage.dart';
import 'package:signalator/ui/signlanguagetranslator/signpickerpage.dart';
import 'package:signalator/ui/signlanguagedictionary/signtranslate.dart';

class cardTranslator extends StatelessWidget {
  final String name;
  final String pictureUrl;
  final String detail;

  const cardTranslator(
      {Key? key,
      required this.name,
      required this.pictureUrl,
      required this.detail})
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
                    if (name == "Sign Languange Translator") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CameraScreen(),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const dictionaryPage(),
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
          Row(
            children: [
              ButtonBar(
                alignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      if (name == "Sign Languange Translator") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PickerScreen(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const translateToSign(),
                          ),
                        );
                      }
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.translate,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          detail,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              ButtonBar(
                alignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      if (name == "Sign Languange Translator") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const signHistoryPage(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const signLanguageHistoryPage(),
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
        ],
      ),
    );
  }
}
