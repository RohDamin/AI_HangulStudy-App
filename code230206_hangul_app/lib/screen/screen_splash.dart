import 'dart:async';

import 'package:code230206_hangul_app/screen/screen_auth_Login.dart';
import 'package:flutter/material.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({Key? key}) : super(key: key);

  @override
  State<SpalshScreen> createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  ///addPostFrameCallback method: when flutter widget were builded, do something
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((Duration duration) {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => route == null);
      });
    });
  }

  ///set a animation and "ㅇㅇㅎㄱ" icon
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: const Image(
            image: AssetImage("assets/images/splash.png"),
            fit: BoxFit.cover,
          )),
    );
  }
}
