import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:post/home/home.dart';
import 'package:post/home/profile.dart';
import 'package:post/schedules/paymentPlan.dart';
import 'package:post/sign_in/forgetPassword.dart';
import 'package:post/sign_up/signup.dart';
import 'package:post/utils/constants.dart';
import 'package:post/utils/helper.dart';

class SignIn_body extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SignIn_body> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  GlobalKey<FormState> formKey = new GlobalKey();

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String? email, password;
  final auth = FirebaseAuth.instance;

  bool showPassword = true;
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
      content: new Text("Email : $email, password : $password"),
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
                  "Sign In",
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
                    autovalidate: true,
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
                                  emailInput(),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  passwordInput(),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Forget(title: "")),
                                          );
                                        },
                                        child: Text(
                                          "Forget Password?",
                                          style: TextStyle(
                                              color: kPrimaryColor,
                                              decoration:
                                                  TextDecoration.underline
                                              // fontWeight: FontWeight.bold,
                                              // fontSize: 20,
                                              ),
                                        ),
                                      )
                                    ],
                                  ),
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
                                    child: _isLoading ? CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ) : Icon(
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
                SizedBox(
                  height: 80,
                ),
                Container(
                  width: 250.0,
                  child: Row(children: <Widget>[
                    Expanded(
                        child: Divider(
                      thickness: 1.0,
                      color: Colors.white,
                    )),
                    Text(
                      "   OR   ",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                        child: Divider(
                      thickness: 1.0,
                      color: Colors.white,
                    )),
                  ]),
                ),
                SizedBox(
                  height: 40,
                ),
             
               
                Container(
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Don't Have an account ?",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Signup()),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      ),
                    ],
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

  Widget passwordInput() {
    return TextFormField(
      keyboardType: TextInputType.text,
      obscureText: showPassword,
      // validator: validatePassword,
      validator: (value) {
        RegExp regex = new RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
        if (value!.length == 0) {
          return 'Password Required';
        } else if (!regex.hasMatch(value)) {
          return 'Password Must contains \n - Minimum 1 Upper case \n - Minimum 1 lowercase \n - Minimum 1 Number \n - Minimum 1 Special Character \n - Minimum 8 letters';
        }
        return null;
      },
      onSaved: (String? val) {
        password = val;
      },
      controller: _passwordController,

      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: TextStyle(fontSize: 14),
        contentPadding: new EdgeInsets.fromLTRB(0, 20, 0, 0),
        suffixIcon: IconButton(
          icon: Icon(Icons.remove_red_eye),
          onPressed: () => setState(() => showPassword = !showPassword),
        ),
      ),
    );
  }

    onClick() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      // showProgress(context, 'Logging in, please wait...', false);
      print("Logging in");
      //await resetPassword(email.trim());
    
      User user = await _signInWithEmailAndPassword();
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString('userId', user.userID);
      // getUserAccounts(user.userID);
      // if (user != null) pushAndRemoveUntil(context, Home(), false);
    } 
    else {
      print("validate");
    }
  }

_signInWithEmailAndPassword() async {
  var errorMessage;
  User? user = FirebaseAuth.instance.currentUser;
  
  setState(() {
    _isLoading = true;
  });
  try {
    final userCredential = (await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim()
    )).user;
    if(userCredential != null ){
      if(userCredential.emailVerified == true){
        errorMessage = 'Successfully logged In!.';
        pushAndRemoveUntil(context, Home(), false);
        print(user);
      } else {
        errorMessage = 'Please verify your email!';
      }
    }
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
