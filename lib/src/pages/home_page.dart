import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sns_login/src/controller/login_user_controller.dart';
import 'package:sns_login/src/widgets/update_user_profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final LoginUserController _loginUserCtrl = Get.put(LoginUserController());

  TextEditingController? displayNameTextCtrl ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    displayNameTextCtrl = TextEditingController(text: _loginUserCtrl.curUser.displayName);
    print('home page >> initState: ' + displayNameTextCtrl!.text);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
//    displayNameTextCtrl?.dispose();
  }

  @override
  Widget build(BuildContext context) {

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
    print('home page >> build');

    return Container(
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
                Obx(()=>Text(_loginUserCtrl.welcomeMsg)),
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
                            Container(
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      backgroundImage: NetworkImage(_loginUserCtrl.curUser.photoURL ??
                                          'https://i.pravatar.cc/300'),
                                    ),
                                  ),
                                  Container(
                                    height: 80,
                                    width: 80,
                                    alignment: Alignment.bottomRight,
                                    child: SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: FloatingActionButton(
                                        onPressed: () {
                                          displayNameTextCtrl = TextEditingController(
                                              text: _loginUserCtrl.curUser.displayName);
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              print('createProfileDialog');
                                              return UpdateUserProfile(
                                                displayNameTextController: displayNameTextCtrl!,
                                              );
                                            },
                                          );
                                        },
                                        elevation: 8,
                                        backgroundColor: Colors.white,
                                        child: Icon(Icons.edit, size: 14, color: Colors.black,),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(8.0)),
                            Text(
                              _loginUserCtrl.curUser.email ?? ' ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Padding(padding: EdgeInsets.all(4.0)),
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
        )
      ),
    );
  }
}
