import 'package:get/get.dart';

class TabPageController extends GetxController {

  static TabPageController get to => Get.find();
  RxInt _curPage = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
// 매 번경시마다 동작, 리엑티브 상태일때만 가능.
//    ever((_loginUser) as RxInterface<dynamic>, (_) => print("매번 호출"));
    super.onInit();
  }

  RxInt get curPage => _curPage;

  void changeCurPage(int index) {
    _curPage(index);
  }
}