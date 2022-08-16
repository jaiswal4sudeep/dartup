// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dartup/screens/c_quiz_type_selection_screen.dart';
import 'package:dartup/widgets/custom_buttons.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 100.h,
            ),
            Center(
              child: Image.asset(
                'assets/images/onboarding.png',
                height: 350.h,
                fit: BoxFit.fitWidth,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: width * 0.8,
              height: 40.h,
              child: CustomElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const QuizTyepSelectionScreen(),
                    ),
                  );
                },
                title: 'GET STARTED',
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
          ],
        ),
      ),
    );
  }
}
