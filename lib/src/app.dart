import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sns_login/src/controller/login_user_controller.dart';
import 'package:sns_login/src/pages/login_page.dart';
import 'package:sns_login/src/pages/tab_page.dart';

class App extends StatelessWidget {
  final LoginUserController _loginUserCtrl = Get.put(LoginUserController());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData) {
            print('providerData: ' + snapshot.data.providerData[0].providerId.toString());
            _loginUserCtrl.mappingUserInfo(snapshot);

            return Scaffold(
                body: TabPage(),
            );
          }
          return LoginPage();
        }
      },
    );
  }
}
