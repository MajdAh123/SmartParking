import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_parking/constant/appcolors.dart';
import 'package:smart_parking/constant/data.dart';
import 'package:smart_parking/constant/keys.dart';
import 'package:smart_parking/constant/methods.dart';
import 'package:smart_parking/constant/size.dart';
import 'package:smart_parking/logale/locale_Cont.dart';
// import 'package:on_audio_query/on_audio_query.dart';
import 'Controller/SettingsController.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Color secondaryColor = Colors.grey; // Define your secondary color here
  final SettingsController settingsController = Get.put(SettingsController());
  final myLocaleController = Get.find<MyLocaleController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('emirates smart parking'.toUpperCase().tr),
        centerTitle: true,
        leading: SizedBox(),
        leadingWidth: 0,
      ),
      body: Column(
        children: [
          Text(
            "settings".tr.toUpperCase(),
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.white),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(10),
              children: [
                Obx(() => Container(
                      margin: EdgeInsets.only(bottom: 10),
                      // decoration: AppColors.containerDecoration2,
                      child: SwitchListTile(
                        inactiveTrackColor: AppColors.grey,
                        activeColor: AppColors.green,
                        thumbColor: MaterialStateColor.resolveWith(
                            (states) => AppColors.white),
                        title: Text(
                          'Parking Expiry Notification'.tr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.white),
                        ),
                        value: settingsController.alertOnTicketEnd.value,
                        onChanged: (value) {
                          settingsController.alertOnTicketEnd.value = value;
                          settingsController.saveSettings();
                        },
                      ),
                    )),
                Obx(() => Container(
                      margin: EdgeInsets.only(bottom: 10),
                      // decoration: AppColors.containerDecoration2,
                      child: SwitchListTile(
                        inactiveTrackColor: AppColors.grey,
                        activeColor: AppColors.green,
                        thumbColor: MaterialStateColor.resolveWith(
                            (states) => AppColors.white),
                        title: Text(
                          'Parking Renewal Notification'.tr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.white),
                        ),
                        value: settingsController.alertBeforeTicketEnd.value,
                        onChanged: (value) {
                          settingsController.alertBeforeTicketEnd.value = value;
                          settingsController.saveSettings();
                        },
                      ),
                    )),
                Obx(() => Container(
                      margin: EdgeInsets.only(bottom: 10),
                      // decoration: AppColors.containerDecoration2,
                      child: SwitchListTile(
                        inactiveTrackColor: AppColors.grey,
                        activeColor: AppColors.green,
                        thumbColor: MaterialStateColor.resolveWith(
                            (states) => AppColors.white),
                        title: Text(
                          'Vibrate With Notification'.tr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.white),
                        ),
                        value: settingsController.vibrateWithAlert.value,
                        onChanged: (value) {
                          if (settingsController.alertOnTicketEnd.value ||
                              settingsController.alertBeforeTicketEnd.value) {
                            settingsController.vibrateWithAlert.value = value;
                            settingsController.saveSettings();
                          }
                        },
                      ),
                    )),
                Obx(() => settingsController.alertBeforeTicketEnd.value
                    ? Container(
                        margin: EdgeInsets.only(bottom: 10),
                        // decoration: AppColors.containerDecoration2,
                        child: ListTile(
                          title: Row(
                            children: [
                              Text(
                                'Parking Renewal Before Expiry'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white),
                              ),
                              Expanded(child: SizedBox()),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                                color: AppColors.white,
                              ),
                            ],
                          ),
                          subtitle: Slider(
                            activeColor: AppColors.green,
                            inactiveColor: AppColors.grey,
                            value: settingsController.alertMinutes.value
                                .toDouble(),
                            min: 1,
                            max: 10,
                            divisions: 9,
                            label: settingsController.alertMinutes.value
                                .toString(),
                            onChanged:
                                settingsController.alertBeforeTicketEnd.value
                                    ? (value) {
                                        settingsController.alertMinutes.value =
                                            value.toInt();
                                        settingsController.saveSettings();
                                      }
                                    : null,
                          ),
                        ),
                      )
                    : SizedBox()),
                // Obx(() => Container(
                //       margin: EdgeInsets.only(bottom: 10),
                //       // decoration: AppColors.containerDecoration2,
                //       child: ListTile(
                //         onTap: () {
                //           // settingsController.pickAudioFile().then(
                //           //     (value) => settingsController.saveSettings());
                //         },
                //         title: Row(
                //           children: [
                //             Text(
                //               'Notification Sound',
                //               style: TextStyle(
                //                   fontWeight: FontWeight.bold,
                //                   color: AppColors.white),
                //             ),
                //             Expanded(child: SizedBox()),
                //             Icon(
                //               Icons.arrow_forward_ios,
                //               size: 18,
                //               color: AppColors.white,
                //             ),
                //           ],
                //         ),
                //         subtitle: Row(
                //           children: [
                //             SizedBox(
                //               width: Appsize.width(context) * 0.7,
                //               child: Text(
                //                 settingsController.alertName.value,
                //                 overflow: TextOverflow.ellipsis,
                //                 style: TextStyle(color: AppColors.white),
                //               ),
                //             ),
                //             Expanded(child: SizedBox()),
                //             IconButton(
                //                 onPressed: () => settingsController.playAudio(),
                //                 icon: Icon(
                //                   Icons.volume_up,
                //                   color: AppColors.green,
                //                 ))
                //           ],
                //         ),
                //       ),
                //     )),
                Obx(() => Container(
                      margin: EdgeInsets.only(bottom: 10),
                      // decoration: AppColors.containerDecoration2,
                      child: InkWell(
                        onTap: () async {
                          String? selectedValue = await showMenu<String>(
                            context: context,
                            position: RelativeRect.fromLTRB(
                                1000,
                                Appsize.height(context) * 0.5,
                                0,
                                100), // Adjust the position as needed
                            items: AppsKeys.allSounds
                                .map((sound) => PopupMenuItem<String>(
                                      value: sound,
                                      child: Text(
                                          AppMethods.removeAssetsPrefix(sound),
                                          style: TextStyle(
                                              color: AppColors.white)),
                                    ))
                                .toList(),
                            color: AppColors.fourthColor,
                          );
                          if (selectedValue != null) {
                            settingsController.alertPath.value = selectedValue;
                            settingsController.alertName.value =
                                AppMethods.removeAssetsPrefix(selectedValue);
                            settingsController.saveSettings();
                          }
                        },
                        child: ListTile(
                          title: Row(
                            children: [
                              Text(
                                'Notification Sound'.tr,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),
                              Expanded(child: SizedBox()),
                              SizedBox(
                                width: Appsize.width(context) * 0.3,
                                child: Text(
                                  settingsController.alertName.value,
                                  style: TextStyle(color: AppColors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: AppColors.white,
                                size: 15,
                              ),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              SizedBox(
                                width: Appsize.width(context) * 0.7,
                                child: Text(
                                  settingsController.alertName.value,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: AppColors.white),
                                ),
                              ),
                              Expanded(child: SizedBox()),
                              IconButton(
                                  onPressed: () =>
                                      settingsController.isPlayingAudio.isTrue
                                          ? settingsController.puseAudio()
                                          : settingsController.playAudio(),
                                  icon: Icon(
                                    settingsController.isPlayingAudio.isTrue
                                        ? Icons.volume_off_outlined
                                        : Icons.volume_up,
                                    color: AppColors.green,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    )),
                Obx(() => Container(
                      margin: EdgeInsets.only(bottom: 10),
                      // decoration: AppColors.containerDecoration2,
                      child: InkWell(
                        onTap: () async {
                          String? selectedValue = await showMenu<String>(
                            context: context,
                            position: RelativeRect.fromLTRB(
                                1000,
                                Appsize.height(context) * 0.65,
                                0,
                                100), // Adjust the position as needed
                            items: ['ARABIC', 'ENGLISH']
                                .map((lang) => PopupMenuItem<String>(
                                      value: lang
                                          .toString()
                                          .substring(0, 2)
                                          .toLowerCase(),
                                      child: Text(lang,
                                          style: TextStyle(
                                              color: AppColors.white)),
                                    ))
                                .toList(),
                            color: AppColors.fourthColor,
                          );
                          if (selectedValue != null) {
                            settingsController.appLanguage.value =
                                selectedValue;
                            settingsController.saveSettings();
                            myLocaleController.changeLang(selectedValue);
                            // print(selectedValue);
                          }
                        },
                        child: ListTile(
                          title: Row(
                            children: [
                              Text(
                                'Language'.tr,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),
                              Expanded(child: SizedBox()),
                              Text(
                                ['ARABIC', 'ENGLISH']
                                    .where((element) =>
                                        element.toLowerCase().substring(0, 2) ==
                                        settingsController.appLanguage.value)
                                    .toList()[0],
                                style: TextStyle(color: AppColors.white),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: AppColors.white,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
