import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signalator/authentication/loginscreen.dart';
import 'package:signalator/ui/profilepage/infopage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> _SignOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xFF1A244C),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            painter: HeaderCurvedContainer(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 400,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      "General",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF1A244C),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "About Us",
                                style: TextStyle(color: Colors.grey.shade900),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.info,
                                  color: Color(0xFF1A244C),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const InfoPage(),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Logged As: ${currentUser!.email}",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF1A244C),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Change Password",
                                style: TextStyle(color: Colors.grey.shade900),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.security_rounded,
                                  color: Color(0xFF1A244C),
                                ),
                                onPressed: () async {
                                  if (currentUser!.email!.isNotEmpty) {
                                    await _firebaseAuth.sendPasswordResetEmail(
                                        email: currentUser!.email!);
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text("Update Password"),
                                        content: Text(
                                            "Already sent to ${currentUser!.email} \nCheck your email"),
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
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text("Error"),
                                        content:
                                            const Text("There is an error"),
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
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Sign Out",
                                style: TextStyle(color: Colors.grey.shade900),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.exit_to_app_rounded,
                                  color: Color(0xFF1A244C),
                                ),
                                onPressed: () {
                                  _SignOut().then((value) =>
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen())));
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Account",
                  style: TextStyle(
                    fontSize: 35,
                    letterSpacing: 1.5,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 5),
                    shape: BoxShape.circle,
                    color: Colors.white,
                    image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/img/signalator.png'),
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = const Color(0xFF1A244C);
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
