import 'package:flutter/material.dart';
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
      body: Container(
        child: Center(),
      ),
    );
  }
}
