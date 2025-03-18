import 'dart:async';
import 'dart:developer';
// import 'dart:ffi';
import 'dart:io';
// import 'dart:math';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_parking/Data/ExcelFuncations.dart';
import 'package:smart_parking/Data/SmsValidate.dart';
import 'package:smart_parking/Models/ParkingZoneandHours.dart';
import 'package:smart_parking/View/CarFunctions/BookParking/ring.dart';
import 'package:smart_parking/View/CarFunctions/Model/TicketModel.dart';
import 'package:smart_parking/View/CarFunctions/Widgets/buttons.dart';
import 'package:smart_parking/View/Dashboard/Home/Controllers/home_page_Controller.dart';
import 'package:smart_parking/View/Dashboard/Vehicles/Models/VehicleModel.dart';
import 'package:smart_parking/constant/data.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart_parking/constant/methods.dart';
import 'package:location/location.dart' as loc;
import 'package:alarm/alarm.dart';
import 'package:smart_parking/constant/size.dart';
import 'package:smart_parking/logale/locale_Cont.dart';
import 'package:smart_parking/logale/logale.dart';
import '../../../../constant/appcolors.dart';
import '../../../../constant/keys.dart';
import '../../Model/SIMmodel.dart';
import 'package:readsms/readsms.dart';
import 'package:permission_handler/permission_handler.dart';

class BookParkingController extends GetxController {
  RxString emirate = "".obs;
  RxString zoneCode = "".obs;
  RxString duration = "".obs;
  RxDouble parkingCost = 1.0.obs;
  RxDouble fixedCost = 2.38.obs;
  RxString smsStatus = "".obs;
  TextEditingController zoneNumber = TextEditingController();
  RxList<ParkingZone> zoneCodesEmirate = <ParkingZone>[].obs;
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
  void addTicket(DateTime enddate) {
    Ticket ticket = SlectedTikcet ??
        Ticket(
            id: 0,
            carId: selectedVehicle!.id,
            emirate: emirate.value,
            startTime: DateTime.now(),
            // endTime: DateTime.now().add(Duration(
            //     hours: double.parse(AppMethods.extractNumbers(duration.value))
            //         .toInt())),
            endTime: enddate,
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
        emirate.value = AppData.Ajman;
        zoneCodesEmirate.where((p0) => p0.city == emirate.value);
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

      if (placemarks.isNotEmpty) {
        log(placemarks[0].locality.toString());
        log(placemarks[0].toString());
        log(placemarks.length.toString());
        log(zoneCodesEmirate.length.toString());
        String cityLocation = "";
        if (placemarks[0].locality == null || placemarks[0].locality == "") {
          cityLocation = "Ajman";
        } else {
          cityLocation = placemarks[0].locality!;
        }
        List<ParkingZone> filterdList = zoneCodesEmirate
            .where((p0) => p0.city
                .toLowerCase()
                .contains(cityLocation.substring(0, 3).toLowerCase()))
            .toList();
        log(filterdList.length.toString());

        if (filterdList.isNotEmpty) {
          emirate.value = filterdList.first.city;
          zoneCodesEmirate.where((p0) => p0.city == emirate.value);
          print("selected Emir " + emirate.value);
          // zoneCode.value = zoneCodesEmirate.first;
        } else {
          print("selected Emir 1111" + emirate.value);
          emirate.value = AppData.Ajman;
          zoneCodesEmirate.where((p0) => p0.city == emirate.value);
          print("selected Emir 2222" + emirate.value);
        }
      } else {
        emirate.value = AppData.Ajman;
        zoneCodesEmirate.where((p0) => p0.city == emirate.value);
      }
      // ...
    } catch (err) {
      print(err);
      emirate.value = AppData.Ajman;
      zoneCodesEmirate.where((p0) => p0.city == emirate.value);
    }
    // isloading.value = false;
    // update();
    isloading.value = false;
  }

  String convertTo12HourFormat(String time24) {
    // Parse the 24-hour time format (22:00:00) into DateTime
    DateTime parsedTime = DateFormat('HH:mm:ss').parse(time24);

    // Format the DateTime to 12-hour time with AM/PM
    String formattedTime =
        DateFormat('h:mm a').format(parsedTime).toUpperCase();
    if (Get.find<MyLocaleController>().lan.value == "ar") {
      if (formattedTime.contains('AM')) {
        formattedTime = formattedTime.replaceAll('AM', 'صباحا');
      } else if (formattedTime.contains('PM')) {
        formattedTime = formattedTime.replaceAll('PM', 'مساءا');
      }
    }
    return formattedTime;
  }

