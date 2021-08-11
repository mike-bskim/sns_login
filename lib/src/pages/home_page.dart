import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sns_login/src/controller/login_user_controller.dart';
import 'package:sns_login/src/widgets/update_user_info.dart';

// stless
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final LoginUserController _loginUserCtrl = Get.put(LoginUserController());

  late TextEditingController _displayNameTextCtrl;
  late TextEditingController _languageTextCtrl;
  late TextEditingController _photoURLCtrl;
  late TextEditingController _userTypeCtrl;

//  var _multiMsg;
//  var _userTypeMsg;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _displayNameTextCtrl = TextEditingController(text: _loginUserCtrl.curUser.displayName);
    _languageTextCtrl = TextEditingController(text: _loginUserCtrl.curUser.language);
    _photoURLCtrl = TextEditingController(text: _loginUserCtrl.curUser.photoURL);
    _userTypeCtrl = TextEditingController(text: _loginUserCtrl.curUser.userType);
  }

  @override
  Widget build(BuildContext context) {
    print(_displayNameTextCtrl.text);
    print(_languageTextCtrl.text);
    print(_photoURLCtrl.text);
    print(_userTypeCtrl.text);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(38, 100, 100, 1.0),
        title: Text(
          'Version 0.2.9',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                _googleSignIn.signOut();
                FacebookAuth.instance.logOut();
              })
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
//      color: Colors.amber,
      padding: EdgeInsets.all(24.0),
      child: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to Play',
                    style:
                        TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    child: Icon(
                      Icons.local_library,
                      size: 25,
                      color: Colors.black38,
                    ),
                  ),
                  Text(
                    'Study',
                    style:
                        TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.all(8.0)),
//                  Text(_userTypeMsg),
              Padding(padding: EdgeInsets.all(16.0)),
              SizedBox(
                width: 260.0,
                child: Card(
                  elevation: 5.0,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Obx(
                      () => Column(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.all(8.0)),
                          SizedBox(
                            width: 80.0,
                            height: 80.0,
                            child: InkWell(
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    _loginUserCtrl.curUser.photoURL ?? 'https://i.pravatar.cc/300'),
                              ),
                              onTap: () {
                                print('edit profile');
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    print('createProfileDialog');
                                    return UpdateUserProfile(
                                      displayNameTextController: _displayNameTextCtrl,
                                      languageTextContorller: _languageTextCtrl,
                                      photoURLController: _photoURLCtrl,
                                      userTypeController: _userTypeCtrl,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(8.0)),
                          Text(
                            _loginUserCtrl.curUser.email ?? ' ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(_loginUserCtrl.curUser.displayName ?? ' '),
                          Padding(padding: EdgeInsets.all(8.0)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
//                ElevatedButton(
//                    onPressed: () {
//                      _loginUserCtrl.userInfo['displayName'] = 'aa';
//                      print('변경후 이름: ' + _loginUserCtrl.userInfo['displayName'].toString());
//                      },
//                    child: Text('이름변경'),
//                ),
            ],
          ),
        ),
      )),
    );
  }
}
