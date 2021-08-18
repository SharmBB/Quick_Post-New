import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:post/home/home.dart';
import 'package:post/sign_in/signin.dart';
import 'package:post/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? initScreen;
Future<void> main() async {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = await preferences.getInt('initScreen');
  await preferences.setInt('initScreen', 1);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quick Post',
      theme: ThemeData(
        // fontFamily: 'ProductSans',
        primaryColor: kPrimaryColor,
        primarySwatch: Colors.blue,
      ),
      initialRoute: initScreen == 0 || initScreen == null ? 'onboard' : 'Login',
      routes: {
        'Login': (context) => CheckAuth(),
        'onboard': (context) => Signin(), // This is for future use onboard option ADDED BY SHAN!
      },
    );
  }
}

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isAuth = false;
  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() async {
    // SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userId = FirebaseAuth.instance.currentUser;

    if (userId != null) {
      setState(() {
        isAuth = true;
        print(userId);
        print("Successfuly loggedin");
      });
    } else {
      print("failed loggedin");
    }

  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isAuth) {
      child = Home();
    } else {
      child = Signin();
    }
    return Scaffold(
      body: child,
    );
  }
}