import 'package:dartup/utils/app_constant.dart';
import 'package:dartup/widgets/custom_back_button.dart';
import 'package:dartup/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FeedBackScreen extends ConsumerStatefulWidget {
  const FeedBackScreen({
    Key? key,
    this.photoURL,
    this.displayName,
  }) : super(key: key);

  final String? photoURL;
  final String? displayName;

  @override
  ConsumerState<FeedBackScreen> createState() => _FeedBackScreenState();
}

class _FeedBackScreenState extends ConsumerState<FeedBackScreen> {
  int selectedTitleId = 0;
  final key = GlobalKey<FormState>();
  TextEditingController feedbackMessage = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
        leading: const CustomBackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              color: AppConstant.backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: key,
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          radius: 20.r,
                          child: widget.photoURL != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(widget.photoURL!),
                                )
                              : null,
                        ),
                        title: Text(
                          widget.displayName!,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ActionChip(
                                backgroundColor: selectedTitleId == 1
                                    ? AppConstant.primaryColor
                                    : AppConstant.subtitlecolor,
                                onPressed: () {
                                  setState(() {
                                    selectedTitleId != 1
                                        ? (selectedTitleId = 1)
                                        : (selectedTitleId = 0);
                                  });
                                },
                                label: Text(
                                  'General Feedback',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                        color: selectedTitleId != 1
                                            ? AppConstant.titlecolor
                                            : AppConstant.backgroundColor,
                                      ),
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              ActionChip(
                                backgroundColor: selectedTitleId == 2
                                    ? AppConstant.primaryColor
                                    : Colors.grey[800],
                                onPressed: () {
                                  setState(() {
                                    selectedTitleId != 2
                                        ? (selectedTitleId = 2)
                                        : (selectedTitleId = 0);
                                  });
                                },
                                label: Text(
                                  'Bug Report',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                        color: selectedTitleId != 2
                                            ? AppConstant.titlecolor
                                            : AppConstant.backgroundColor,
                                      ),
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              ActionChip(
                                backgroundColor: selectedTitleId == 3
                                    ? AppConstant.primaryColor
                                    : Colors.grey[800],
                                onPressed: () {
                                  setState(() {
                                    selectedTitleId != 3
                                        ? (selectedTitleId = 3)
                                        : (selectedTitleId = 0);
                                  });
                                },
                                label: Text(
                                  'Suggestion',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                        color: selectedTitleId != 3
                                            ? AppConstant.titlecolor
                                            : AppConstant.backgroundColor,
                                      ),
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              ActionChip(
                                backgroundColor: selectedTitleId == 4
                                    ? AppConstant.primaryColor
                                    : Colors.grey[800],
                                onPressed: () {
                                  setState(() {
                                    selectedTitleId != 4
                                        ? (selectedTitleId = 4)
                                        : (selectedTitleId = 0);
                                  });
                                },
                                label: Text(
                                  'Other',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                        color: selectedTitleId != 4
                                            ? AppConstant.titlecolor
                                            : AppConstant.backgroundColor,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 12.0,
                        ),
                        child: TextFormField(
                          controller: feedbackMessage,
                          autofocus: false,
                          cursorColor: AppConstant.primaryColor,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          minLines: 5,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Please provide your feedback here.',
                            hintStyle: Theme.of(context).textTheme.subtitle1,
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppConstant.primaryColor,
                                width: 1,
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppConstant.primaryColor,
                                width: 1,
                              ),
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppConstant.primaryColor,
                                width: 1,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Message cannot be empty";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      SizedBox(
                        height: 30.h,
                        child: CustomElevatedButton(
                          onPressed: () {
                            if ((selectedTitleId == 0 &&
                                    !key.currentState!.validate()) ||
                                (selectedTitleId == 0 &&
                                    key.currentState!.validate())) {
                              Fluttertoast.showToast(
                                msg: 'Please select feedback type',
                              );
                            }
                            if (key.currentState!.validate() &&
                                selectedTitleId != 0) {
                              Fluttertoast.showToast(
                                msg: 'Feedback sent successfully',
                              );

                              setState(() {
                                feedbackMessage.clear();
                                selectedTitleId = 0;
                              });
                            }
                          },
                          title: 'SEND',
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
