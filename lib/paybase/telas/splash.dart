import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:layouts/paybase/const/colors.dart';
import 'package:layouts/paybase/telas/presentation.dart';

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3), () => Get.to(() => Presentation()));
    return Scaffold(
      backgroundColor: Color(corPri),
      body: Center(
        child: Text(
          "PayBase",
          style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: 'lato'),
        ),
      ),
    );
  }
}
