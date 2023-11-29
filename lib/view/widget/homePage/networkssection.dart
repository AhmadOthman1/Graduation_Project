import 'package:flutter/material.dart';

class NetworkSection extends StatelessWidget {
  const NetworkSection({
    super.key,
    this.onPressed,
    required this.icondata,
    required this.textsection,
      
  });

  final void Function()? onPressed;
  final IconData icondata;
  final String textsection;
  // Declare a parameter for the width

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          height: 35,
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              Icon(icondata),
              const SizedBox(width: 10), // Use the sizedBoxWidth parameter
              Text(
                textsection,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const Spacer(), // Adjust this value if needed
              const Icon(Icons.arrow_forward, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}
