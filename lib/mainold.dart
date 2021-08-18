import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:post/home/home.dart';

import 'package:post/sign_in/signin.dart';
import 'package:post/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quick Post',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CheckAuth()
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
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userId = localStorage.getInt('userId');

    if (userId != null) {
      setState(() {
        isAuth = true;
        print(localStorage.getString('-------'));
        print(localStorage.getString('userId'));
        print(userId);
        print("Successfuly loggedin");
      });
    } else {
      print(localStorage.getString('-------nothong---'));
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

// class StorageSession extends StatefulWidget {
//   const StorageSession({Key? key}) : super(key: key);

//   @override
//   _StorageSessionState createState() => _StorageSessionState();
// }

// class _StorageSessionState extends State<StorageSession> with WidgetsBindingObserver {
//   Future hasFinishedOnBoarding() async {
//     var login = null;
//     if (login != null) {
//       // pushReplacement(context, Home());
//       Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => Home()),
//   );
//     } else {
//       // pushReplacement(context, Signin());
//       Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => Signin()),
//   );
//     }
//   }

//   @override
//   void initState() {

//     WidgetsBinding.instance!.addObserver(this);
//     super.initState();
//     hasFinishedOnBoarding();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         // color: Colors.white,
//         // decoration: BoxDecoration(
//         //     gradient: LinearGradient(
//         //       begin: Alignment.topLeft,
//         //       end: Alignment.bottomRight,
//         //       colors: [
//         //         Color(0xFFFFE0B2),
//         //         Color(0xFFFFEB74D),
//         //         Colors.pinkAccent,
//         //         Color(0xFFBA68C8),
//         //         Color(0xFF7E57C2),
//         //       ],
//         //     ),
//         //   ),
//       ),
//     );
//   }
// }
