import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_parking/View/CarFunctions/Widgets/dropDownItems.dart';
import 'package:smart_parking/View/CarFunctions/Widgets/textFiledContiner.dart';
import 'package:smart_parking/View/Dashboard/Home/Widget/courlsCardOne.dart';
import 'package:smart_parking/View/Dashboard/Vehicles/Controllers/vehicle_Controller.dart';
import 'package:smart_parking/constant/appcolors.dart';
import 'package:smart_parking/constant/data.dart';
import 'package:smart_parking/constant/methods.dart';
import 'package:smart_parking/constant/size.dart';
import 'package:smart_parking/View/CarFunctions/BookParking/Controllers/book_parking_Controller.dart';
import 'package:smart_parking/View/Dashboard/Home/Controllers/home_page_Controller.dart';

import '../../../logale/locale_Cont.dart';
import '../../Dashboard/Vehicles/Models/VehicleModel.dart';
import '../Widgets/buttons.dart';

class BookParkingPage extends StatefulWidget {
  BookParkingPage({super.key, required this.vehicle});
  Vehicle vehicle;
  @override
  State<BookParkingPage> createState() => _BookParkingPageState();
}

class _BookParkingPageState extends State<BookParkingPage> {
  // String _selectedItem = 'Option 1'; // Initial selected item
  HomePageController homePageController = Get.put(HomePageController());
  VehicleController vehicleController = Get.put(VehicleController());

