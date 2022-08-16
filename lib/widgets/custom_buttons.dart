import 'package:dartup/utils/app_constant.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    Key? key,
    required this.onPressed,
    required this.title,
  }) : super(key: key);

  final void Function()? onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 1,
        primary: AppConstant.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline3!.copyWith(
                color: AppConstant.backgroundColor,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
        ),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    Key? key,
    required this.onPressed,
    required this.title,
  }) : super(key: key);

  final void Function()? onPressed;
  final String title;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        primary: AppConstant.primaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline5!.copyWith(
                color: AppConstant.primaryColor,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
        ),
      ),
    );
  }
}
