// ignore_for_file: unnecessary_null_comparison

import 'package:dartup/b_authentication_screen/authentication_screen.dart';
import 'package:dartup/c_dashboard_screen/home_screen.dart';
import 'package:dartup/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SplashScreen extends StatefulHookConsumerWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    timerAndNav();
  }

  timerAndNav() {
    Future.delayed(
      const Duration(seconds: 1),
    ).then(
      (value) {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                user: user,
              ),
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const AuthenticationScreen(),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.subtitlecolor,
      body: SafeArea(
        child: Center(
          child: Image.asset(
            'assets/images/applogo.png',
            height: 125.h,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
