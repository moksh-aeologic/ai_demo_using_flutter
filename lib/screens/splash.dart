import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../res/strings.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    afterSplash();
  }

  afterSplash() {
    Future.delayed(
      const Duration(milliseconds: 4500), 
      () => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
           Center(
        child: Lottie.asset(
          splashAsset,
          alignment: Alignment.center,
          fit: BoxFit.cover,
          height: 200,
          width: 200,
          repeat: false,  
        ),
      ),
          // Center(
          //   child: Image.asset(
          //     'assets/images/splash.png',
          //     height: 230,
          //     width: 230,
          //   ),
          // ),
          const SizedBox(height: 40),
          const Text(
            "Flutter Artificial Intelligence",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
          )
        ],
      ),
    );
  }
}
