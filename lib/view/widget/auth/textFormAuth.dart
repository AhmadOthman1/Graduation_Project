import 'package:flutter/material.dart';

class TextFormAuth extends StatelessWidget {
  final String hinttext;
  final String labeltext;
  final IconData iconData;
  final TextEditingController? mycontroller;
  final String? Function(String?) valid;
  final bool? obscureText;
  final void Function()? onTapIcon;
  const TextFormAuth({super.key, required this.hinttext, required this.labeltext, required this.iconData,required this.mycontroller, required this.valid,  this.obscureText, this.onTapIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        validator: valid,
        obscureText: obscureText==null  || obscureText==false ?false:true,
                decoration: InputDecoration(
                  hintText: hinttext,
                  hintStyle: const TextStyle(fontSize: 14,),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  label: Container(
                    margin:const  EdgeInsets.symmetric(horizontal: 9),
                    child: Text(labeltext)),
                  suffixIcon: InkWell(child: Icon(iconData),onTap: onTapIcon),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
    );
  }
}