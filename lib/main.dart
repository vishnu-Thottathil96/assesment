import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovant/screens/home_page.dart';
import 'package:inovant/screens/influencer_list_page.dart';
import 'package:inovant/screens/restaurant_search_page.dart';
import 'package:inovant/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852), // adjust to your design
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: const Color(0xFF0A0F25), // dark night mode
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.blueGrey.withOpacity(
                0.4,
              ), // glass-like effect
              elevation: 0,
              foregroundColor: Colors.white,
              titleTextStyle: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
              toolbarTextStyle: TextStyle(fontSize: 14.sp),
              shadowColor: Colors.grey.withOpacity(0.5),
              shape: const Border(
                bottom: BorderSide(color: Colors.white24, width: 1),
              ),
            ),
          ),
          home: child,
        );
      },
      child: const SplashScreen(),
    );
  }
}
