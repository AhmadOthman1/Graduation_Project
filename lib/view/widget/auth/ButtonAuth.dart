import 'package:flutter/material.dart';

class ButtonAuth extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  const ButtonAuth({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(vertical: 13),
        onPressed: onPressed,
        color: const Color.fromARGB(255, 85, 191, 218),
        textColor: Colors.white,
        child: Text(text),
      ),
    );
  }
}
