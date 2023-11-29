import 'package:flutter/material.dart';

class TextFormAuth extends StatelessWidget {
  final String hinttext;
  final String labeltext;
  final IconData iconData;
  final TextEditingController? mycontroller;
  final String? Function(String?) valid;
  final bool? obscureText;
  final void Function()? onTapIcon;
  late void Function(String?)? onsaved;
  
  final maxLines;
  TextFormAuth({super.key, String? Function(String?)? onsaved ,this.maxLines, required this.hinttext, required this.labeltext, required this.iconData, this.mycontroller, required this.valid,  this.obscureText, this.onTapIcon}){
    this.onsaved = onsaved;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        validator: valid,
        onSaved: onsaved ?? (val){},
        maxLines: (maxLines == null)? 1 : maxLines,
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
                  suffixIcon: InkWell(onTap: onTapIcon, child: Icon(iconData)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
    );
  }
}