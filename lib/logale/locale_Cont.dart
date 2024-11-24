import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLocaleController extends GetxController {
  RxString lan = 'en'.obs;
  void changeLang(String codelang) {
    Locale locale = Locale(codelang);
    lan.value = codelang;
    Get.updateLocale(locale);
  }

  getLan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lan.value = prefs.getString('appLanguage') ?? 'en';
  }

  @override
  void onInit() {
    getLan();
    // TODO: implement onInit
    super.onInit();
  }
}
