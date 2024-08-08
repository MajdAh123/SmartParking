import 'dart:async';
import 'dart:io';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_parking/View/CarFunctions/BookParking/ring.dart';
import 'package:smart_parking/View/CarFunctions/Model/TicketModel.dart';
import 'package:smart_parking/View/Dashboard/Home/Controllers/home_page_Controller.dart';
import 'package:smart_parking/View/Dashboard/Vehicles/Models/VehicleModel.dart';
import 'package:smart_parking/constant/data.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart_parking/constant/methods.dart';
import 'package:location/location.dart' as loc;
import 'package:alarm/alarm.dart';
import '../../../../constant/appcolors.dart';
import '../../../../constant/keys.dart';
import '../../Model/SIMmodel.dart';

class BookParkingController extends GetxController {
  RxString emirate = "".obs;
  RxString zoneCode = "".obs;
  RxString duration = "".obs;
  RxDouble parkingCost = 1.0.obs;
  RxDouble fixedCost = 2.38.obs;
  RxString smsStatus = "".obs;
  TextEditingController zoneNumber = TextEditingController();
  RxList<String> zoneCodesEmirate = <String>[].obs;
  RxList<SIMCard> simCards = <SIMCard>[].obs;
  RxInt selectedSimSlot = 5.obs;
  RxBool isloading = true.obs;
  loc.Location location = loc.Location();
  static const platform = MethodChannel('smsChannel');
  static const smsDeliveryChannel = EventChannel('smsDeliveryChannel');
  Vehicle? selectedVehicle;
  RxList<Ticket> myTickets = <Ticket>[].obs;
  final box = GetStorage();
  RxBool isListening = true.obs;
  RxBool vibrateWithAlert = true.obs;
  var alertOnTicketEnd = true.obs;
  var alertBeforeTicketEnd = true.obs;
  var alertMinutes = 5.obs;
  var alertPath = "".obs;
  RxInt newDurationTikcet = 1.obs;
  static StreamSubscription<AlarmSettings>? subscription;
  List<Ticket> get tickets {
    final List<dynamic> jsonList = box.read(AppsKeys.tickets) ?? [];
    return jsonList.map((json) => Ticket.fromJson(json)).toList();
  }

  List<Vehicle> get vehicles {
    final List<dynamic> jsonList = box.read(AppsKeys.vehicles) ?? [];
    return jsonList.map((json) => Vehicle.fromJson(json)).toList();
  }

  Ticket? SlectedTikcet;
  void addTicket() {
    Ticket ticket = SlectedTikcet ??
        Ticket(
            id: 0,
            carId: selectedVehicle!.id,
            emirate: emirate.value,
            startTime: DateTime.now(),
            endTime: DateTime.now().add(Duration(
                hours: int.parse(AppMethods.extractNumbers(duration.value)))),
            duration: duration.value,
            cost: parkingCost.value,
            zoneCode: zoneCode.value,
            zoneNumber: zoneNumber.text);
    final List<Ticket> existingTickets = tickets;
    ticket.id = existingTickets.length + 1;

    existingTickets.add(ticket);
    box.write(AppsKeys.tickets,
        existingTickets.map((ticket) => ticket.toJson()).toList());
    // buildAlarmSettings(ticket);
    if (alertOnTicketEnd.isTrue) {
      Alarm.set(alarmSettings: buildAlarmSettings(ticket))
          .then((value) => print("very very good"));
      HomePageController home = Get.find();
      home.getTicktesValues();
      home.getActiveTickets();
      home.getRecentTickets();
      home.update();
      Get.back();
      zoneNumber.clear();
      Get.snackbar("Done...!".tr, "Parking has been booked".tr,
          colorText: AppColors.white, backgroundColor: AppColors.fourthColor);
    }

    print("done.............");
  }

  void updateTicket(Ticket updatedTicket) {
    final List<Ticket> existingTickets = tickets;
    final index =
        existingTickets.indexWhere((vehicle) => vehicle.id == updatedTicket.id);

    if (index != -1) {
      existingTickets[index] = updatedTicket;
      box.write(AppsKeys.vehicles,
          existingTickets.map((vehicle) => vehicle.toJson()).toList());
    }
    print(index);
    HomePageController home = Get.find();
    home.getTicktesValues();
    home.getActiveTickets();
    home.getRecentTickets();
    home.update();
    // updateMyVehicles();
  }

  updateMyTickets() {
    myTickets.value = tickets;
    update();
  }

  AlarmSettings buildAlarmSettings(Ticket ticket) {
    final alarmSettings = AlarmSettings(
      id: tickets.length,
      dateTime: ticket.endTime.subtract(Duration(
          minutes: alertBeforeTicketEnd.isTrue ? alertMinutes.value : 1)),
      loopAudio: false,
      vibrate: vibrateWithAlert.value,
      // volume: volume,
      assetAudioPath: alertPath.value,
      notificationTitle: 'Ticket Expired'.tr,
      notificationBody: '${"Your Ticket".tr} (${ticket.id}) ${"is Expired".tr}',
      enableNotificationOnKill: true,
    );
    return alarmSettings;
  }

