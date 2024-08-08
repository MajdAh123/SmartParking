import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_parking/constant/methods.dart';

import '../../../../constant/keys.dart';
import '../../../CarFunctions/Model/TicketModel.dart';
import '../../Vehicles/Models/VehicleModel.dart';

class HomePageController extends GetxController {
  RxInt month = DateTime.now().month.obs;
  RxInt year = DateTime.now().year.obs;
  String date = '';
  RxInt ticketsValue = 0.obs;
  RxInt hoursValue = 0.obs;
  RxDouble paidValue = 0.0.obs;
  List<Ticket> activeTickets = [];
  List<Ticket> recentTickets = [];
  Rx<Duration> remainingTime = Duration().obs;
  RxInt newDurationTikcet = 1.obs;

  void calculateRemainingTime(DateTime endDate) {
    // Calculate the remaining time duration from now to the end date of the ticket
    remainingTime.value = endDate.difference(DateTime.now());

    // Update the remaining time every second
    Future.delayed(Duration(seconds: 1), () {
      update();
      calculateRemainingTime(endDate);
    });
  }

  void incressmonth() {
    if (month == DateTime.now().month.obs && year == DateTime.now().year.obs) {
    } else {
      month++;
      if (month.value > 12) {
        month = 1.obs;
        year.value++;
      } else if (month.value < 1) {
        month = 12.obs;
        year.value--;
      }
      date = AppMethods.monthNumberToText(month.value, year.value);
    }
    getTicktesValues();
    update();
  }

  void decressmonth() {
    month--;
    if (month.value > 12) {
      month = 1.obs;
      year.value++;
    } else if (month.value < 1) {
      month = 12.obs;
      year.value--;
    }
    date = AppMethods.monthNumberToText(month.value, year.value);
    getTicktesValues();
    update();
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

  final box = GetStorage();
  List<Ticket> get tickets {
    final List<dynamic> jsonList = box.read(AppsKeys.tickets) ?? [];
    return jsonList.map((json) => Ticket.fromJson(json)).toList();
  }

  List<Vehicle> get vehicles {
    final List<dynamic> jsonList = box.read(AppsKeys.vehicles) ?? [];
    return jsonList.map((json) => Vehicle.fromJson(json)).toList();
  }

  void getTicktesValues() {
    List<Ticket> allTikcet = tickets
        .where((element) =>
            element.endTime.year == year.value &&
            element.endTime.month == month.value)
        .toList();
    ticketsValue.value = allTikcet.length;
    hoursValue.value = 0;
    paidValue.value = 0;
    for (Ticket tik in allTikcet) {
      hoursValue.value += int.parse(AppMethods.extractNumbers(tik.duration));
      paidValue.value += tik.cost;
    }
    // update();
  }

  getActiveTickets() {
    activeTickets = tickets
        .where((element) => element.endTime.isAfter(DateTime.now()))
        .toList();
    update();
  }

  getRecentTickets() {
    recentTickets = tickets
        .where((element) => element.endTime.isBefore(DateTime.now()))
        .toList();
    update();
  }

  Vehicle getVehicleById(int id) {
    final List<Vehicle> existingVehicles = vehicles;
    return existingVehicles.firstWhere(
      (vehicle) => vehicle.id == id,
    );
  }

  @override
  void onInit() {
    date = AppMethods.monthNumberToText(month.value, year.value);
    getTicktesValues();
    getActiveTickets();
    getRecentTickets();
    update();
    // TODO: implement onInit
    super.onInit();
  }

  String selectedItem = "Option 1";
  selectitems(String? newValue) {
    selectedItem = newValue!;
    update();
  }
}
