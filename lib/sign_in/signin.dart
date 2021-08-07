import 'package:post/sign_in/signin_body.dart';

import 'package:flutter/material.dart';

class Signin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
          body: SignIn_body(),
        )
    );
  }
}