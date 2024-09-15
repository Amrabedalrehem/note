import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:note/signInUp/bottom.dart';
import 'package:note/signInUp/SignUp_.dart';
import 'package:note/content/Home%20Screen.dart';
import 'package:note/signInUp/textfield.dart';
import 'package:google_sign_in/google_sign_in.dart';
 import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
class homepage2 extends StatefulWidget {
  const homepage2({Key? key}) : super(key: key);

  @override
  State<homepage2> createState() => _homepage2State();
}

class _homepage2State extends State<homepage2> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> keyform = GlobalKey<FormState>();
  signInWithEmailAndPassword() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => homepage()),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          animType: AnimType.rightSlide,
          title: 'warning',
          desc: 'User not found. Please try again.',
          btnCancelOnPress: () {},
          btnOkOnPress: () {},
        )..show();
      } else if (e.code == 'wrong-password') {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          animType: AnimType.rightSlide,
          title: 'warning',
          desc: 'Wrong password. Please try again.',
          btnCancelOnPress: () {},
          btnOkOnPress: () {},
        )..show();
      } else if (e.code == 'invalid-email') {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          animType: AnimType.rightSlide,
          title: 'warning',
          desc: 'Invalid email address. Please try again.',
          btnCancelOnPress: () {},
          btnOkOnPress: () {},
        )..show();
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          animType: AnimType.rightSlide,
          title:' warning',
          desc: 'An error occurred. Please try again.',
          btnCancelOnPress: () {},
          btnOkOnPress: () {},
        )..show();
      }
    }
  }
 
// Future signInWithFacebook() async {
//   // Trigger the sign-in flow
//   final LoginResult loginResult = await FacebookAuth.instance.login();

//   // Create a credential from the access token
//   // final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

//   // Once signed in, return the UserCredential
//   await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
//        Navigator.of(context).pushAndRemoveUntil( MaterialPageRoute(builder: (context) => homepage()), (route) => false);

// }
bool loading =false;
 Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
   
    if (googleUser == null) return;
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
     loading = true;
     setState(() {
       
     });
    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushAndRemoveUntil( MaterialPageRoute(builder: (context) => homepage()), (route) => false);
    loading = false;
     setState(() {
       
     });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Form(
          key: keyform,
          child: Stack(
            children: [
              Positioned(
                  top: 60,
                  left: 50,
                  right: 50,
                  child: Column(
                    children: [
                      Center(
                          child: Lottie.network(
                              alignment: Alignment.center,
                              "https://lottie.host/5a36bc49-d7b2-4325-9ea0-bea9f828169a/c4S48K1JSs.json",
                              height: 150,
                              width: 150)),
                      const Row(
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
                  )),
              Positioned(
                  top: 300,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    height: 600,
                    width: 400,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView(children: [
                        const Text(
                          textAlign: TextAlign.center,
                          "Welcome Back",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomTextField(
                          validator: (p0) {
                            if (p0!.isEmpty) {
                              return "Please enter your email";
                            }
                              return null;
                          },
                          controller: email,
                          hintText: "Email",
                          icon: const Icon(Icons.email),
                        ),
                        CustomTextField(
                          validator: (p0) {
                            if (p0!.isEmpty) {
                              return "Please enter your password";
                            }
                         return null;  
                          },
                          controller: password,
                          hintText: "Password",
                          icon: const Icon(Icons.lock),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (email.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please Enter Your Email"),
                                ),
                              );
                              return;
                            } else  if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email.text)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please Enter Valid Email"),
                                ),
                              );
                              return;
                            } else {
                              FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: email.text);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please Check Your Email can reset password"),
                                ),
                              );
                              
                            }
                          },
                          child: const Text(
                            textAlign: TextAlign.right,
                            "Forgot Password?",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Bottom(
                          onTap: () async {
                            if (keyform.currentState!.validate()) {
                              signInWithEmailAndPassword();
                            }
                          },
                          hantname: "Sign In",
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Row(
                          children: [
                            Expanded(child: Divider()),
                            Text("Or"),
                            Expanded(child: Divider()),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {

                                signInWithGoogle();

                              },
                              child: Image.asset(
                                "image/google (2).jpg",
                                width: 40,
                                height: 40,
                              ),
                            ),
                            Image.asset(
                              "image/apple.png",
                              width: 80,
                              height: 80,
                            ),
                            GestureDetector(
                              onTap: () {
 
                              },
                              child: Image.asset(
                                "image/facebook.png",
                                width: 40,
                                height: 40,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const homepage3()),
                                      (route) => false);
                                },
                                child: const Text("Sign Up",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)))
                          ],
                        )
                      ]),
                    ),
                  )),
            ],
          ),
        ));
  }
}
