import 'package:flutter/material.dart';

class TextTitleAuth extends StatelessWidget {
  const TextTitleAuth({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return    Text(
              text,
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center,
            );
  }
}