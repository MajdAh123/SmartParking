import 'package:carousel_slider/carousel_slider.dart';
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
      Get.put(BookParkingController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        leadingWidth: 5,
        title: Text("EMIRATES SMART PARKING"),
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
                      CarouselSlider(
                        options: CarouselOptions(
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
                              label: "EMIRATE".tr,
                              items: AppData.emirates,
                              stelctedItem: bookParkingController.emirate.value,
                              onchange: (String? newValue) {
                                bookParkingController.emirate.value = newValue!;
                                bookParkingController.zoneCodesEmirate.value =
                                    AppData.emirateParkingZones[newValue]!;
                                bookParkingController.zoneCode.value =
                                    bookParkingController
                                        .zoneCodesEmirate.first;
                                bookParkingController.duration.value =
                                    AppData.durationsParking.first;
                                bookParkingController.parkingCost.value =
                                    double.parse(AppMethods.extractNumbers(
                                            bookParkingController
                                                .duration.value)) *
                                        bookParkingController.fixedCost.value;
                                // setState(() {});
                              },
                            ),
                            if (![AppData.Ajman, AppData.Sharjah]
                                .contains(bookParkingController.emirate.value))
                              DropDownItemWidget(
                                label: "zone code".tr,
                                items: bookParkingController.zoneCodesEmirate,
                                stelctedItem:
                                    bookParkingController.zoneCode.value,
                                onchange: (String? newValue) {
                                  bookParkingController.zoneCode.value =
                                      newValue!;

                                  // setState(() {});
                                },
                              ),
                            if (![AppData.Ajman, AppData.Sharjah]
                                .contains(bookParkingController.emirate.value))
                              TextFieldContainer(
                                  label: "zone number".tr,
                                  type: TextInputType.number,
                                  textEditingController:
                                      bookParkingController.zoneNumber),
                            DropDownItemWidget(
                              dropIconColor:
                                  bookParkingController.emirate.value !=
                                          AppData.Ajman
                                      ? AppColors.black
                                      : Colors.transparent,
                              isEnable: bookParkingController.emirate.value !=
                                  AppData.Ajman,
                              label: "Duration".tr,
                              items: AppData.durationsParking,
                              stelctedItem:
                                  bookParkingController.duration.value,
                              onchange: (String? newValue) {
                                bookParkingController.duration.value =
                                    newValue!;
                                bookParkingController
                                    .parkingCost.value = double.parse(
                                        AppMethods.extractNumbers(newValue)) *
                                    bookParkingController.fixedCost.value;
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
                                "${bookParkingController.parkingCost} AED",
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
                                "Parking timings in selected zone is 8:00 AM to 10:00 PM,(Sat - Thu). Free parking on fridays and public holidays (maximum time allowed is 4 hours)"
                                    .tr,
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
