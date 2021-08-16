import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:post/sign_in/signin.dart';

import 'package:post/utils/constants.dart';

class SignUp_body extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp_body> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  GlobalKey<FormState> formKey = new GlobalKey();

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confpasswordController = new TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? email, password;
  final auth = FirebaseAuth.instance;

  bool showPassword = true;
  bool showConfirmPassword = true;

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

  void _submit() {
    final form = formKey.currentState;

    if (form!.validate()) {
      form.save();
      _register();

      // performLogin();
    }
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
        resizeToAvoidBottomInset: false,
        key: scaffoldKey,
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
                      height: 50,
                    ),
                    Text(
                      "Sign Up",
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
                                      emailInput(),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      passwordInput(),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      confirmPasswordInput(),
                                      SizedBox(
                                        height: 60,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "By clicking Sign up, you are accepting terms and privacy.",
                                            style: TextStyle(
                                              color: kPrimaryDarkColor,
                                              fontSize: 10,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 80,
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
                                        _submit();
                                        // _register();
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
                    SizedBox(
                      height: 40,
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
                            "Alredy Have an account ?",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Signin()),
                              );
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
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

  Widget confirmPasswordInput() {
    return TextFormField(
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) {},
      validator: (val) =>
          val != _passwordController.text ? 'Password Not Matched' : null,
      onSaved: (val) => password = val,
      obscureText: showConfirmPassword,
      decoration: InputDecoration(
        labelText: "Confirm Password",
        suffixIcon: IconButton(
          icon: Icon(Icons.remove_red_eye),
          onPressed: () =>
              setState(() => showConfirmPassword = !showConfirmPassword),
        ),
        labelStyle: TextStyle(fontSize: 14),
      ),
    );
  }

  void _register() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    // String confirmpassword = _confpasswordController.text.trim();

    try {
      final User? user = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      setState(() {
        if (user != null) {
          Fluttertoast.showToast(msg: "User Created Sucessfully");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Signin()),
          );
        }
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    // } else {
    //   Fluttertoast.showToast(msg: "Passwords don't match");
  }
}

// void _register() async {
//   String email = _emailController.text.trim();
//   String password = _passwordController.text.trim();
//   String confpassword = _confpasswordController.text.trim();
//   if(password == confpassword){
//
//     try {
//       final User user = ( await
//       _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       )
//       ).user;
//       setState(() {
//         isLoading = true;
//       });
//       new Future.delayed(new Duration(milliseconds: 500),(){
//         setState(() {
//           if (user != null) {
//             setState(() {
//               Navigator.pushAndRemoveUntil<dynamic>(
//                 context,
//                 MaterialPageRoute<dynamic>(
//                   builder: (BuildContext context) => home(),
//                 ),
//                     (
//                     route) => false, //if you want to disable back feature set to false
//               );
//               _success = true;
//               _userEmail = user.email;
//             });
//           } else {
//             setState(() {
//               _success = true;
//
//             });
//           }
//           isLoading = false;
//         });
//       });
//
//     }
//     catch(e){
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }
//   else{
//     Fluttertoast.showToast(msg: "Passwords do not match");
//   }
//
// }
