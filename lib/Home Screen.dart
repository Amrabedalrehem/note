import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note/signInUp/SignIn_.dart';
 
class homepage extends StatefulWidget {
  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 12, 12),
      body: Container(
        child: IconButton(onPressed: ()async{await FirebaseAuth.instance.signOut();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => homepage2()), (route) => false);
        }, icon: Icon(Icons.logout)),
      ),
    );
  }
}
