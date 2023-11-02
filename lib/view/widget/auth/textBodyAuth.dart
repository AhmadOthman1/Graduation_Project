import 'package:flutter/material.dart';

class TextBodyAuth extends StatelessWidget {
  const TextBodyAuth({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
              margin: EdgeInsets.symmetric(horizontal: 25),
              child:  Text(
                text,
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
            );
  }
}