import 'package:flutter/material.dart';

class SignUporSignIn extends StatelessWidget {
  final String textOne;
  final String textTwo;
  final void Function() onTap;
  const SignUporSignIn({super.key, required this.textOne, required this.textTwo,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(textOne),
        InkWell(
          onTap: onTap,
          child:  Text(
            textTwo,
            style: const TextStyle(
                color:Color.fromARGB(255, 85, 191, 218),
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
