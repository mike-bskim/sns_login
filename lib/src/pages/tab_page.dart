import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sns_login/src/controller/tab_page_controller.dart';
import 'package:sns_login/src/pages/home_page.dart';


class TabPage extends StatefulWidget { // StatefulWidget

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {

  final TabPageController _tabPageCtrl = Get.put(TabPageController());
  List? _pages;

  @override
  void initState() {
    // 생성자 다음에 초기화 호출 부분, 변수 초기화 용도
    // TODO: implement initState
    super.initState();
    _pages = [
//      Text('Home Page'),
      HomePage(),
      Text('Study Page'),
      Text('Manage Page'),
      Text('Test Page'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    print('tabPage >> build');

    return Obx(()=> Scaffold(
      body: Center(child: _pages![_tabPageCtrl.curPage.toInt()]),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromRGBO(38, 100, 100, 1.0),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          // This is all you need!
          onTap: _tabPageCtrl.changeCurPage, //_onItemTapped,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: ('Home')),
            BottomNavigationBarItem(
                icon: Icon(Icons.edit),
                label: ('Study')),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: ('Manage')),
            BottomNavigationBarItem(
                icon: Icon(Icons.card_travel),
                label: ('Test')),
          ],
          currentIndex: _tabPageCtrl.curPage.toInt()
      ),
    ));
  }

}
