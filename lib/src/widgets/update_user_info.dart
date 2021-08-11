import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sns_login/src/controller/login_user_controller.dart';
import 'package:sns_login/src/widgets/input_decoration.dart';

class UpdateUserProfile extends StatelessWidget {
  UpdateUserProfile({
    Key? key,
    required TextEditingController displayNameTextController,
    required TextEditingController languageTextContorller,
    required TextEditingController photoURLController,
    required TextEditingController userTypeController,
  })  : _displayNameTextCtrl = displayNameTextController,
        _languageTextCtrl = languageTextContorller,
        _photoURLCtrl = photoURLController,
        _userTypeCtrl = userTypeController,
        super(key: key);

  final TextEditingController _displayNameTextCtrl;
  final TextEditingController _languageTextCtrl;
  final TextEditingController _photoURLCtrl;
  final TextEditingController _userTypeCtrl;

  final LoginUserController _loginUserCtrl = Get.put(LoginUserController());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
//      title: Center(
//        child: Text('Edit "${_loginUserCtrl.curUser.displayName}" '),
//      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(_loginUserCtrl.curUser.photoURL ?? 'https://i.pravatar.cc/300'),
                radius: 50,
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
              child: TextFormField(
                controller: _languageTextCtrl,
                decoration: buildInputDecoration(label: 'Language', hintText: ''),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _userTypeCtrl,
                decoration: buildInputDecoration(label: 'User Type', hintText: ''),
              ),
            ),
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: TextFormField(
//                controller: _photoURLCtrl,
//                decoration: buildInputDecoration(label: 'Photo URL', hintText: ''),
//              ),
//            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: () {
              final userChangedName = _loginUserCtrl.curUser.displayName != _displayNameTextCtrl.text;
              final userChangedUserType = _loginUserCtrl.curUser.userType != _userTypeCtrl.text;
              final userChangedLanguage = _loginUserCtrl.curUser.language != _languageTextCtrl.text;
              final userChangedPhotoURL = _loginUserCtrl.curUser.photoURL != _photoURLCtrl.text;

              final userNeedUpdate = userChangedName ||
                  userChangedUserType ||
                  userChangedLanguage ||
                  userChangedPhotoURL;

              if (userNeedUpdate) {
                print('Updating...');
              }
              Navigator.of(context).pop();
            },
            child: Text('Update')
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel')),
        ),
      ],
    );
  }
}