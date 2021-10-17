import 'package:flutter/material.dart';

class signHistoryTranslator extends StatelessWidget {
  final String signText;
  const signHistoryTranslator({Key? key, required this.signText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text To Sign in History'),
        backgroundColor: const Color(0xFF1A244C),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: signText.length,
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
                      "assets/img/sign-alphabet/s${signText[index]}.png",
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      signText[index].toUpperCase(),
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
    );
  }
}
