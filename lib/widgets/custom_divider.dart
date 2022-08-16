import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dartup/utils/app_constant.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.h,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstant.backgroundColor,
            AppConstant.subtitlecolor,
            AppConstant.backgroundColor,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}
