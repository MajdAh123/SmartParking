import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_parking/constant/appcolors.dart';
import 'package:smart_parking/constant/data.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_parking/constant/keys.dart';
import '../Models/VehicleModel.dart';

class VehicleController extends GetxController {
  RxString plateSource = "".obs;
  RxInt plateid = 0.obs;
  RxString plateType = "".obs;
  RxString plateCode = "".obs;
  RxBool isprimary = false.obs;
  TextEditingController platenumber = TextEditingController();
  RxList<String> allPlateType = <String>[].obs;
  RxList<String> allPlateCode = <String>[].obs;
  RxList<Vehicle> myVehicles = <Vehicle>[].obs;

  final box = GetStorage();

  List<Vehicle> get vehicles {
    final List<dynamic> jsonList = box.read(AppsKeys.vehicles) ?? [];
    return jsonList.map((json) => Vehicle.fromJson(json)).toList();
  }

  updateMyVehicles() {
    myVehicles.value = vehicles;
    update();
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
    if (ischeck) {
      updatedVehicles.first.isPrimary = true;
    }
    box.write(AppsKeys.vehicles,
        updatedVehicles.map((vehicle) => vehicle.toJson()).toList());

    updateMyVehicles();
  }

  Vehicle getVehicleById(int id) {
    final List<Vehicle> existingVehicles = vehicles;
    return existingVehicles.firstWhere(
      (vehicle) => vehicle.id == id,
    );
  }

  @override
  void onInit() {
    plateSource.value = AppData.emirates[0];
    allPlateType.value = AppData.plateTypesInEmirates[plateSource.value]!;
    plateType.value = allPlateType[0];
    allPlateCode.value = AppData.emiratePlateCodes[plateSource.value]!;
    plateCode.value = allPlateCode[0];
    updateMyVehicles();
    if (vehicles.isEmpty) {
      isprimary.value = true;
    }
    // TODO: implement onInit
    super.onInit();
  }
}
