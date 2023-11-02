import 'package:flutter/material.dart';

class BottommAppBar extends StatelessWidget {
  const BottommAppBar({
    super.key,
    required this.textbutton,
    required this.icondata,
    required this.onPressed,
     required this.active,
  });
  final bool active;
  final void Function()? onPressed;
  final String textbutton;
  final IconData icondata;
 

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icondata,
            color:active==true ? Colors.blue: Colors.black,
          ),
          Text(textbutton,style: TextStyle(color:active==true ? Colors.blue: Colors.black,),)
        ],
      ),
    );
  }
}
