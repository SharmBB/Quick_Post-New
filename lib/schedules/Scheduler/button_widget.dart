import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => OutlineButton(
        child: Text(
          'Select Time',
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
        borderSide: BorderSide(
          width: 1,
          color: Colors.white,
        ),
        onPressed: onClicked,
      );
}
