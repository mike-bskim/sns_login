//import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sns_login/src/model/login_user.dart';

class LoginUserController extends GetxController {

  static LoginUserController get to => Get.find();
  final Rx<LoginUser> _curUser = LoginUser().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    // 매 번경시마다 동작, 리엑티브 상태일때만 가능.
//    ever((_loginUser) as RxInterface<dynamic>, (_) => print("매번 호출"));
    super.onInit();
  }



  void mappingUserInfo(AsyncSnapshot snapshot) async {

    var result = await getUserInfo(snapshot.data.uid);
    if (result > 0){
      print('old customer');
    } else {
      print('new customer');
      _initUserInfo(snapshot);
      await getUserInfo(snapshot.data.uid);
    }
  }

  LoginUser get curUser => _curUser.value;

  void mappingUserType({required String userType, required String userLangType}) {
//    _curUser['userType'] = userType;
//    _curUser['userLangType'] = userLangType;
  }

  Future getUserInfo(String uid) async {
//    var result = await FirebaseFirestore.instance
//        .collection('user_info')
//        .get();
//
//    final userList = result.docs.map((user) {
//      return LoginUser.fromJson(user);
//    }).where((user) {
//      return (user.uid == uid);
//    }).toList();
//
//    if (userList.isNotEmpty) {
//      _curUser(userList.first);
//    }
//
//    return userList.length.toInt();

    var result = await FirebaseFirestore.instance
        .collection('user_info')
        .doc(uid)
        .get();

    if(result.exists) {
      final userList = LoginUser.fromJson2(result);
      _curUser(userList);
      print('>>>>' + curUser.email.toString());
      return 1;
    }
    print('>>>>' + curUser.email.toString());
    return 0;

  }

  Future _initUserInfo(AsyncSnapshot snapshot) async {
    var _userInfo = FirebaseFirestore.instance
        .collection('user_info')
        .doc(snapshot.data.uid); // post collection 만들고, 하위에 문서를 만든다 widget.user.uid

    var _date = DateTime.now();
    var _nextMonth = DateTime(_date.year, _date.month+1, _date.day).toString().split(' ');

    await _userInfo.set(
      LoginUser(
        datetime: _date.toString(),
        displayName: snapshot.data.displayName,
        email: snapshot.data.email,
        expDate: _nextMonth[0],
        uid: snapshot.data.uid,
        language: '',
        photoURL: snapshot.data.photoURL,
        providerId: snapshot.data.providerData[0].providerId,
        sUid: snapshot.data.providerData[0].uid,
        userType: '',
        validation: false,
        appVersion: '',
        lastLogin: '',
        loginCnt: 0,
      ).initToMap()
    ).then((onValue) {
    });
  }

}