import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_parking/View/Dashboard/BottomBarController.dart';
import 'package:smart_parking/View/Dashboard/ContactUs/contactUsPage.dart';
import 'package:smart_parking/View/Dashboard/Settings/SettingsPage.dart';
import 'package:smart_parking/View/Dashboard/Vehicles/vehiclesPage.dart';
import 'package:smart_parking/View/Dashboard/Home/home_page.dart';
import 'package:smart_parking/View/Dashboard/History/historyPage.dart';
import 'package:smart_parking/constant/appcolors.dart';
import 'package:ionicons/ionicons.dart';

class BottomBarPage extends GetView<BottomBarController> {
  const BottomBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primeryColor,
      body: Center(child: Obx(() => controller.ActiveWidget().value)

          //  _widgetOptions.elementAt(_selectedIndex),
          ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: AppColors.primeryColor,
          type: BottomNavigationBarType.fixed,
          unselectedLabelStyle: TextStyle(fontSize: 10),
          selectedLabelStyle: TextStyle(fontSize: 10),
          unselectedItemColor: AppColors.white,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Ionicons.home_outline),
              label: 'HOME'.tr.toUpperCase(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Ionicons.car_outline),
              label: 'VEHICLES'.tr.toUpperCase(),
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Ionicons.notifications_outline),
            //   // Icon(Icons.history),
            //   label: 'Notifications'.toUpperCase(),
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.messenger_outline_rounded),
              label: 'CONTACT US'.tr.toUpperCase(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Ionicons.settings_outline),
              label: 'SETTINGS'.tr.toUpperCase(),
            ),
          ],
          currentIndex: controller.selectedIndex.value,
          selectedItemColor: AppColors.theredColor,
          onTap: (index) => controller.onItemTapped(index),
        ),
      ),
    );
  }
}