  bool isRamadanTime() {
    // Define the date range
    DateTime startDate = DateTime(2025, 2, 27); // 2/27/2025
    DateTime endDate = DateTime(2025, 3, 29); // 3/29/2025

    // Get the current date
    DateTime now = DateTime.now();

    // Check if 'now' is between startDate and endDate (inclusive)
    if (now.isAfter(startDate) && now.isBefore(endDate)) {
      print('Current date is between 2/27/2025 and 3/29/2025.');
      return true;
    } else {
      print('Current date is NOT between 2/27/2025 and 3/29/2025.');
      return false;
    }
  }

  TimeOfDay stringToTimeOfDay(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

// Function to check if current time is between two TimeOfDay values
  bool isTimeBetween(String startTimeString, String endTimeString) {
    // Parse the string times into TimeOfDay objects
    TimeOfDay startTime = stringToTimeOfDay(startTimeString);
    TimeOfDay endTime = stringToTimeOfDay(endTimeString);

    // Get the current time
    TimeOfDay currentTime = TimeOfDay.now();

    // Convert TimeOfDay to DateTime for easier comparison
    DateTime now = DateTime.now();
    DateTime startDateTime = DateTime(
        now.year, now.month, now.day, startTime.hour, startTime.minute);
    DateTime endDateTime =
        DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);
    DateTime currentDateTime = DateTime(
        now.year, now.month, now.day, currentTime.hour, currentTime.minute);

    // Check if current time is between start and end time
    return currentDateTime.isAfter(startDateTime) &&
        currentDateTime.isBefore(endDateTime);
  }

