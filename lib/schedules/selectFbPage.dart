import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:http/http.dart' as http;
import 'package:post/sign_in/signin.dart';
import 'package:post/sign_up/signup.dart';
import 'package:post/utils/constants.dart';
import 'package:post/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SelectFbPage extends StatefulWidget {
  const SelectFbPage({Key? key}) : super(key: key);

  @override
  _SelectFbPageState createState() => _SelectFbPageState();
}

class _SelectFbPageState extends State<SelectFbPage> {
  User? user = FirebaseAuth.instance.currentUser;
  String? userId;

  var lst = [];

  CollectionReference users =
      FirebaseFirestore.instance.collection('usersProfile');
  late Query query;

  void getData() {
    Query profiles = users.where("userId", isEqualTo: user!.uid);

    profiles.snapshots().forEach((element) {
      var len = element.docs.length;
      for (int i = 0; i < len; i++) {
        lst.add(element.docs[i]['accountId']);
      }
    });
  }

  void addUser(firstName, lastName, email, userId, accountId) {
    bool account = false;
    lst.forEach((element) {
      if (element == accountId) {
        account = true;
      }
    });

    //checking the already available account
    if (account) {
      Fluttertoast.showToast(
          msg: 'Account Already Available!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white);
    } else {
      users
          .add({
            'firstName': firstName,
            'lastName': lastName,
            'email': email,
            'userId': userId,
            'boolean': "1",
            'tick': false,
            'accountId': accountId
          })
          .then((value) => Fluttertoast.showToast(
              msg: 'Account Added Successfully',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.blueGrey,
              textColor: Colors.white))
          .catchError((error) => Fluttertoast.showToast(
              msg: 'Something Went Wrong',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.blueGrey,
              textColor: Colors.white));
    }
  }

//deleting facebook profile
  void deleteProfile(docId, accountId) {
    users
        .doc(docId)
        .delete()
        .then((value) => Fluttertoast.showToast(
            msg: 'Account Deleted Successfully',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.blueGrey,
            textColor: Colors.white))
        .catchError((error) => Fluttertoast.showToast(
            msg: 'Something Went Wrong',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.blueGrey,
            textColor: Colors.white));
    lst.remove(accountId);
  }

  void addTick(String docId, String accountId, String accountName, String email,
      String userId) {
    users
        .doc(docId)
        .update({
          'accountId': accountId,
          'accountName': accountName,
          'email': email,
          'tick': true,
          'userId': userId
        })
        .then((value) => Fluttertoast.showToast(
            msg: 'Account Selected Successfully',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.blueGrey,
            textColor: Colors.white))
        .catchError((error) => Fluttertoast.showToast(
            msg: 'Something Went Wrong',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.blueGrey,
            textColor: Colors.white));
  }

  void removeTick(String docId, String accountId, String accountName,
      String email, String userId) {
    users
        .doc(docId)
        .update({
          'accountId': accountId,
          'accountName': accountName,
          'email': email,
          'tick': false,
          'userId': userId
        })
        .then((value) => print("Account Dis Selected"))
        .catchError((error) => Fluttertoast.showToast(
            msg: 'Something Went Wrong',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.blueGrey,
            textColor: Colors.white));
  }

  //defining facebook SDK
  final fbLogin = FacebookLogin();

  //facebook auth
  Future signInFB() async {
    final FacebookLoginResult result = await fbLogin.logIn(["email"]);
    final String token = result.accessToken.token;
    final response = await http.get(Uri.parse(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}'));
    final profile = jsonDecode(response.body);
    //print(profile['first_name']);
    addUser(profile['first_name'], profile['last_name'], profile['email'],
        user!.uid, profile['id']);
    return profile;
  }

  @override
  void initState() {
    Query profiles = users.where("userId", isEqualTo: user!.uid);
    query = profiles;
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: query.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot data = snapshot.data!.docs[index];
                      return InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          //print(index);
                          snapshot.data!.docs.forEach((element) =>
                              element['tick'] == true
                                  ? removeTick(
                                      element.id,
                                      element['accountId'],
                                      element['firstName'],
                                      element['email'],
                                      element['userId'])
                                  : print("no"));
                          addTick(data.id, data['accountId'], data['firstName'],
                              data['email'], data['userId']);
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              child: ProfileCard(
                                name: data['firstName'],
                                boolean: data['tick'],
                                deleteOnTap: () {
                                  deleteProfile(data.id, data['accountId']);
                                },
                                src:
                                    'https://moodforcode.com/assets/images/moodforcode.jpg',
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            FlatButton(
              onPressed: () async {
                // pushReplacement(context, Signin());
                await FirebaseAuth.instance.signOut();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove("userId");
                pushReplacement(context, Signin());
              },
              child: Text("Logout"),
            ),
            SignInButtonBuilder(
              text: "Sign in with Facebook",
              icon: Icons.facebook,
              // width: 180,
              height: 40.0,
              onPressed: () {
                signInFB();
              },
              backgroundColor: Colors.blue[700]!,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard(
      {Key? key,
      required this.src,
      required this.name,
      required this.boolean,
      required this.deleteOnTap})
      : super(key: key);

  final String src;
  final String name;
  final bool boolean;
  final VoidCallback deleteOnTap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        new Container(
          width: 50,
          padding: EdgeInsets.only(left: 10),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(55.0),
              child: FadeInImage.assetNetwork(
                  placeholderScale: 8.0,
                  imageScale: 1.0,
                  placeholder: 'assets/logo_thumbnail.jpg',
                  image: src)),
        ),
        // new Container(
        //   margin: new EdgeInsets.only(left: 2.0),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Row(
        //         children: [
        //           Text("text",
        //           style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        //           overflow: TextOverflow.ellipsis,
        //           maxLines: 1,
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
        Flexible(
          child: new Container(
            // width: 20,
            width: size.width * (16 / 20),
            padding: new EdgeInsets.all(20),
            child: new Text(
              name,
              overflow: TextOverflow.fade,
              maxLines: 1,
              softWrap: false,
              style: new TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: deleteOnTap,
            child: Text(
              "Delete",
              style: TextStyle(fontSize: 15, color: Colors.blue),
            ),
          ),
        ),
        new Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          height: 70.0,
          // width: 30.0,
          child: boolean
              ? Icon(
                  Icons.check,
                  size: 25.0,
                  color: Colors.white,
                )
              : Icon(
                  Icons.account_circle,
                  size: 25.0,
                  color: Colors.transparent,
                ),
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            gradient: boolean
                ? LinearGradient(
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
                  )
                : LinearGradient(
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                    ],
                  ),
            color: boolean ? Colors.blueAccent : Colors.transparent,
            border: new Border.all(
                width: 1.0, color: boolean ? Colors.transparent : Colors.grey),
          ),
        ),
      ],
    );
  }
}
