import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:post/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;

class Fbpage extends StatefulWidget {
  const Fbpage({Key? key}) : super(key: key);

  @override
  _upcomingState createState() => _upcomingState();
}

class _upcomingState extends State<Fbpage> {
  @override
  Widget build(BuildContext context) {
    
    Future<void> addUser(firstName, lastName, email, accountId) {
      CollectionReference users = FirebaseFirestore.instance.collection('usersProfile');
      return users
          .add({
            'firstName': firstName,
            'email': email,
            'lastName': lastName,
            'accountId': accountId,
            'boolean': "1"
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    final fbLogin = FacebookLogin();
    Future signInFB() async {
      final FacebookLoginResult result = await fbLogin.logIn(["email"]);
      final String token = result.accessToken.token;
      final response = await http.get(Uri.parse(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}'));
      final profile = jsonDecode(response.body);
      print(profile['first_name']);
      addUser(profile['first_name'], profile['last_name'], profile['email'],
          profile['id']);
      return profile;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profile old',
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
                  signInFB();
                  //print("object");
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