  Future<bool> _requestLocationPermission() async {
    // final status = await Permission.location.request();
    // if (status.isGranted) {
    //   // Permission granted, proceed with accessing location
    //   print('Location permission granted');
    // } else if (status.isDenied) {
    //   // Permission denied
    //   print('Location permission denied');
    // } else if (status.isPermanentlyDenied) {
    //   // Permission permanently denied, open app settings
    //   print('Location permission permanently denied');
    //   openAppSettings();
    // }
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();

      if (!_serviceEnabled) {
        debugPrint('Location Denied once');
        return _serviceEnabled;
      } else {
        return _serviceEnabled;
      }
    } else {
      return _serviceEnabled;
    }
  }

  Vehicle getVehicleById(int id) {
    final List<Vehicle> existingVehicles = vehicles;
    return existingVehicles.firstWhere(
      (vehicle) => vehicle.id == id,
    );
  }

  Future<void> getUserLocation() async {
    // await _requestLocationPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      print(placemarks[0].locality);
      if (AppData.emirates.contains(placemarks[0].locality)) {
        emirate.value = placemarks[0].locality!;
        zoneCodesEmirate.value = AppData.emirateParkingZones[emirate.value]!;
        zoneCode.value = zoneCodesEmirate.first;
      }
      // ...
    } catch (err) {
      print(err);
    }
    // isloading.value = false;
    // update();
    isloading.value = false;
  }

  Future<void> requestPermissions() async {
    if (await Permission.phone.request().isGranted &&
        await Permission.sms.request().isGranted &&
        await Permission.location.request().isGranted) {
      await _requestLocationPermission().then((value) async {
        print("resqi $value");
        if (value) {
          await getUserLocation();
        } else {
          isloading.value = false;
        }
      });
      // Permissions granted, proceed with functionality
    } else {
      isloading.value = false;
      // Permissions not granted, handle accordingly
    }
  }

  Future<void> fetchSIMCards() async {
    isloading.value = true;
    await requestPermissions();
    try {
      final List<dynamic> simCardsJson =
          await platform.invokeMethod('getSIMCards');
      // setState(() {
      simCards.value =
          simCardsJson.map((json) => SIMCard.fromJson(json)).toList();

      print("------------------");
      print(simCards.length);
      print("------------------");
      if (simCards.isNotEmpty) {
        selectedSimSlot.value = 0;
      }
      // });
    } on PlatformException catch (e) {
      // setState(() {
      smsStatus.value = "Failed to fetch SIM cards: '${e.message}'.";
      // });
    }
  }

  Future<void> sendSMS() async {
    print("asdasd");
    if (selectedSimSlot.value != 5 && selectedVehicle != null) {
      try {
        await platform.invokeMethod('sendSMS', <String, dynamic>{
          // "00971566167139",
          'phoneNumber': AppData.parkingPhoneNumber[emirate.value],
          'message': AppMethods.MessageFormat(emirate.value, selectedVehicle!,
              zoneCode.value, zoneNumber.text, duration.value),
          'simSlot': selectedSimSlot.value,
        });

        smsStatus.value = 'Status: SMS sent, waiting for delivery';
      } on PlatformException catch (e) {
        // setState(() {
        smsStatus.value = "Failed to send SMS: '${e.message}'.";
        // });
      }
    }
  }

  void listenForSmsDelivery() {
    smsDeliveryChannel.receiveBroadcastStream().listen((status) {
      smsStatus.value = 'Status: $status';
      print("status");
      print(status);
      print("status");
      if (status == AppData.SMS_DELIVERED) {
        addTicket();
      }
    });
  }

  void loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Alarm.getAlarms();
    alertPath.value = prefs.getString('alertTone') ?? AppsKeys.defualtSound;

    vibrateWithAlert.value = prefs.getBool('vibrateWithAlert') ?? true;
    alertPath.value = "assets/" + alertPath.value;
    alertOnTicketEnd.value = prefs.getBool('alertOnTicketEnd') ?? true;
    alertBeforeTicketEnd.value = prefs.getBool('alertBeforeTicketEnd') ?? true;
    alertMinutes.value = prefs.getInt('alertMinutes') ?? 5;
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
        alarmSettings: alarmSettings,
        ticket: tickets.last,
      ),
    );
    // loadAlarms();
  }

  void incresDurcation() {
    if (newDurationTikcet.value < 11) {
      newDurationTikcet.value++;
      update();
    }
  }

  void descressDurcation() {
    if (newDurationTikcet.value > 1) {
      newDurationTikcet.value--;
      update();
    }
  }

  @override
  void onInit() {
    fetchSIMCards();
    listenForSmsDelivery();

    loadSettings();
    if (Alarm.android) {
      checkAndroidNotificationPermission();
      checkAndroidScheduleExactAlarmPermission();
    }
    // loadAlarms();
    // subscription ??= Alarm.ringStream.stream.listen((event) async{
    //   await Get.to(()=>ExampleAlarmRingScreen(alarmSettings: buildAlarmSettings(ticket)))
    // },);
    if (isListening.value) {
      subscription ??= Alarm.ringStream.stream.listen(navigateToRingScreen);
    }

    emirate.value = AppData.emirates.first;
    zoneCodesEmirate.value = AppData.emirateParkingZones[emirate.value]!;
    zoneCode.value = zoneCodesEmirate.first;
    duration.value = AppData.durationsParking.first;
    parkingCost.value =
        double.parse(AppMethods.extractNumbers(duration.value)) *
            fixedCost.value;

    super.onInit();
  }
}
