//import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sns_login/src/controller/dropdown_button_controller.dart';
import 'package:sns_login/src/model/login_user.dart';
import 'package:sns_login/src/model/multi_msg.dart';

class LoginUserController extends GetxController {

  static LoginUserController get to => Get.find();
  final DropdownButtonController _dropdownButtonCtrl = Get.put(DropdownButtonController());
  final Rx<LoginUser> _curUser = LoginUser().obs;
  RxString _welcomeMsg = ''.obs;
  RxString _newPhotoURL = ''.obs;
  RxBool _isMobile = false.obs;

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
      loginLogInfo(appVersion: '0.0.1');
    } else {
      print('new customer');
      await _initUserInfo(snapshot);
      await getUserInfo(snapshot.data.uid);
    }
    changeWelcomeMsg();
  }

  LoginUser get curUser => _curUser.value;
  String get welcomeMsg => _welcomeMsg.value;
  String get newPhotoURL => _newPhotoURL.value;
  bool get isMobile => _isMobile.value;

  void changeIsMobile (bool str) {
  _isMobile(str);
  }

  void changeNewPhotoURL (String str) {
    _newPhotoURL(str);
  }

  void changeWelcomeMsg() {
    var _multiMsg = MultiMessageHome();
    if(curUser.language != null) {
      _multiMsg.convertDescription(curUser.language);
    }
    print('changeWelcomeMsg >> curUser.language: ' + curUser.language.toString());

    var _userTypeMsg;
    if(curUser.userType == 'Teacher') {
      _userTypeMsg = _multiMsg.strTeacher;
    } else if(curUser.userType == 'Parents') {
      _userTypeMsg = _multiMsg.strParents;
    } else if(curUser.userType == 'Student') {
      _userTypeMsg = _multiMsg.strStudent;
    } else {
      _userTypeMsg = _multiMsg.strOther;
    }

    _welcomeMsg(_userTypeMsg);

  }


  void checkDropDownMenu() {

    if (curUser.language == 'Korean') {
      _dropdownButtonCtrl.langTypeIndex('한글');
      _dropdownButtonCtrl.changeLangTypeIndex('한글');
      if (curUser.userType == 'Teacher') {
        _dropdownButtonCtrl.userTypeIndex('선생님');
        _dropdownButtonCtrl.changeUserTypeIndex('선생님');
      } else {
        _dropdownButtonCtrl.userTypeIndex('학생');
        _dropdownButtonCtrl.changeUserTypeIndex('학생');
      }
    } else if (curUser.language == 'English') {
      _dropdownButtonCtrl.langTypeIndex('English');
      _dropdownButtonCtrl.changeLangTypeIndex('English');
      if (curUser.userType == 'Teacher') {
        _dropdownButtonCtrl.userTypeIndex('Teacher');
        _dropdownButtonCtrl.changeUserTypeIndex('Teacher');
      } else {
        _dropdownButtonCtrl.userTypeIndex('Student');
        _dropdownButtonCtrl.changeUserTypeIndex('Student');
      }
    } else if (curUser.language == 'Chinese') {
      _dropdownButtonCtrl.langTypeIndex('中文');
      _dropdownButtonCtrl.changeLangTypeIndex('中文');
      if (curUser.userType == 'Teacher') {
        _dropdownButtonCtrl.userTypeIndex('老师');
        _dropdownButtonCtrl.changeUserTypeIndex('老师');
      } else {
        _dropdownButtonCtrl.userTypeIndex('学生');
        _dropdownButtonCtrl.changeUserTypeIndex('学生');
      }
    } else {
      _dropdownButtonCtrl.langTypeIndex('English');
      _dropdownButtonCtrl.changeLangTypeIndex('English'); // default is student
      _dropdownButtonCtrl.userTypeIndex('Student');
      _dropdownButtonCtrl.changeUserTypeIndex('Student');
    }
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
      print('getUserInfo >> done');
//      print('getUserInfo(displayName): ' + curUser.displayName.toString());
//      print('getUserInfo(language): ' + curUser.language.toString());
//      print('getUserInfo(userType): ' + curUser.userType.toString());
//      print('getUserInfo(photoURL): ' + curUser.photoURL.toString());
      return 1;
    }
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
        displayName: snapshot.data.displayName ?? '',
        email: snapshot.data.email,
        expDate: _nextMonth[0],
        uid: snapshot.data.uid,
        language: '',
        photoURL: snapshot.data.photoURL ?? 'https://i.pravatar.cc/300',
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

  Future updateUserInfo({
    required String displayName,
    required String language,
    required String photoURL,
    required String userType,
    }) async {
    await FirebaseFirestore.instance.collection('user_info')
        .doc(curUser.uid)
        .update(
        LoginUser(
          displayName: displayName,
          language: language,
          photoURL: photoURL,
          userType: userType,
        ).profileToMap()
    );
  }


  Future loginLogInfo({required String appVersion,}) async {

    await FirebaseFirestore.instance.collection('user_info')
        .doc(curUser.uid)
        .update(
        LoginUser(
          appVersion: appVersion,
          lastLogin: DateTime.now().toString(),
          loginCnt: curUser.loginCnt! + 1,
        ).loginLogToMap()
    );
  }

}