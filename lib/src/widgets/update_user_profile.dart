import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sns_login/src/controller/dropdown_button_controller.dart';
import 'package:sns_login/src/controller/login_user_controller.dart';
import 'package:sns_login/src/util/image_pick_crop.dart';
import 'package:sns_login/src/widgets/common_component.dart';
import 'package:sns_login/src/widgets/input_decoration.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


// ignore: must_be_immutable
class UpdateUserProfile extends StatelessWidget {
  UpdateUserProfile({
    Key? key,
    required TextEditingController displayNameTextController,
  })  : _displayNameTextCtrl = displayNameTextController,
        super(key: key);

  final TextEditingController _displayNameTextCtrl;

  final LoginUserController _loginUserCtrl = Get.put(LoginUserController());
  final DropdownButtonController _dropdownButtonCtrl = Get.put(DropdownButtonController());
//  final GoogleSignIn _googleSignIn = GoogleSignIn();
  XFile? _image;
  var newImagePath = '';

  @override
  Widget build(BuildContext context) {

    if (kIsWeb) {
      // running on the web!
      _loginUserCtrl.changeIsMobile(false);
    } else {
      // NOT running on the web! You can check for additional platforms here.
      _loginUserCtrl.changeIsMobile(true);
    }

    _loginUserCtrl.checkDropDownMenu();
    _loginUserCtrl.changeNewPhotoURL(_loginUserCtrl.curUser.photoURL!);

//    print('update_user_profile.dart >> name: ' + _displayNameTextCtrl.text);
//    print('update_user_profile.dart >> lang: ' + _loginUserCtrl.curUser.language!);
//    print('update_user_profile.dart >> type: ' + _loginUserCtrl.curUser.userType!);
//    print('update_user_profile.dart >> photoURL: ' + _loginUserCtrl.curUser.photoURL!);
    print('UpdateUserProfile >> isMobile: ' + _loginUserCtrl.isMobile.toString());

    return AlertDialog(
//      title: Center(
//        child: Text('Edit "${_loginUserCtrl.curUser.displayName}" '),
//      ),
// https://stackoverflow.com/questions/49835623/how-to-load-images-with-image-file
      content: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Obx(()=>CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: _loginUserCtrl.curUser.photoURL! == _loginUserCtrl.newPhotoURL
                    ? NetworkImage(_loginUserCtrl.newPhotoURL)
                    : _loginUserCtrl.isMobile
                      ? FileImage(File(_loginUserCtrl.newPhotoURL)) as ImageProvider
                      : NetworkImage(_loginUserCtrl.newPhotoURL),
                    radius: 45,
                  )),
                  Container(
                    height: 100,
                    width: 100,
//                    color: Colors.amber,
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      height: 32,
                      width: 32,
                      child: FloatingActionButton(
                        onPressed: () {
                          print('click image');
                          if (_loginUserCtrl.isMobile == true) {
                            _getImage();
                          } else {
                            _getImage();
//                            imagePickerWeb();
                          }
                        },
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.camera_alt_rounded,
                          size: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _displayNameTextCtrl,
                decoration: buildInputDecoration(label: 'Your name', hintText: ''),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonLangType(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonUserType(),
            ),
//            SizedBox( height: 10,),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
              onPressed: () async {
                await _uploadImage();
                Get.back();
              },
              child: Text('Update')),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
              onPressed: () {
                Get.back();
//                Navigator.of(context).pop();
              },
              child: Text('Cancel')),
        ),
      ],
    );
  }

  Future logOutNotice(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WarningNotice(
          title: 'Warning',
          msg: 'You may need to re-login due to the information update',
          btnMsg: 'OK',
        );
      },
    );
  }


//  final _cropCtrl = CropController();
  Future _getImage() async {
    if(_loginUserCtrl.isMobile) {
      newImagePath = await ImagePickCrop.getImage();
      _loginUserCtrl.changeNewPhotoURL(newImagePath);
    } else {
      _image = await ImagePickCrop.getImage();
      _loginUserCtrl.changeNewPhotoURL(_image!.path);
    }

    print('_getImage >> newImagePath: ' + newImagePath);
    print('_getImage >> _image!.path: ' + _image!.path.toString());

  }

  Future _uploadImage() async {

    final changedName = _loginUserCtrl.curUser.displayName != _displayNameTextCtrl.text;
    final changedUserType =
        _loginUserCtrl.curUser.userType != _dropdownButtonCtrl.selectedUserTypeForDB;
    final changedLanguage =
        _loginUserCtrl.curUser.language != _dropdownButtonCtrl.selectedLangTypeForDB;
    final changedPhotoURL = _loginUserCtrl.curUser.photoURL != _loginUserCtrl.newPhotoURL;
    final userNeedUpdate = changedName || changedUserType || changedLanguage || changedPhotoURL;

//    var _picName = 'profile_pic_${DateTime.now().millisecondsSinceEpoch}.png';
    var _picName = 'profile_pic.png';

    print('_uploadImage0');
    final firebaseStorageRef = FirebaseStorage.instance;

    if (changedPhotoURL) {
      var task;
      if(_loginUserCtrl.isMobile) {
        task = await firebaseStorageRef
            .ref() // 시작점
            .child(_loginUserCtrl.curUser.uid!) // 경로, post
            .child('user_info') // 경로
            .child(_picName)
            .putFile(File(newImagePath)); // ^7.0.0
      } else {
        task = await firebaseStorageRef
            .ref() // 시작점
            .child(_loginUserCtrl.curUser.uid!) // 경로, post
            .child('user_info') // 경로
            .child(_picName)
            .putData(await _image!.readAsBytes());
      }

      // 업로드 완료되면 데이터의 주소를 얻을수 있음, future object
      var downloadUrl = await task.ref.getDownloadURL();
      print(downloadUrl);

      // old 파일을 삭제하기 위한 주소 획득
      print('_uploadImage1');
//    final ref = FirebaseStorage.instance.refFromURL(_loginUserCtrl.curUser.photoURL!) ?? null;
      print('_uploadImage2');
      // 둘다 변경해야 NetworkImage 가 실행됨. 한쪽만 변경하면 FileImage 에서 오류 발생.
      _loginUserCtrl.curUser.photoURL = downloadUrl;
      _loginUserCtrl.changeNewPhotoURL(downloadUrl);
    }


    if (userNeedUpdate) {
      print('Updating...DB');
      await _loginUserCtrl.updateUserInfo(
        displayName: _displayNameTextCtrl.text,
        language: _dropdownButtonCtrl.selectedLangTypeForDB,
        photoURL: _loginUserCtrl.newPhotoURL,
        userType: _dropdownButtonCtrl.selectedUserTypeForDB,
      );
      print('_uploadImage >> getUserInfo');
      await _loginUserCtrl.getUserInfo(_loginUserCtrl.curUser.uid!);
      _loginUserCtrl.changeWelcomeMsg();
//      if (ref != null) {
//      // old 파일을 삭제하기 위한 주소를 기반으로 old 파일 삭제.
//        await ref.delete(); //delete sub questions' pictures
//      }

    }
  }

}
