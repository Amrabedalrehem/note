import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:note/signInUp/bottom.dart';
import 'package:note/signInUp/SignIn_.dart';
import 'package:note/signInUp/starting.dart';
import 'package:note/signInUp/SignUp_.dart';
import 'package:note/content/Home%20Screen.dart';
import 'package:note/signInUp/textfield.dart';

class homepage3 extends StatefulWidget {
  const homepage3({Key? key}) : super(key: key);

  @override
  State<homepage3> createState() => _homepage2State();
}

class _homepage2State extends State<homepage3> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController comfirm = TextEditingController();
  GlobalKey<FormState> keyform = GlobalKey<FormState>();
  bool loading = false;
Future signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  if (googleUser != null) {
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser.authentication;

    if (googleAuth != null) {
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // ... rest of your code ...
    } else {
      // Handle the case where googleAuth is null
      print('Error: googleAuth is null');
    }
  } else {
    // Handle the case where googleUser is null
    print('Error: googleUser is null');
  }
}

  createUserWithEmailAndPassword() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
    
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => homepage2()),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.code);
    } catch (e) {
      print(e);
    }
  }

  void _showErrorDialog(String errorCode) {
    String errorMessage;
    switch (errorCode) {
      case 'weak-password':
        errorMessage = 'The password provided is too weak.';
        break;
      case 'email-already-in-use':
        errorMessage = 'The account already exists for that email.';
        break;
      default:
        errorMessage = 'An error occurred.';
        break;
    }
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.rightSlide,
      title: 'Warning',
      desc: errorMessage,
      btnCancelOnPress: () {},
      btnOkOnPress: () {},
    )..show();
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
                  top: 70,
                  left: 50,
                  right: 50,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            iconSize: 30,
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const homepage2()),
                                  (route) => false);
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                        Text(
                          textAlign: TextAlign.center,
                          "Sign In",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        Text("  ")
                      ],
                    ),
                  )),
              Positioned(
                  top: 140,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    height: 800,
                    width: 400,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView(children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          textAlign: TextAlign.center,
                          "Hello!",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          validator: (p0) {
                            if (p0!.isEmpty) {
                              return "Please enter your name";
                            }
                            return null;
                          },
                          controller: name,
                          hintText: "user Name",
                          icon: const Icon(Icons.person),
                        ),
                        // CustomTextField(
                        //   validator: (p0) {
                        //     if (p0!.isEmpty) {
                        //       return "Please enter your email";
                        //     } else if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                        //         .hasMatch(email.text)) {
                        //       AwesomeDialog(
                        //         context: context,
                        //         dialogType: DialogType.info,
                        //         animType: AnimType.rightSlide,
                        //         title: 'warning',
                        //         desc: 'Please Enter Valid Email',
                        //         btnCancelOnPress: () {},
                        //         btnOkOnPress: () {},
                        //       )..show();
                        //     } else {
                        //       FirebaseAuth.instance.currentUser!
                        //           .sendEmailVerification();
                        //       AwesomeDialog(
                        //         context: context,
                        //         dialogType: DialogType.info,
                        //         animType: AnimType.rightSlide,
                        //         title: 'warning',
                        //         desc: 'Please check your email',
                        //         btnCancelOnPress: () {},
                        //         btnOkOnPress: () {},
                        //       )..show();
                        //     }
                        //     return null;
                        //   },
                        //   controller: email,
                        //   hintText: "Email",
                        //   icon: const Icon(Icons.email),
                        // ),
                        CustomTextField(
  validator: (p0) {
    if (p0!.isEmpty) {
      return "Please enter your email";
    } else if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email.text)) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.rightSlide,
        title: 'warning',
        desc: 'Please Enter Valid Email',
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
    } else {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        user.sendEmailVerification();
        AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          animType: AnimType.rightSlide,
          title: 'warning',
          desc: 'Please check your email',
          btnCancelOnPress: () {},
          btnOkOnPress: () {},
        ).show();
      } else {
        print('No user is currently signed in.');
      }
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
                        CustomTextField(
                          validator: (p0) {
                            if (p0!.isEmpty) {
                              return "Please enter your  confirm password";
                            } else if (p0 != password.text) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.info,
                                animType: AnimType.rightSlide,
                                title: 'warning',
                                desc: ' Password does not match',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {},
                              )..show();
                            }

                            return null;
                          },
                          controller: comfirm,
                          hintText: "Confirm Password",
                          icon: const Icon(Icons.lock),
                        ),
                

                        const SizedBox(
                          height: 25,
                        ),
                        Bottom(
                          onTap: () async {
                            // createUserWithEmailAndPassword ();
                            if (keyform.currentState!.validate()) {
                              createUserWithEmailAndPassword();
                            } else {
                              print("false*******************************");
                            }
                          },
                          hantname: "Sign Up",
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
                            Image.asset(
                              "image/facebook.png",
                              width: 40,
                              height: 40,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "already have an account? ",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const homepage2()),
                                    (route) => false,
                                  );
                                },
                                child: const Text("Sign In",
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
