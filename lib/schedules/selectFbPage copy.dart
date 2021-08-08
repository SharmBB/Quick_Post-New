import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:post/utils/constants.dart';

class Fbpage extends StatefulWidget {
  const Fbpage({Key? key}) : super(key: key);

  @override
  _upcomingState createState() => _upcomingState();
}

class _upcomingState extends State<Fbpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(color: kPrimaryDarkColor),
        ),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 25.0, left: 25.0),
        child: Container(
          child: Column(children: [
            Center(
              child: SignInButtonBuilder(
                text: "Sign in with Facebook",
                icon: Icons.facebook,
                // width: 180,
                height: 40.0,
                onPressed: () {
                  print("object");
                },
                backgroundColor: Colors.blue[700]!,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
//  mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   FacebookSignInButton(
// //                     onPressed: _logIn,
// //                   ),
//                   Sized