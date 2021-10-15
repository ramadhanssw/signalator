import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signalator/ui/profilepage.dart';
import 'package:signalator/widget/card_translator.dart';
import 'package:signalator/widget/card_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Signalator"),
        backgroundColor: Color(0xFF1A244C),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.account_circle,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            SizedBox(height: 10),
            cardTranslator(),
            SizedBox(height: 8),
            cardWidget(
              name: "Sign Languange Dictionary",
              pictureUrl:
                  "https://images.unsplash.com/photo-1524639064490-254e0a1db723?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
            ),
            SizedBox(height: 8),
            cardWidget(
              name: "Text To Speech",
              pictureUrl:
                  "https://images.unsplash.com/photo-1580130037321-446dba3cacc2?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=726&q=80",
            ),
            SizedBox(height: 8),
            cardWidget(
              name: "Speech To Text",
              pictureUrl:
                  "https://images.unsplash.com/photo-1559223607-180d0c16c333?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1170&q=80",
            ),
          ],
        ),
      ),
    );
  }
}
