import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_parking/View/CarFunctions/BookParking/ring.dart';
import 'package:smart_parking/View/CarFunctions/Model/ReminderModel.dart';
import 'package:smart_parking/View/Dashboard/Vehicles/Models/VehicleModel.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart_parking/constant/methods.dart';
import 'package:location/location.dart' as loc;
import '../../../../constant/appcolors.dart';
import '../../../../constant/data.dart';
import '../../../../constant/keys.dart';
import '../../Model/TicketModel.dart';

class ReminderController extends GetxController {
  RxString emirate = "".obs;
  RxString zoneCode = "".obs;
  RxString reminderBefor = "".obs;
  TextEditingController zoneNumber = TextEditingController();
  TextEditingController reminderONText = TextEditingController();
  DateTime reminderMeON = DateTime.now();
  RxList<String> zoneCodesEmirate = <String>[].obs;
  Vehicle? selectedVehicle;
  loc.Location location = loc.Location();
  var alertPath = "".obs;
  RxBool vibrateWithAlert = true.obs;
  RxBool isLoading = true.obs;
  final box = GetStorage();
  static StreamSubscription<AlarmSettings>? subscription;

  List<Ticket> get tickets {
    final List<dynamic> jsonList = box.read(AppsKeys.tickets) ?? [];
    return jsonList.map((json) => Ticket.fromJson(json)).toList();
  }

  Future<void> getUserLocation() async {
    isLoading.value = true;
    await _requestLocationPermission();
    Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best)
        .timeout(Duration(seconds: 5));

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      print(placemarks[0].administrativeArea);
      if (AppData.emirates.contains(placemarks[0].administrativeArea)) {
        emirate.value = placemarks[0].administrativeArea!;
        zoneCodesEmirate.value = AppData.emirateParkingZones[emirate.value]!;
        zoneCode.value = zoneCodesEmirate.first;
      }
      // ...
    } catch (err) {
      print(err);
    }
    isLoading.value = false;
    update();
    // isLoading.value = false;
  }

  Future<void> requestPermissions() async {
    if (await Permission.phone.request().isGranted &&
        await Permission.sms.request().isGranted) {
      // Permissions granted, proceed with functionality
    } else {
      // Permissions not granted, handle accordingly
    }
  }

  Future<void> _requestLocationPermission() async {
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();

      if (!_serviceEnabled) {
        debugPrint('Location Denied once');
      } else {}
    }
    final status = await Permission.location.request();
    if (status.isGranted) {
      // Permission granted, proceed with accessing location
      print('Location permission granted');
    } else if (status.isDenied) {
      // Permission denied
      print('Location permission denied');
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, open app settings
      print('Location permission permanently denied');
      openAppSettings();
    }
  }

  List<Reminder> get reminders {
    final List<dynamic> jsonList = box.read(AppsKeys.reminder) ?? [];
    return jsonList.map((json) => Reminder.fromJson(json)).toList();
  }

  void addReminder() {
    // Ticket ticket = SlectedTikcet ??
    //     Ticket(
    //         id: 0,
    //         carId: selectedVehicle!.id,
    //         emirate: emirate.value,
    //         startTime: DateTime.now(),
    //         endTime: DateTime.now().add(Duration(
    //             hours: int.parse(AppMethods.extractNumbers(duration.value)))),
    //         duration: duration.value,
    //         cost: parkingCost.value,
    //         zoneCode: zoneCode.value,
    //         zoneNumber: zoneNumber.text);
    Reminder reminder = Reminder(
        id: 0,
        carId: selectedVehicle!.id,
        emirate: emirate.value,
        reminderMeOn: reminderMeON,
        reminderMeBefore: reminderBefor.value,
        zoneCode: zoneCode.value,
        zoneNumber: zoneNumber.text);
    final List<Reminder> existingReminders = reminders;
    reminder.id = existingReminders.length + 1;

    existingReminders.add(reminder);
    box.write(AppsKeys.reminder,
        existingReminders.map((reminder) => reminder.toJson()).toList());
    // buildAlarmSettings(ticket);
    // if (alertOnTicketEnd.isTrue) {
    Alarm.set(alarmSettings: buildAlarmSettings(reminder))
        .then((value) => print("very very good"));
    Get.back();
    zoneNumber.clear();
    reminderONText.clear();
    Get.snackbar("Done...!".tr, "Reminder has been added".tr,
        colorText: AppColors.white, backgroundColor: AppColors.fourthColor);
    // }

    print("done.............");
  }

  AlarmSettings buildAlarmSettings(Reminder reminder) {
    final alarmSettings = AlarmSettings(
      id: reminders.length,
      dateTime: reminder.reminderMeOn,
      loopAudio: false,
      vibrate: vibrateWithAlert.value,
      // volume: volume,
      assetAudioPath: alertPath.value,
      notificationTitle: 'Parking Expired'.tr,
      notificationBody:
          '${"Your Parking".tr} (${reminder.id}) ${"is Expired".tr}',
      enableNotificationOnKill: true,
    );
    return alarmSettings;
  }

  void loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Alarm.getAlarms();
    alertPath.value = prefs.getString('alertTone') ?? AppsKeys.defualtSound;

    vibrateWithAlert.value = prefs.getBool('vibrateWithAlert') ?? true;
    alertPath.value = "assets/" + alertPath.value;
  }

  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      alarmPrint('Requesting notification permission...');
      final res = await Permission.notification.request();
      alarmPrint(
        'Notification permission ${res.isGranted ? '' : 'not '}granted',
      );
    }
  }

  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    alarmPrint('Schedule exact alarm permission: $status.');
    if (status.isDenied) {
      alarmPrint('Requesting schedule exact alarm permission...');
      final res = await Permission.scheduleExactAlarm.request();
      alarmPrint(
        'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted',
      );
    }
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Get.to(
      () => ExampleAlarmRingScreen(
          alarmSettings: alarmSettings, ticket: tickets.last),
    );
    // loadAlarms();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserLocation();
    if (Alarm.android) {
      checkAndroidNotificationPermission();
      checkAndroidScheduleExactAlarmPermission();
    }
    // loadAlarms();
    // subscription ??= Alarm.ringStream.stream.listen((event) async{
    //   await Get.to(()=>ExampleAlarmRingScreen(alarmSettings: buildAlarmSettings(ticket)))
    // },);
    // subscription ??= Alarm.ringStream.stream.listen(navigateToRingScreen);

    loadSettings();
    emirate.value = AppData.emirates.first;
    zoneCodesEmirate.value = AppData.emirateParkingZones[emirate.value]!;
    zoneCode.value = zoneCodesEmirate.first;
    reminderBefor.value = AppData.remaindMeBeforOption.first;
  }
}
