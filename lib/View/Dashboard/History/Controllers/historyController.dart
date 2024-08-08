import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../constant/keys.dart';
import '../../../CarFunctions/Model/TicketModel.dart';
import '../../Vehicles/Models/VehicleModel.dart';

class HistoryController extends GetxController {
  final box = GetStorage();
  RxInt indexOfVehicle = 0.obs;
  Vehicle? selectedVehicle;
  RxList<Vehicle> myVehicles = <Vehicle>[].obs;
  RxList<Ticket> vehicleTickets = <Ticket>[].obs;
  List<Vehicle> get vehicles {
    final List<dynamic> jsonList = box.read(AppsKeys.vehicles) ?? [];
    return jsonList.map((json) => Vehicle.fromJson(json)).toList();
  }

  List<Ticket> get tickets {
    final List<dynamic> jsonList = box.read(AppsKeys.tickets) ?? [];
    return jsonList.map((json) => Ticket.fromJson(json)).toList();
  }

  updateMyVehicles() {
    myVehicles.value = vehicles;
    update();
  }

  void incressVehicle() {
    if (indexOfVehicle.value + 1 != myVehicles.length) {
      indexOfVehicle.value++;
      selectedVehicle = myVehicles[indexOfVehicle.value];
      vehicleTickets.value = tickets
          .where((element) =>
              element.carId == selectedVehicle!.id &&
              element.endTime.isBefore(DateTime.now()))
          .toList();
      vehicleTickets.value = vehicleTickets.reversed.toList();
      update();
    }
  }

  void descressVehicle() {
    if (indexOfVehicle.value != 0) {
      indexOfVehicle.value--;
      selectedVehicle = myVehicles[indexOfVehicle.value];
      vehicleTickets.value = tickets
          .where((element) =>
              element.carId == selectedVehicle!.id &&
              element.endTime.isBefore(DateTime.now()))
          .toList();
      vehicleTickets.value = vehicleTickets.reversed.toList();
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    updateMyVehicles();
    selectedVehicle = myVehicles[indexOfVehicle.value];
    vehicleTickets.value = tickets
        .where((element) =>
            element.carId == selectedVehicle!.id &&
            element.endTime.isBefore(DateTime.now()))
        .toList();
    // TODO: implement onInit
  }
}
