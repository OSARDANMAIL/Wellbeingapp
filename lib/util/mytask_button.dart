import 'package:flutter/material.dart';

class MytaskButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const MytaskButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: Colors.lightGreen,
      child: Text(text),
    ); // MaterialButton
  }
}
