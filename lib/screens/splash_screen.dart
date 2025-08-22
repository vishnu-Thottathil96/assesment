import 'package:flutter/material.dart';
import 'package:inovant/core/util/responsive_helper.dart';
import 'package:inovant/screens/home_page.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait 4 seconds and navigate to HomePage
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          width: double.infinity,
          child: Lottie.asset('assets/loading_animation.json',
              height: ResponsiveHelper.scaleHeight(
                context,
                150,
              ),
              fit: BoxFit.contain),
        ),
      ),
    );
  }
}
