import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:note/signInUp/bottom.dart';
import 'package:note/signInUp/SignIn_.dart';

class homepage1 extends StatefulWidget {
  const homepage1({Key? key}) : super(key: key);
  @override
  State<homepage1> createState() => _homepage1State();
}

class _homepage1State extends State<homepage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Center(
                  child: Lottie.network(
                    "https://lottie.host/5a36bc49-d7b2-4325-9ea0-bea9f828169a/c4S48K1JSs.json",
                    height: 200,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Note",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.note_alt_sharp,
                      color: Colors.green,
                    )
                  ],
                )
              ],
            ),
            Bottom(
              onTap: () {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) => homepage2()),(context) => false);
              },
              hantname: "Get Started",
            ),
          ],
        ));
  }
}
