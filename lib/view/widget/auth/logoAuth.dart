import 'package:flutter/material.dart';
import 'package:growify/core/constant/imagesAssets.dart';

class LogoAuth extends StatelessWidget {
  const LogoAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(ImageAsset.logo,height: 250,);
  }
}