  Future<bool> getPermission() async {
    if (await Permission.sms.status == PermissionStatus.granted) {
      return true;
    } else {
      if (await Permission.sms.request() == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  String parkingText() {
    if (duration.value.isEmpty) {
      return "";
    } else {
      List<ParkingZone> selectedParkinglist = zoneCodesEmirate
          .where((element) =>
              element.city == emirate.value && emirate.value == "Ajman" ||
                      emirate.value == "Sharjah" ||
                      emirate.value == AppData.Khor_Fakkan
                  ? element.zone == "..."
                  : element.zone == zoneCode.value &&
                      element.hours == double.parse(duration.value))
          .toList();
      late ParkingZone selectedParking;
      if (selectedParkinglist.length > 1) {
        if (isTimeBetween(selectedParkinglist[0].normalTimeFrom,
            selectedParkinglist[0].normalTimeTo)) {
          selectedParking = selectedParkinglist[0];
        } else {
          selectedParking = selectedParkinglist[1];
        }
      } else {
        selectedParking = selectedParkinglist[0];
      }
      // int timeTo =int.parse(selectedParking.normalTimeTo)
      if (Get.find<MyLocaleController>().lan.value == "en") {
        return "Parking timings in selected zone is ${convertTo12HourFormat(isRamadanTime() ? selectedParking.ramadanTimeFrom : selectedParking.normalTimeFrom)} to ${convertTo12HourFormat(isRamadanTime() ? selectedParking.ramadanTimeTo : selectedParking.normalTimeTo)},(Sat - Thu). Free parking on fridays and public holidays (maximum time allowed is 4 hours)";
      } else {
        return "أوقات الوقوف في المنطقة المحددة من 8:00 صباحًا إلى 10:00 مساءً (السبت - الخميس). الوقوف مجاني أيام الجمعة والعطلات الرسمية (الحد الأقصى للوقت المسموح به هو 4 ساعات)";
      }
    }
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
          emirate.value = AppData.Ajman;
          zoneCodesEmirate.where((p0) => p0.city == emirate.value);
        }
      });
      // Permissions granted, proceed with functionality
    } else {
      isloading.value = false;
      emirate.value = AppData.Ajman;
      zoneCodesEmirate.where((p0) => p0.city == emirate.value);
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

  Future<void> sendSMS({bool isReply = false}) async {
    log(
      AppMethods.MessageFormat(emirate.value, selectedVehicle!, zoneCode.value,
          zoneNumber.text, double.parse(duration.value).toInt().toString()),
    );

    // log(double.parse(duration.value).toInt().toString());

    // print("asdasd");
    if (selectedSimSlot.value != 5 && selectedVehicle != null) {
      try {
        await platform.invokeMethod('sendSMS', <String, dynamic>{
          // "00971566167139",
          'phoneNumber': AppData.parkingPhoneNumber[emirate.value],
          'message': isReply
              ? "1"
              : AppMethods.MessageFormat(emirate.value, selectedVehicle!,
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

  void listenForSmsDelivery(
    String message,
    String sender,
  ) async {
    // await Future.delayed(Duration(seconds: 2));
    smsDeliveryChannel.receiveBroadcastStream().listen((status) {
      smsStatus.value = 'Status: $status';
      log("status");
      log(status);
      log("statujjjjjs");

      if (status == AppData.SMS_DELIVERED) {
        if (AppData.parkingPhoneNumber.values.contains(sender)) {
          log("vvvvv : before validate}");
          log("wwww: $message");

          int validateStatus = validateSMS(emirate.value, message);
          log("vvvvvvvvvvvvvvvvvvvvv:${validateStatus.toString()}");
          if (validateStatus == 0) {
            addTicket(AppMethods.getEndDateForTicket(message)!);
            Get.snackbar("Done...!".tr, message,
                colorText: AppColors.white,
                backgroundColor: AppColors.fourthColor);
          } else if (validateStatus == 1) {
            showBottomSheet();
            //    Get.snackbar("Done...!".tr, smsMessageReceving,
            // colorText: AppColors.white, backgroundColor: AppColors.fourthColor , );
            // free barking
          } else if (validateStatus == 2) {
            Get.snackbar("Opps...!".tr, message,
                colorText: AppColors.white, backgroundColor: AppColors.red);
            // no balance
          } else if (validateStatus == 3) {
            Get.snackbar("Opps...!".tr, "Something wrong".tr,
                colorText: AppColors.white, backgroundColor: AppColors.red);
            //something wrong
          }
        } else {
          log("Not contaons");
        }
        // addTicket();
      }
    });
  }

  showBottomSheet() {
    Get.bottomSheet(
        isScrollControlled: true,
        barrierColor: Colors.black87,
        Container(
          height: Get.height * 0.7,
          width: Get.width,
          padding: const EdgeInsets.fromLTRB(15, 40, 15, 10),
          decoration: BoxDecoration(
            color: AppColors.primeryColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "New Message from $senderMessageReceving",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Message",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                smsMessageReceving.value,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              GreenButton(
                  onTap: () {
                    // sendSMS();

                    if (selectedSimSlot.value != 5) {
                      sendSMS(isReply: true);
                    } else {
                      fetchSIMCards().then(
                        (value) => ChooseSIM(Get.context!)
                            .then((onValue) => Get.back()),
                      );
                    }
                  },
                  title: "Reply".tr),
              BlueButton(
                  onTap: () {
                    Get.back();
                  },
                  title: "cancel".tr)
            ],
          ),
        ));
  }

  Future<dynamic> ChooseSIM(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Choose SIM for this SMS".tr,
                style: TextStyle(fontSize: 18),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: simCards
                    .map((element) => Container(
                          width: Appsize.width(context),
                          child: GestureDetector(
                            onTap: () async {
                              Get.back();
                              selectedSimSlot.value = element.slotIndex;
                              await sendSMS(isReply: true);
                            },
                            child: Row(children: [
                              Icon(Icons.sim_card),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "${element.slotIndex + 1}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    element.displayName,
                                    style: TextStyle(
                                        fontSize: 15,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(element.carrierName),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              )
                            ]),
                          ),
                        ))
                    .toList(),
              ),
            ));
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

  initData() async {
    await readParkingZoneData().then((value) => zoneCodesEmirate.value = value);
  }

  final _plugin = Readsms();
  RxString smsMessageReceving = ''.obs;
  RxString senderMessageReceving = ''.obs;
  RxString timeMessageReceving = ''.obs;
  RxList<SMS> allRecivingSms = <SMS>[].obs;
  Rx<Debouncer> debounce = Debouncer().obs;
  RxBool checkRecivingSMS(String sender) {
    return AppData.parkingPhoneNumber.entries.contains(sender).obs;
  }

  @override
  void onInit() {
    initData();
    fetchSIMCards();
    // listenForSmsDelivery();
    getPermission().then((value) {
      if (value) {
        _plugin.read();
        _plugin.smsStream.listen((event) async {
          // setState(() {
          if (checkRecivingSMS(event.sender).value) {
            allRecivingSms.add(event);
            await Future.delayed(Duration(seconds: 2)).then((onValue) =>
                listenForSmsDelivery(
                    allRecivingSms.last.body, allRecivingSms.last.sender));
          } else {
            smsMessageReceving.value = event.body;
            senderMessageReceving.value = event.sender;
          }

          // });
        });
      }
    });
    ;
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

    // emirate.value = AppData.emirates.first;
    // zoneCodesEmirate.value = AppData.emirateParkingZones[emirate.value]!;
    // zoneCode.value = zoneCodesEmirate.first;
    // duration.value = AppData.durationsParking.first;
    // parkingCost.value =
    //     double.parse(AppMethods.extractNumbers(duration.value)) *
    //         fixedCost.value;

    super.onInit();
  }
}
