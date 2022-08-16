// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dartup/models/user_model.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// class GetUserData extends StateNotifier<void> {
//   GetUserData() : super(null);
//   UserModel userModel = UserModel();

//   Future<UserModel> getUserData(String email) async {
//     FirebaseFirestore.instance.collection('user').doc(email).get().then(
//       (value) {
//         userModel = UserModel.fromMap(
//           value.data(),
//         );
//       },
//     );
//     return userModel;
//   }
// }

// final userDataProvider = StateNotifierProvider<GetUserData, void>((_) {
//   return GetUserData();
// });
