// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_typing_uninitialized_variables, unused_local_variable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dartup/utils/app_constant.dart';
import 'package:dartup/widgets/custom_divider.dart';

class CheckAnswerScreen extends StatelessWidget {
  const CheckAnswerScreen({
    super.key,
    required this.selectedOptionsList,
    required this.timeTakenByUser,
    required this.scriptFile,
  });

  final List<int> selectedOptionsList;
  final List<int> timeTakenByUser;
  final String scriptFile;

  @override
  Widget build(BuildContext context) {
    var quizData;
    Future<void> getQuizData() async {
      var gotData = await DefaultAssetBundle.of(context).loadString(scriptFile);
      quizData = json.decode(gotData.toString());
      return quizData;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.keyboard_arrow_left_rounded,
          ),
        ),
      ),
      body: FutureBuilder(
        future: getQuizData(),
        builder: (context, snapshot) {
          var data = quizData;
          if (data == null) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppConstant.primaryColor,
              ),
            );
          } else {
            return ListView.separated(
              separatorBuilder: (context, index) {
                return const Center(
                  child: CustomDivider(),
                );
              },
              physics: const BouncingScrollPhysics(),
              itemCount: data['questions'].length,
              itemBuilder: (context, index) {
                return QuestionWidget(
                  data: data,
                  qid: index,
                  selectedOptionsList: selectedOptionsList,
                  timeTakenByUser: timeTakenByUser,
                );
              },
            );
          }
        },
      ),
    );
  }
}

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({
    Key? key,
    required this.data,
    required this.qid,
    required this.selectedOptionsList,
    required this.timeTakenByUser,
  }) : super(key: key);

  final data;
  final int qid;
  final List<int> selectedOptionsList;
  final List<int> timeTakenByUser;

  @override
  Widget build(BuildContext context) {
    var id = qid + 1;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                id.toString() + ') ' + data['questions'][qid]['question'],
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: data['questions'][qid]['options'].length,
              itemBuilder: (context, index) {
                var text = '\u2022 ' + data['questions'][qid]['options'][index];
                bool isTrue =
                    data['questions'][qid]['correct_answer'] == index + 1
                        ? true
                        : false;
                bool isSelectedByUser =
                    selectedOptionsList[qid] == index + 1 ? true : false;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          text,
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(
                                fontSize: isTrue ? 13.sp : 12.sp,
                                fontWeight:
                                    isTrue ? FontWeight.w700 : FontWeight.w500,
                              ),
                        ),
                      ),
                      Icon(
                        isSelectedByUser
                            ? (isTrue
                                ? Icons.check_rounded
                                : Icons.clear_rounded)
                            : (isTrue ? Icons.check_rounded : null),
                      ),
                    ],
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 15.w,
                ),
                Text(
                  selectedOptionsList[qid] != 0
                      ? (data['questions'][qid]['correct_answer'] ==
                              selectedOptionsList[qid]
                          ? 'Correct'
                          : 'Incorrect')
                      : 'Skipped',
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                        color: AppConstant.titlecolor.withOpacity(0.8),
                      ),
                ),
                const Spacer(),
                Icon(
                  Icons.hourglass_top_rounded,
                  size: 18.sp,
                ),
                SizedBox(
                  width: 3.w,
                ),
                Text(
                  timeTakenByUser[qid].toString() + 's',
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        fontSize: 14.sp,
                      ),
                ),
                SizedBox(
                  width: 3.w,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
