class UserModel {
  String? uid;
  String displayName = 'xxx';
  String email = 'abc';
  String? photoURL;
  int? level;

  UserModel({
    this.uid,
    required this.displayName,
    required this.email,
    this.photoURL,
    this.level,
  });

  UserModel.fromMap(map) {
    uid = map["uid"];
    displayName = map["displayName"];
    email = map["email"];
    photoURL = map["photoURL"];
    level = map["level"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "displayName": displayName,
      "email": email,
      "photoURL": photoURL,
      "level": level,
    };
  }
}
