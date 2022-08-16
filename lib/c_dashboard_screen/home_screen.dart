import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartup/b_authentication_screen/auth_controll.dart';
import 'package:dartup/b_authentication_screen/authentication_screen.dart';
import 'package:dartup/c_dashboard_screen/drawer/bookmark_screen.dart';
import 'package:dartup/c_dashboard_screen/drawer/feedback_screen.dart';
import 'package:dartup/c_dashboard_screen/drawer/leaderboard_screen.dart';
import 'package:dartup/c_dashboard_screen/drawer/settings_screen.dart';
import 'package:dartup/models/user_model.dart';
import 'package:dartup/utils/app_constant.dart';
import 'package:dartup/widgets/custom_divider.dart';
import 'package:dartup/widgets/cutom_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({
    super.key,
    required this.user,
  });
  final User user;
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? appVersion;
  late User user;

  UserModel userModel = UserModel(
    displayName: '',
    email: '',
    level: 0,
    photoURL: '',
  );
  @override
  void initState() {
    super.initState();
    user = widget.user;
    getAppVersion();
  }

  getUserData() {
    FirebaseFirestore.instance.collection('users').doc(user.email).get().then(
      (value) {
        userModel = UserModel.fromMap(
          value.data(),
        );
        setState(() {});
      },
    );
  }

  getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: getUserData(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('DartUp'),
            centerTitle: false,
          ),
          drawer: Drawer(
            backgroundColor: AppConstant.backgroundColor,
            width: width * 0.7,
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28.r,
                          backgroundColor: AppConstant.primaryColor,
                          child: userModel.photoURL == null
                              ? Text(
                                  userModel.displayName[0].toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppConstant.backgroundColor,
                                      ),
                                )
                              : const SizedBox(),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              userModel.displayName.toString(),
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            Text(
                              'Level: ${userModel.level.toString()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
                                    color:
                                        AppConstant.titlecolor.withOpacity(0.9),
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  CustomListTile(
                    text: 'Bookmarks',
                    icon: Icons.home_rounded,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const BookmarkScreen(),
                        ),
                      );
                    },
                  ),
                  CustomListTile(
                    text: 'Leaderboard',
                    icon: Icons.leaderboard_rounded,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LeaderboardScreen(),
                        ),
                      );
                    },
                  ),
                  CustomListTile(
                    text: 'Settings',
                    icon: Icons.settings_rounded,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                  const CustomDivider(),
                  CustomListTile(
                    text: 'Share',
                    icon: Icons.share_rounded,
                    onTap: () {},
                  ),
                  CustomListTile(
                    text: 'Rate',
                    icon: Icons.star_rounded,
                    onTap: () {},
                  ),
                  CustomListTile(
                    text: 'Feedback',
                    icon: Icons.feedback_rounded,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FeedBackScreen(
                            displayName: userModel.displayName,
                            photoURL: userModel.photoURL,
                          ),
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Version: $appVersion',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Card(
                    color: AppConstant.primaryColor,
                    child: ListTile(
                      title: Text(
                        'Log out',
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: AppConstant.backgroundColor,
                            ),
                      ),
                      leading: const Icon(
                        Icons.logout_rounded,
                        color: AppConstant.backgroundColor,
                      ),
                      onTap: () {
                        Auth.signInWithGoogle()
                            .then(
                              (value) => Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AuthenticationScreen(),
                                ),
                              ),
                            )
                            .onError(
                              (error, stackTrace) => Fluttertoast.showToast(
                                msg: error.toString(),
                              ),
                            );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,
                child: Flexible(
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: ChapterIndexContainer(
                          title: 'Chapter 0',
                          onTap: () {},
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 130.h,
                        child: ChapterIndexContainer(
                          title: 'Chapter 1',
                          onTap: () {},
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 260.h,
                        child: ChapterIndexContainer(
                          title: 'Chapter 2',
                          onTap: () {},
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 390.h,
                        child: ChapterIndexContainer(
                          title: 'Chapter 3',
                          onTap: () {},
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 520.h,
                        child: ChapterIndexContainer(
                          title: 'Chapter 0',
                          onTap: () {},
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 650.h,
                        child: ChapterIndexContainer(
                          title: 'Chapter 1',
                          onTap: () {},
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 780.h,
                        child: ChapterIndexContainer(
                          title: 'Chapter 2',
                          onTap: () {},
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 910.h,
                        child: ChapterIndexContainer(
                          title: 'Chapter 3',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ChapterIndexContainer extends StatelessWidget {
  const ChapterIndexContainer({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        width: 170.w,
        height: 125.h,
        decoration: BoxDecoration(
          color: AppConstant.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline3!.copyWith(
                  color: AppConstant.backgroundColor,
                ),
          ),
        ),
      ),
    );
  }
}
