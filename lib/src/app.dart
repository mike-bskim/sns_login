import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sns_login/src/controller/login_user_controller.dart';
import 'package:sns_login/src/pages/login_page.dart';

class App extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final LoginUserController _loginUserCtrl = Get.put(LoginUserController());

//    print('metadata: ' + snapshot.data.metadata.toString());
//    print('metadata: ' + snapshot.data.metadata.lastSignInTime.toString());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData) {
//            print(snapshot.data);
            print('providerData: ' + snapshot.data.providerData[0].providerId.toString());
            _loginUserCtrl.mappingUserInfo(snapshot);

            return Scaffold(
                appBar: AppBar(
                  title: Text('Login'),
                  centerTitle: true,
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.exit_to_app, color: Colors.white,),
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          _googleSignIn.signOut();
                          FacebookAuth.instance.logOut();
                        })
                  ],
                ),
                body: Center(
                  child: Obx(() =>
                  _loginUserCtrl.curUser.providerId != null
                  ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('provider ID: ${_loginUserCtrl.curUser.providerId}',
                        style: TextStyle(fontSize: 20),),
                      SizedBox(height: 20,),
                      Text('User UID: ${_loginUserCtrl.curUser.uid}', //snapshot.data.uid,
                        style: TextStyle(fontSize: 18),),
                    ],
                  )
                  : Center(child: CircularProgressIndicator()) ),
                ));
          }
          return LoginPage();
        }
      },
    );
  }
}
