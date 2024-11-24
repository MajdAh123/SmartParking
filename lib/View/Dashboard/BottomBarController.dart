import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'ContactUs/contactUsPage.dart';
import 'Home/home_page.dart';
import 'Settings/SettingsPage.dart';
import 'Vehicles/vehiclesPage.dart';

class BottomBarController extends GetxController {
  RxInt selectedIndex = 0.obs;

  List<Widget> widgetOptions = <Widget>[
    HomePage(),
    VehiclesPage(),
    // SizedBox(),
    ContactUsPage(),
    SettingsPage(),
  ];

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }

  Rx<Widget> ActiveWidget() => widgetOptions.elementAt(selectedIndex.value).obs;
}
