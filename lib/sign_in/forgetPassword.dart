import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:post/sign_in/signin.dart';

import 'package:post/utils/constants.dart';
import 'package:post/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Forget extends StatefulWidget {
  Forget({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _ForgetState createState() => _ForgetState();
}

class _ForgetState extends State<Forget> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  GlobalKey<FormState> formKey = new GlobalKey();

  TextEditingController _emailController = new TextEditingController();

  String? email;
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void performLogin() {
    final snackbar = new SnackBar(
      content: new Text("Email : $email"),
    );
    scaffoldKey.currentState!.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFE0B2),
            Color(0xFFFFEB74D),
            Colors.pinkAccent,
            Color(0xFFBA68C8),
            Color(0xFF7E57C2),
          ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Stack(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 70,
                ),
                Text(
                  "Forget your password",
                  style: TextStyle(
                    color: kPrimaryLightColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: Offset(0, 3),
                                  )
                                ],
                              ),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Enter your email",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  emailInput(),
                                  SizedBox(
                                    height: 100,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: -35,
                          right: 0,
                          left: 0,
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FlatButton(
                                  onPressed: () async {
                                      await onClick();
                                    },
                                  textColor: Colors.white,
                                  padding: const EdgeInsets.all(0.0),
                                  shape: CircleBorder(
                                    side: BorderSide(
                                        color: Colors.white,
                                        width: 5,
                                        style: BorderStyle.solid),
                                  ),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100.0)),
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomRight,
                                        end: Alignment.topLeft,
                                        // stops: [0.3, 0.3, 0.7, 0.1, 1],
                                        colors: [
                                          Color(0xFFFFE0B2),
                                          Color(0xFFFFB74D),
                                          Color(0xFFE040FB),
                                          Color(0xFFBA68C8),
                                          Color(0xFF7E57C2),
                                        ],
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(15.0),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      size: 35.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      overflow: Overflow.visible,
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    ));
  }

  Widget emailInput() {
    RegExp regex = new RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return TextFormField(
      decoration: new InputDecoration(
        labelText: "Email",
        hintText: "e.g abc@gmail.com",
        labelStyle: TextStyle(fontSize: 14),
      ),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.length == 0) {
          return 'Email Required';
        } else if (!regex.hasMatch(value)) {
          return 'Enter Valid Email';
        } else {
          return null;
        }
      },
      onSaved: (String? val) {
        email = val;
      },
      controller: _emailController,
    );
  }

      onClick() async {
    if (formKey.currentState!.validate()) {
      // formKey.currentState!.save();
      // showProgress(context, 'Logging in, please wait...', false);
      print("Logging in");
      //await resetPassword(email.trim());
    
      await _signInWithEmailAndPassword();
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString('userId', user.uid);
      // print(prefs.setString('userId', user.uid));
      // getUserAccounts(user.userID);
      // if (user != null) pushAndRemoveUntil(context, Home(), false);
    } 
    else {
      print("validate");
    }
  }

  _signInWithEmailAndPassword() async {
  var errorMessage;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  setState(() {
    _isLoading = true;
  });
  try {
    // final userCredential = (await FirebaseAuth.instance.signInWithEmailAndPassword(
    //   email: _emailController.text.trim(),
    // )).user;
    // if(userCredential != null ){
    //   if(userCredential.emailVerified == true){
    //     User? user = FirebaseAuth.instance.currentUser;
    //     errorMessage = 'Successfully logged In!.';
    //     prefs.setString('userId', user!.uid);
    //     pushAndRemoveUntil(context, Home(), false);
    //     // print(user!.uid);
    //   } else {
    //     errorMessage = 'Please verify your email!';
    //   }
    // }
    await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
    errorMessage = 'Email sended successfully';
    pushAndRemoveUntil(context, Signin(), false);

  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      errorMessage = 'No user found for that email.';
    } else if (e.code == 'wrong-password') {
      errorMessage = 'Wrong password provided for that user.';
    } else if (e.code == 'email-already-in-use') {
      errorMessage = 'Email already used.';
    } else if (e.code == 'account-exists-with-different-credential') {
      errorMessage = 'Email already used.';
    } else if (e.code == 'user-disabled') {
      errorMessage = 'User disabled.';
    } else if (e.code == 'operation-not-allowed') {
      errorMessage = 'Too many requests to log into this account.';
    } else if (e.code == 'invalid-email') {
      errorMessage = 'Email address is invalid.';
    } else {
      errorMessage = 'Login failed. Please try again.';
    }
    // toastMessage(errorMessage);
  }
  toastMessage(errorMessage);
  setState(() {
      _isLoading = false;
    });
}

void toastMessage(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      fontSize: 16.0);
  print(message);
}

  
}
