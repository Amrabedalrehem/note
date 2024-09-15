import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:note/signInUp/bottom.dart';
import 'package:note/signInUp/SignUp_.dart';
import 'package:note/content/Home%20Screen.dart';
import 'package:note/signInUp/starting.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
 void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
 class MyApp extends StatefulWidget {
 
  @override
  _MyAppState createState() => _MyAppState();
}
 class _MyAppState extends State<MyApp> {
  
  ThemeMode _themeMode = ThemeMode.system;
   @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  void _loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int themeIndex = prefs.getInt('themeMode') ?? 0;
    setState(() {
      _themeMode = ThemeMode.values[themeIndex];
    });
  }
   void _saveThemeMode(ThemeMode themeMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('themeMode', themeMode.index);
    setState(() {
      _themeMode = themeMode;
    });
  }
     getstateuser() async {
        FirebaseAuth.instance
  .userChanges()
  .listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });
     }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirebaseAuth.instance.currentUser==null?homepage1():homepage (),
    );
  }
}
