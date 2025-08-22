import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovant/core/constants/app_colors.dart';
import 'package:inovant/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: AppColors.background,
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.appBarBackground,
              elevation: 0,
              foregroundColor: AppColors.headingText,
              titleTextStyle: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
              toolbarTextStyle: TextStyle(fontSize: 14.sp),
              shadowColor: AppColors.paymentShadow,
              shape: const Border(
                bottom:
                    BorderSide(color: AppColors.glassAppBarBorder, width: 1),
              ),
            ),
          ),

          // Override system text scaling
          builder: (context, widget) {
            final mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              data:
                  mediaQuery.copyWith(textScaler: const TextScaler.linear(1.0)),
              child: widget!,
            );
          },

          home: child,
        );
      },
      child: const SplashScreen(),
    );
  }
}
