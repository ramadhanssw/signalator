import 'package:flutter/material.dart';
import 'package:signalator/ui/signcamerapage.dart';
import 'package:signalator/ui/signpickerpage.dart';

class cardTranslator extends StatelessWidget {
  const cardTranslator({Key? key}) : super(key: key);

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
                image: const NetworkImage(
                    "https://images.unsplash.com/photo-1502159212845-f31a19546a5d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1yZWxhdGVkfDN8fHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60"),
                colorFilter:
                    const ColorFilter.mode(Colors.grey, BlendMode.modulate),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CameraScreen(),
                      ),
                    );
                  },
                ),
                height: MediaQuery.of(context).size.height * 0.3,
                fit: BoxFit.cover,
              ),
              const Text(
                "Sign Languange Translator",
                style: TextStyle(
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PickerScreen(),
                        ),
                      );
                    },
                    child: Row(
                      children: const [
                        Icon(
                          Icons.image,
                          color: Colors.black,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Pick From Image",
                          style: TextStyle(color: Colors.black),
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
                    onPressed: () {},
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
