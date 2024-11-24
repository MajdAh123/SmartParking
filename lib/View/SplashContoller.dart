import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_parking/View/Dashboard/BottomBarController.dart';
import 'package:smart_parking/logale/locale_Cont.dart';

import 'Dashboard/bottom_bar.dart';

class SplashController extends GetxController {
  RxString appLanguage = "".obs;
  void loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    appLanguage.value = prefs.getString('appLanguage') ?? '';

    if (appLanguage.value != "") {
      Get.find<MyLocaleController>().changeLang(appLanguage.value);
      Future.delayed(const Duration(seconds: 3)).then((value) => Get.offAll(
          () => const BottomBarPage(),
          binding: BindingsBuilder.put(() => BottomBarController())));
    }
  }

  void changLang(String lan) {
    Get.find<MyLocaleController>().changeLang(lan);
    saveSettings(lan);
    Get.offAll(() => const BottomBarPage(),
        binding: BindingsBuilder.put(() => BottomBarController()));
  }

  void saveSettings(String lan) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('appLanguage', lan);
  }

  @override
  void onInit() {
    loadLanguage();
    // TODO: implement onInit
    super.onInit();
  }
}
