import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_parking/View/CarFunctions/BookParking/Controllers/book_parking_Controller.dart';
import 'package:smart_parking/View/CarFunctions/Widgets/buttons.dart';
import 'package:smart_parking/View/CarFunctions/Widgets/textFiledContiner.dart';
import 'package:smart_parking/View/Dashboard/Vehicles/Controllers/vehicle_Controller.dart';
import 'package:smart_parking/View/Dashboard/Vehicles/Models/VehicleModel.dart';
import 'package:smart_parking/constant/data.dart';
import 'package:smart_parking/constant/size.dart';
// import 'package:smart_parking/controllers/reminder_Controller.dart';

import '../../../constant/appcolors.dart';
import '../../Dashboard/Home/Widget/courlsCardOne.dart';
import '../Widgets/dropDownItems.dart';
import '../BookParking/bookParkingPage.dart';
import 'controllers/reminderController.dart';

class AddReminderPage extends StatefulWidget {
  AddReminderPage({super.key, required this.vehicle});
  Vehicle vehicle;
  @override
  State<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  VehicleController vehicleController = Get.put(VehicleController());
  BookParkingController bookParkingController =
      Get.find<BookParkingController>();
  // ReminderController reminderController = Get.put(Re)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        leadingWidth: 5,
        title: Text("EMIRATES SMART PARKING".tr),
        centerTitle: true,
      ),
      body: Container(
        width: Appsize.width(context),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "PARKING REMINDER".tr,
                style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              GetBuilder(
                  init: ReminderController(),
                  builder: (controller) {
                    return carousel.CarouselSlider(
                      options: carousel.CarouselOptions(
                        height: 140.0,
                        enableInfiniteScroll: false,
                        autoPlayCurve: Curves.easeInCubic,
                        initialPage: vehicleController.myVehicles
                            .indexOf(widget.vehicle),
                        onPageChanged: (index, reason) {
                          print(index);
                          controller.selectedVehicle =
                              vehicleController.myVehicles[index];
                          // print(bookParkingController.selectedVehicle!.id -
                          //     1);
                        },
                      ),
                      items: vehicleController.myVehicles.map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              margin: EdgeInsets.all(10),
                              decoration: AppColors.containerDecoration,
                              padding: EdgeInsets.symmetric(
                                  vertical: 30, horizontal: 40),
                              child: SizedBox(
                                width: Appsize.width(context) * .8,
                                child:
                                    CarCardNumber(isexpanded: true, vehicle: i),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    );
                  }),
              GetBuilder(
                init: ReminderController(),
                builder: (controller) {
                  return controller.isLoading.isTrue
                      ? CircularProgressIndicator(
                          color: AppColors.white,
                        )
                      : Column(
                          children: [
                            DropDownItemWidget(
                              label: "City".tr,
                              items: AppData.emirates,
                              stelctedItem: controller.emirate.value,
                              onchange: (newValue) {
                                controller.emirate.value = newValue!;
                                // bookParkingController.emirate.value = newValue!;
                                controller.zoneCodesEmirate.value =
                                    AppData.emirateParkingZones[newValue]!;
                                controller.zoneCode.value =
                                    controller.zoneCodesEmirate.first;
                                controller.update();
                                // setState(() {});
                              },
                            ),
                            DropDownItemWidget(
                              label: "zone code".tr,
                              items: controller.zoneCodesEmirate,
                              stelctedItem: controller.zoneCode.value,
                              onchange: (newValue) {
                                controller.zoneCode.value = newValue!;
                                controller.update();
                                // setState(() {});
                              },
                            ),
                            TextFieldContainer(
                                label: "zone number".tr,
                                type: TextInputType.number,
                                textEditingController: controller.zoneNumber),
                            TextFieldContainer(
                                label: "remind me on".tr,
                                type: TextInputType.datetime,
                                textEditingController:
                                    controller.reminderONText),
                            DropDownItemWidget(
                              label: "remind me before".tr,
                              items: AppData.remaindMeBeforOption,
                              stelctedItem: controller.reminderBefor.value,
                              onchange: (newValue) {
                                controller.zoneCode.value = newValue!;
                                controller.update();
                                // setState(() {});
                              },
                            ),
                            GreenButton(
                                onTap: () {
                                  controller.addReminder();
                                },
                                title: "add reminder".tr),
                            BlueButton(
                                onTap: () {
                                  Get.back();
                                },
                                title: "cancel".tr)
                          ],
                        );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