  BookParkingController bookParkingController =
      Get.find<BookParkingController>();
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
        child: Obx(
          () => bookParkingController.isloading.isTrue
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: AppColors.white,
                    ),
                  ],
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        "BOOK A PARKING".tr,
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      carousel.CarouselSlider(
                        options: carousel.CarouselOptions(
                            enableInfiniteScroll: false,
                            onPageChanged: (index, reason) {
                              print(index);
                              bookParkingController.selectedVehicle =
                                  vehicleController.myVehicles[index];
                              print(bookParkingController.selectedVehicle!.id -
                                  1);
                            },
                            height: 140.0,
                            // scrollPhysics: NeverScrollableScrollPhysics(),
                            autoPlayCurve: Curves.easeInCubic,
                            initialPage: vehicleController.myVehicles
                                .indexOf(widget.vehicle)),
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
                                  child: CarCardNumber(
                                    isexpanded: true,
                                    vehicle: i,
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Obx(
                        () => Column(
                          children: [
                            DropDownItemWidget(
                              label: "City".tr,
                              items: bookParkingController.zoneCodesEmirate
                                  .map((e) => e.city)
                                  .toSet()
                                  .toList(),
                              stelctedItem:
                                  // Get.find<MyLocaleController>().lan.value == "en"
                                  // ? controller.allPlateSource
                                  //     .where((p0) =>
                                  //         p0.id == controller.plateSourceId.value)
                                  //     .toList()
                                  //     .first
                                  //     .cityEn
                                  // : controller.allPlateSource
                                  //     .where((p0) =>
                                  //         p0.id == controller.plateSourceId.value)
                                  //     .toList()
                                  //     .first
                                  // .cityAr
                                  bookParkingController.emirate.value,
                              onchange: (newValue) {
                                bookParkingController.emirate.value = newValue!;
                                bookParkingController.zoneCode.value = "";
                                bookParkingController.duration.value = "";
                                bookParkingController.parkingCost.value = 0.0;
                                bookParkingController.zoneNumber.text = "";
                                // bookParkingController.zoneCodesEmirate.value =
                                //     AppData.emirateParkingZones[newValue]!;
                                // bookParkingController.zoneCode.value =
                                //     bookParkingController
                                //         .zoneCodesEmirate.first;
                                // bookParkingController.duration.value =
                                //     AppData.durationsParking.first;
                                // bookParkingController.parkingCost.value =
                                //     double.parse(AppMethods.extractNumbers(
                                //             bookParkingController
                                //                 .duration.value)) *
                                //         bookParkingController.fixedCost.value;
                                // setState(() {});
                              },
                            ),
                            if (bookParkingController.zoneCodesEmirate
                                        .where((p0) =>
                                            p0.city ==
                                            bookParkingController.emirate.value)
                                        .map((e) => e.zone)
                                        .toSet()
                                        .toList()
                                        .length !=
                                    1 &&
                                bookParkingController.zoneCodesEmirate
                                        .where((p0) =>
                                            p0.city ==
                                            bookParkingController.emirate.value)
                                        .map((e) => e.zone)
                                        .toSet()
                                        .toList()
                                        .first !=
                                    "...")
                              DropDownItemWidget(
                                label: "zone code".tr,
                                items: bookParkingController.zoneCodesEmirate
                                    .where((p0) =>
                                        p0.city ==
                                        bookParkingController.emirate.value)
                                    .map((e) => e.zone)
                                    .toSet()
                                    .toList(),
                                stelctedItem:
                                    bookParkingController.zoneCode.value,
                                onchange: (newValue) {
                                  bookParkingController.zoneCode.value =
                                      newValue!;
                                  bookParkingController.duration.value = "";
                                  bookParkingController.parkingCost.value = 0.0;

                                  // setState(() {});
                                },
                              ),
                            if ([
                              AppData.Dubai,
                            ].contains(bookParkingController.emirate.value))
                              TextFieldContainer(
                                  label: "zone number".tr,
                                  type: TextInputType.number,
                                  textEditingController:
                                      bookParkingController.zoneNumber),
                            DropDownItemWidget(
                              // dropIconColor:
                              //     bookParkingController.emirate.value !=
                              //             AppData.Ajman
                              //         ? AppColors.black
                              //         : Colors.transparent,
                              // isEnable: bookParkingController.emirate.value !=
                              //     AppData.Ajman,
                              label: "Duration".tr,
                              items: bookParkingController.zoneCodesEmirate
                                  .where((p0) => p0.city ==
                                                  bookParkingController
                                                      .emirate.value &&
                                              bookParkingController
                                                      .emirate.value ==
                                                  "Ajman" ||
                                          bookParkingController.emirate.value ==
                                              "Sharjah" ||
                                          bookParkingController.emirate.value ==
                                              AppData.Khor_Fakkan
                                      ? p0.zone == "..."
                                      : p0.zone ==
                                          bookParkingController.zoneCode.value)
                                  .map((e) => e.hours.toString())
                                  .toSet()
                                  .toList(),
                              stelctedItem:
                                  bookParkingController.duration.value,
                              onchange: (newValue) {
                                bookParkingController.duration.value =
                                    newValue!;

                                if (bookParkingController.emirate.value ==
                                        "Sharjah" ||
                                    bookParkingController.emirate.value ==
                                        "Ajman" ||
                                    bookParkingController.emirate.value ==
                                        AppData.Khor_Fakkan) {
                                  bookParkingController.parkingCost.value =
                                      bookParkingController.zoneCodesEmirate
                                          .lastWhere((element) =>
                                              element.city ==
                                                  bookParkingController
                                                      .emirate.value &&
                                              element.hours ==
                                                  double.parse(
                                                      bookParkingController
                                                          .duration.value))
                                          .totalPrice;
                                } else {
                                  bookParkingController.parkingCost.value =
                                      bookParkingController.zoneCodesEmirate
                                          .lastWhere((element) =>
                                              element.city ==
                                                  bookParkingController
                                                      .emirate.value &&
                                              element.zone ==
                                                  bookParkingController
                                                      .zoneCode.value &&
                                              element.hours ==
                                                  double.parse(
                                                      bookParkingController
                                                          .duration.value))
                                          .totalPrice;
                                }

                                // double.parse(
                                //     AppMethods.extractNumbers(newValue)) *
                                // bookParkingController.fixedCost.value;
                                // contr.update();
                                // setState(() {});
                              },
                            ),
                            Container(
                              decoration:
                                  AppColors.containerDecoration3morecircle,
                              width: Appsize.width(context),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 18),
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Text(
                                "${bookParkingController.parkingCost.value.toStringAsFixed(2)} AED",
                                style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 25),
                              child: Text(
                                bookParkingController.parkingText(),
                                style: TextStyle(
                                    color: AppColors.white, fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            GreenButton(
                              title: "book through sms".tr,
                              onTap: () async {
                                // if (bookParkingController
                                //     .zoneNumber.text.isNotEmpty) {
                                if (bookParkingController.simCards.isEmpty) {
                                  // await bookParkingController
                                  //     .requestPermissions();
                                  await openAppSettings();
                                } else {
                                  ChooseSIM(context);
                                }
                                // }
                                // await bookParkingController
                                // .s("message", ["52563"]);
                                print("object");
                              },
                            ),
                            BlueButton(
                                onTap: () {
                                  Get.back();
                                },
                                title: "cancel".tr)
                          ],
                        ),
                      ),
                      // GetBuilder(
                      //     init: BookParkingController(),
                      //     builder: (co) {
                      //       return IconButton(
                      //           onPressed: () {
                      //             print(co.emirate);
                      //             print(co.zoneCode);
                      //             print(co.duration);
                      //             print(co.zoneNumber.text);
                      //           },
                      //           icon: Icon(Icons.add_shopping_cart_outlined));
                      //     })
                    ],
                  ),
                ),
        ),
      ),
    );
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
                children: bookParkingController.simCards
                    .map((element) => Container(
                          width: Appsize.width(context),
                          child: GestureDetector(
                            onTap: () async {
                              Get.back();
                              bookParkingController.selectedSimSlot.value =
                                  element.slotIndex;
                              await bookParkingController.sendSMS();
                              log(AppMethods.extractNumbers(
                                  bookParkingController.duration.value));
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
}
