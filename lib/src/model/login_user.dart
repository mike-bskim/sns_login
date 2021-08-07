import 'package:cloud_firestore/cloud_firestore.dart';

class LoginUser {
  final String? appVersion;
  final String? datetime;
  final String? email;
  final String? expDate;
  final String? uid;
  final String? language;
  final String? lastLogin;
  final int? loginCnt;
  final String? photoURL;
  final String? providerId;
  final String? sUid;
  final String? userType;
  final bool? validation;

  LoginUser(
      {
        this.appVersion,
        this.datetime,
        this.email,
        this.expDate,
        this.uid,
        this.language,
        this.lastLogin,
        this.loginCnt,
        this.photoURL,
        this.providerId,
        this.sUid,
        this.userType,
        this.validation,
      }
  );

  factory LoginUser.fromDoc(QueryDocumentSnapshot data) {
    Map<String, dynamic> info = data.data() as Map<String, dynamic>;
    return LoginUser(
      datetime: info['datetime'],
      email: info['email'],
      expDate: info['expDate'],
      uid: info['uid'],
      language: info['language'],
      photoURL: info['photoURL'],
      providerId: info['providerId'],
      sUid: info['sUid'],
      userType: info['userType'],
      validation: info['validation'],
      appVersion: info['appVersion'],
      lastLogin: info['lastLogin'],
      loginCnt: info['loginCnt'],
    );
  }


  factory LoginUser.fromJson(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    return LoginUser(
      datetime: json['datetime'],
      email: json['email'],
      expDate: json['expDate'],
      uid: json['uid'],
      language: json['language'],
      photoURL: json['photoURL'],
      providerId: json['providerId'],
      sUid: json['sUid'],
      userType: json['userType'],
      validation: json['validation'],
      appVersion: json['appVersion'],
      lastLogin: json['lastLogin'],
      loginCnt: json['loginCnt'],
    );
  }

  Map<String, dynamic> loginToMap() {
    return {
      'appVersion': appVersion,
      'lastLogin': lastLogin,
      'loginCnt': loginCnt,
    };
  }
  Map<String, dynamic> initToMap() {
    return {
      'datetime': datetime,
      'email': email,
      'expDate': expDate,
      'uid': uid,
      'language': language,
      'photoURL': photoURL,
      'providerId': providerId,
      'sUid': sUid,
      'userType': userType,
      'validation': validation,
      'appVersion': appVersion,
      'lastLogin': lastLogin,
      'loginCnt': loginCnt,
    };
  }



}
