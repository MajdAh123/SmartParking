import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:smart_parking/View/CarFunctions/BookParking/Controllers/book_parking_Controller.dart';
import 'package:smart_parking/View/CarFunctions/Reminder/addReminderPage.dart';
import 'package:smart_parking/View/CarFunctions/BookParking/bookParkingPage.dart';
import 'package:smart_parking/View/CarFunctions/Reminder/controllers/reminderController.dart';
import 'package:smart_parking/View/Dashboard/History/Controllers/historyController.dart';
import 'package:smart_parking/View/Dashboard/History/historyPage.dart';
import 'package:smart_parking/View/Dashboard/Vehicles/Controllers/vehicle_Controller.dart';
import 'package:smart_parking/View/Dashboard/Vehicles/Models/VehicleModel.dart';
import 'package:smart_parking/View/Dashboard/Vehicles/addVehicle.dart';
import 'package:smart_parking/constant/appcolors.dart';
import 'package:smart_parking/constant/data.dart';
import 'package:smart_parking/logale/locale_Cont.dart';
import '../../../../constant/size.dart';

class CarouselCardOne extends StatelessWidget {
  CarouselCardOne(
      {super.key, required this.vehicle, required this.indexofVehicle});
  Vehicle vehicle;
  int indexofVehicle;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: AppColors.paddingcontainer,
        width: Appsize.width(context),
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        decoration: AppColors.containerDecoration2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CarCardNumber(
              isexpanded: true,
              vehicle: vehicle,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GreenCard(
                  iconData: Icons.local_parking_rounded,
                  title: "Book A Parking".tr,
                  ontap: () {
                    BookParkingController bookParkingController =
                        Get.find<BookParkingController>();
                    bookParkingController.selectedVehicle = vehicle;
                    // bookParkingController.emirate.value = "";
                    bookParkingController.zoneCode.value = "";
                    bookParkingController.duration.value = "";
                    bookParkingController.parkingCost.value = 0.0;
                    bookParkingController.zoneNumber.text = "";
                    Get.to(() => BookParkingPage(
                          vehicle: vehicle,
                        ));
                  },
                ),
                GreenCard(
                  iconData: Ionicons.notifications_outline,
                  title: "remind ticket".tr,
                  ontap: () {
                    // BookParkingController bookParkingController =
                    //     Get.put(BookParkingController());
                    // bookParkingController.isListening.value = false;
                    ReminderController reminderController =
                        Get.put(ReminderController());
                    reminderController.selectedVehicle = vehicle;
                    Get.to(() => AddReminderPage(
                          vehicle: vehicle,
                        ));
                  },
                ),
                // GreenCard(
                //   iconData: Ionicons.car_outline,
                //   title: "Add vehicle",
                //   ontap: () {
                //     Get.to(() => AddVehiclePage());
                //   },
                // ),
                GreenCard(
                  iconData: Icons.history_outlined,
                  title: "parking history".tr,
                  ontap: () {
                    HistoryController historyController =
                        Get.put(HistoryController());
                    historyController.indexOfVehicle.value = indexofVehicle;
                    historyController.selectedVehicle =
                        historyController.myVehicles[indexofVehicle];
                    historyController.vehicleTickets.value = historyController
                        .tickets
                        .where((element) =>
                            element.carId == vehicle.id &&
                            element.endTime.isBefore(DateTime.now()))
                        .toList();
                    historyController.vehicleTickets.value =
                        historyController.vehicleTickets.reversed.toList();
                    historyController.update();

                    Get.to(() => HistoryPage());
                  },
                )
              ],
            )
          ],
        ));
  }
}

class CarCardNumber extends GetView<VehicleController> {
  CarCardNumber({super.key, required this.vehicle, this.isexpanded = false});
  final bool isexpanded;
  Vehicle vehicle;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.isTrue
          ? CircularProgressIndicator()
          : Container(
              // width: Appsize.width(context) * 0.48,
              constraints: BoxConstraints(
                  maxWidth: Appsize.width(context) * 0.5,
                  minWidth: Appsize.width(context) * 0.22),
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: AppColors.white),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.black, width: 2),
                    color: AppColors.white),
                child: Row(
                  mainAxisSize:
                      isexpanded ? MainAxisSize.max : MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: Appsize.width(context) * 0.02,
                        maxWidth: Appsize.width(context) * 0.09,
                      ),
                      child: AutoSizeText(
                        // vehicle.plateCodeId.toString().toUpperCase(),
                        Get.find<MyLocaleController>().lan.value == "en"
                            ? controller.allPlateCode
                                .where((p0) => p0.id == vehicle.plateCodeId)
                                .toList()
                                .first
                                .codeEn
                            : controller.allPlateCode
                                .where((p0) => p0.id == vehicle.plateCodeId)
                                .toList()
                                .first
                                .codeAr,
                        maxFontSize: 16,
                        minFontSize: 12,

                        // controller: _textEditingController,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    // Flexible(
                    //   child: Text(
                    //     vehicle.plateCode,
                    //     style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: Appsize.width(context) * 0.15,
                          minWidth: Appsize.width(context) * 0.1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            controller.allPlateSource
                                .lastWhere((element) =>
                                    element.id == vehicle.plateSourceId)
                                .cityAr,
                            // .where((p0) => p0.id == vehicle.plateSourceId)
                            // .toList()
                            // .first
                            // .cityAr,
                            // AppData.translateToArabic(vehicle.plateSourceId.toString()),
                            maxLines: 1,
                            maxFontSize: 14,
                            minFontSize: 7,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                height: 1, fontWeight: FontWeight.bold),
                          ),
                          AutoSizeText(
                            // vehicle.plateSourceId.toString().toUpperCase(),
                            controller.allPlateSource
                                .lastWhere((element) =>
                                    element.id == vehicle.plateSourceId)
                                .cityEn,
                            // .where((p0) => p0.id == vehicle.plateSourceId)
                            // .toList()
                            // .first
                            // .cityEn,
                            maxLines: 1,
                            maxFontSize: 14,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 7,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: Appsize.width(context) * 0.12,
                        maxWidth: Appsize.width(context) * 0.14,
                      ),
                      child: AutoSizeText(
                        vehicle.plateNumber,
                        maxFontSize: 18,
                        minFontSize: 12,
                        maxLines: 1,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

class GreenCard extends StatelessWidget {
  const GreenCard(
      {super.key,
      required this.title,
      required this.iconData,
      required this.ontap});
  final IconData iconData;
  final String title;
  final void Function() ontap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        // width: 65,
        margin: AppColors.paddingcontainer,
        padding: AppColors.paddingcontainer,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              15,
            ),
            border: Border.all(width: 1, color: Colors.white),
            color: AppColors.green),
        child: InkWell(
          onTap: ontap,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Icon(
                  iconData,
                  size: 15,
                  color: AppColors.white,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                      color: AppColors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
