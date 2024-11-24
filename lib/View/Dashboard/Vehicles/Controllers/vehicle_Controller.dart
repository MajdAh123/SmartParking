import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_parking/Data/ExcelFuncations.dart';
import 'package:smart_parking/Models/PlateCode.dart';
import 'package:smart_parking/View/CarFunctions/Model/TicketModel.dart';
import 'package:smart_parking/View/Dashboard/Home/Controllers/home_page_Controller.dart';
import 'package:smart_parking/constant/appcolors.dart';
import 'package:smart_parking/constant/data.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_parking/constant/keys.dart';
import '../../../../Models/PlateSource.dart';
import '../Models/VehicleModel.dart';

class VehicleController extends GetxController {
  RxInt plateSourceId = 0.obs;
  RxInt plateid = 0.obs;
  // RxString plateType = "".obs;
  RxInt plateCodeId = 0.obs;
  RxBool isprimary = false.obs;
  TextEditingController platenumber = TextEditingController();
  // RxList<String> allPlateType = <String>[].obs;
  RxList<PlateCode> allPlateCode = <PlateCode>[].obs;
  RxList<Vehicle> myVehicles = <Vehicle>[].obs;
  RxList<PlateSource> allPlateSource = <PlateSource>[].obs;

  final box = GetStorage();

  List<Vehicle> get vehicles {
    final List<dynamic> jsonList = box.read(AppsKeys.vehicles) ?? [];
    return jsonList.map((json) => Vehicle.fromJson(json)).toList();
  }

  updateMyVehicles() {
    myVehicles.value = vehicles;
    update();
  }

  bool checkValidation() {
    if (plateSourceId.value == 0 ||
        plateCodeId.value == 0 ||
        platenumber.text.isEmpty) {
      update();
      return false;
    } else {
      update();
      return true;
    }
  }

  void addVehicle(Vehicle vehicle) {
    final List<Vehicle> existingVehicles = vehicles;
    vehicle.id = existingVehicles.length + 1;
    if (vehicle.isPrimary) {
      for (Vehicle ve in existingVehicles) {
        if (ve.isPrimary) {
          ve.isPrimary = false;
        }
      }
    }

    existingVehicles.add(vehicle);
    box.write(AppsKeys.vehicles,
        existingVehicles.map((vehicle) => vehicle.toJson()).toList());
    print("done.............");
    updateMyVehicles();
    platenumber.clear();
    Get.back();
    Get.snackbar("Done...!".tr, "The vehicle has been added".tr,
        colorText: AppColors.white, backgroundColor: AppColors.fourthColor);
  }

  void updateVehicle(Vehicle updatedVehicle) {
    final List<Vehicle> existingVehicles = vehicles;
    final index = existingVehicles
        .indexWhere((vehicle) => vehicle.id == updatedVehicle.id);

    if (index != -1) {
      if (updatedVehicle.isPrimary) {
        for (Vehicle ve in existingVehicles) {
          if (ve.isPrimary) {
            ve.isPrimary = false;
          }
        }
      }
      existingVehicles[index] = updatedVehicle;
      box.write(AppsKeys.vehicles,
          existingVehicles.map((vehicle) => vehicle.toJson()).toList());
    }
    print(index);
    updateMyVehicles();
    Get.back();
    Get.snackbar("Done...!".tr, "The vehicle has been updated".tr,
        colorText: AppColors.white, backgroundColor: AppColors.fourthColor);
  }

  void deleteVehicle(int id, bool ischeck) {
    final List<Vehicle> existingVehicles = vehicles;
    final updatedVehicles =
        existingVehicles.where((vehicle) => vehicle.id != id).toList();
    if (ischeck && updatedVehicles.isNotEmpty) {
      updatedVehicles.first.isPrimary = true;
    }
    List<Ticket> currentTickets = Get.find<HomePageController>().tickets;
    currentTickets.removeWhere((e) => e.carId == id);

    box.write(AppsKeys.vehicles,
        updatedVehicles.map((vehicle) => vehicle.toJson()).toList());
    box.write(
        AppsKeys.tickets, currentTickets.map((tick) => tick.toJson()).toList());

    updateMyVehicles();
  }

  Vehicle getVehicleById(int id) {
    final List<Vehicle> existingVehicles = vehicles;
    return existingVehicles.firstWhere(
      (vehicle) => vehicle.id == id,
    );
  }

  RxBool isLoading = false.obs;
  initData() async {
    print("asdasdasd");
    isLoading.value = true;
    await readPlateSourceData().then((value) => allPlateSource.value = value);
    await readPlateCodeData().then((value) => allPlateCode.value = value);
    isLoading.value = false;
    update();
  }

  @override
  void onInit() {
    // plateSource.value = AppData.emirates[0];
    // allPlateType.value = AppData.plateTypesInEmirates[plateSource.value]!;
    // plateType.value = allPlateType[0];
    // allPlateCode.value = AppData.emiratePlateCodes[plateSource.value]!;
    // plateCode.value = allPlateCode[0];
    initData();
    updateMyVehicles();
    if (vehicles.isEmpty) {
      isprimary.value = true;
    }
    // TODO: implement onInit
    super.onInit();
  }
}
