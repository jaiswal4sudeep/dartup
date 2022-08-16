// ignore_for_file: use_build_context_synchronously

import 'package:dartup/b_authentication_screen/auth_controll.dart';
import 'package:dartup/c_dashboard_screen/home_screen.dart';
import 'package:dartup/utils/app_constant.dart';
import 'package:dartup/widgets/custom_buttons.dart';
import 'package:dartup/widgets/custom_divider.dart';
import 'package:dartup/widgets/custom_textformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_button/sign_in_button.dart';

class AuthenticationScreen extends HookConsumerWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = useTextEditingController();
    final userEmail = useTextEditingController();
    final password = useTextEditingController();
    final confirmPassword = useTextEditingController();
    final isPassHidden = useState<bool>(true);
    final authKey = GlobalKey<FormState>();
    final isLoginScreen = useState<bool>(true);

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: authKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 40.h,
                  ),
                  !isLoginScreen.value
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomTextFormField(
                            controller: userName,
                            labelText: 'Name',
                            textInputType: TextInputType.name,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your name';
                              }
                              if (value.trim().length < 4) {
                                return 'Username must be at least 4 characters';
                              }
                              return null;
                            },
                          ),
                        )
                      : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextFormField(
                      controller: userEmail,
                      labelText: 'E-Mail',
                      textInputType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email address';
                        }
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextFormField(
                      controller: password,
                      labelText: 'Password',
                      textInputType: TextInputType.visiblePassword,
                      textInputAction: isLoginScreen.value
                          ? TextInputAction.done
                          : TextInputAction.next,
                      isPassword: isPassHidden.value,
                      suffixIcon: IconButton(
                        onPressed: () {
                          isPassHidden.value = !isPassHidden.value;
                        },
                        icon: isPassHidden.value
                            ? const Icon(Icons.visibility_rounded)
                            : const Icon(
                                Icons.visibility_off_rounded,
                              ),
                        color: AppConstant.subtitlecolor,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the password';
                        }
                        if (value.trim().length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                  !isLoginScreen.value
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomTextFormField(
                            controller: confirmPassword,
                            labelText: 'Confirm Password',
                            textInputAction: TextInputAction.done,
                            textInputType: TextInputType.visiblePassword,
                            isPassword: isPassHidden.value,
                            suffixIcon: IconButton(
                              onPressed: () {
                                isPassHidden.value = !isPassHidden.value;
                              },
                              icon: isPassHidden.value
                                  ? const Icon(Icons.visibility_rounded)
                                  : const Icon(
                                      Icons.visibility_off_rounded,
                                    ),
                              color: AppConstant.subtitlecolor,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }

                              if (value != password.text) {
                                return 'Password does not match';
                              }

                              return null;
                            },
                          ),
                        )
                      : const SizedBox(),
                  SizedBox(
                    height: 20.h,
                  ),
                  SizedBox(
                    width: 300.w,
                    height: 40.h,
                    child: CustomElevatedButton(
                      onPressed: () async {
                        if (authKey.currentState!.validate()) {
                          User? user = isLoginScreen.value
                              ? await Auth.loginWithEmail(
                                  userEmail.text.trim(),
                                  password.text.trim(),
                                )
                              : await Auth.createAccountWithEmail(
                                  userName.text.trim(),
                                  userEmail.text.trim(),
                                  password.text.trim(),
                                );

                          if (user != null) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                  user: user,
                                ),
                              ),
                            );
                          }
                        }
                      },
                      title: !isLoginScreen.value ? 'Sign up' : 'Log in',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          !isLoginScreen.value
                              ? 'Already have an account?'
                              : 'Don\'t have an account?',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        CustomTextButton(
                          onPressed: () {
                            isPassHidden.value = true;
                            userName.clear();
                            userEmail.clear();
                            password.clear();
                            confirmPassword.clear();
                            isLoginScreen.value = !isLoginScreen.value;
                          },
                          title: !isLoginScreen.value ? 'Log in' : 'Sign up',
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const Center(
                        child: CustomDivider(),
                      ),
                      Center(
                        child: Container(
                          color: AppConstant.backgroundColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'OR',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SignInButton(
                    Buttons.googleDark,
                    text: 'Continue with Google',
                    onPressed: () async {
                      User? user = await Auth.signInWithGoogle();
                      if (user != null) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(
                              user: user,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
