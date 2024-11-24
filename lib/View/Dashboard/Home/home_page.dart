import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:smart_parking/View/Dashboard/BottomBarController.dart';
import 'package:smart_parking/View/Dashboard/Vehicles/Controllers/vehicle_Controller.dart';
import 'package:smart_parking/constant/appcolors.dart';
import 'package:smart_parking/constant/methods.dart';
import 'package:smart_parking/constant/size.dart';
import 'package:smart_parking/View/Dashboard/Home/Controllers/home_page_Controller.dart';

import 'Widget/courlsCardOne.dart';
import 'Widget/courlsCardThree.dart';
import 'Widget/courlsCardTwo.dart';
import 'Widget/dateCard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  VehicleController vehicleController = Get.put(VehicleController());
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
              GetBuilder(
                  init: HomePageController(),
                  builder: (homepagecontroller) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                homepagecontroller.decressmonth();
                              },
                              child: Container(
                                padding: AppColors.paddingcontainer,
                                decoration: AppColors.containerDecoration,
                                child: Center(
                                  child: Icon(
                                    Ionicons.remove,
                                    color: AppColors.white,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              homepagecontroller.date.toUpperCase(),
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                homepagecontroller.incressmonth();
                              },
                              child: Container(
                                padding: AppColors.paddingcontainer,
                                decoration: AppColors.containerDecoration,
                                child: Center(
                                  child: Icon(
                                    Ionicons.add,
                                    color: AppColors.white,
                                    size: 15,
                                  ),
                                ),
                              ),
                            )
                          ],
                          // ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              DateCard(
                                value: homepagecontroller.ticketsValue.value
                                    .toString(),
                                title: "sms".tr,
                                subtitle: "ticket(s)".tr,
                              ),
                              DateCard(
                                value: homepagecontroller.hoursValue.value
                                    .toString(),
                                title: "time".tr,
                                subtitle: "hour(S)".tr,
                              ),
                              DateCard(
                                value: homepagecontroller.paidValue.value
                                    .toString(),
                                title: "paid".tr,
                                subtitle: "aed".tr,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
//               ElevatedButton(
//                   onPressed: () {
//                     String message1 = '''
//   Confirmation
// PlateNo - C 33333
// PlateSource - Dubai
// TicketNo - 24102612342
// Fee - AED 2.38
// Paid upto - 26-10-2024 06:00 PM''';

//                     String message2 = '''
//   Reminder
// Ticket-709631148
// Plate-DXB A 12002
// will expire on 26/10/24 03:23 PM.
// Extension possible within Zone-123A. Reply with 12002 to extend.''';
//                     DateTime da = AppMethods.getEndDateForTicket(message2)!;
//                     log(da.hour.toString());
//                     log(da.toString());
//                   },
//                   child: Text("data")),
              Obx(
                () => vehicleController.myVehicles.isEmpty
                    ? ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)))),
                        onPressed: () {
                          Get.find<BottomBarController>().onItemTapped(1);
                        },
                        child: Text("Add Vehicle".tr))
                    : carousel.CarouselSlider(
                        options: carousel.CarouselOptions(
                            height: 160.0,
                            initialPage: 0,
                            reverse: false,
                            enableInfiniteScroll: false),
                        // carouselController: CarouselControllerImpl(),
                        items: vehicleController.myVehicles.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return CarouselCardOne(
                                vehicle: i,
                                indexofVehicle:
                                    vehicleController.myVehicles.indexOf(i),
                              );
                            },
                          );
                        }).toList(),
                      ),
              ),
              SizedBox(
                height: 10,
              ),
              GetBuilder<HomePageController>(builder: (controller) {
                return controller.activeTickets.isEmpty
                    ? SizedBox()
                    : Text(
                        "active ticket(s)".tr.toUpperCase(),
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      );
              }),
              SizedBox(
                height: 10,
              ),
              GetBuilder(
                  init: HomePageController(),
                  builder: (controller) {
                    return controller.activeTickets.isEmpty
                        ? SizedBox()
                        : carousel.CarouselSlider(
                            options: carousel.CarouselOptions(
                                height: 160.0,
                                reverse: false,
                                enableInfiniteScroll: false),
                            items: controller.activeTickets.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return CarouselCardTwo(
                                    ticket: i,
                                  );
                                },
                              );
                            }).toList(),
                          );
                  }),
              SizedBox(
                height: 10,
              ),
              GetBuilder<HomePageController>(builder: (controller) {
                return controller.recentTickets
                        .where((p0) =>
                            p0.startTime.month == controller.month.value &&
                            p0.startTime.year == controller.year.value)
                        .isEmpty
                    ? SizedBox()
                    : Text(
                        "recent ticket(s)".tr.toUpperCase(),
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      );
              }),
              SizedBox(
                height: 10,
              ),
              GetBuilder(
                  init: HomePageController(),
                  builder: (controller) {
                    return controller.recentTickets.isEmpty
                        ? SizedBox()
                        : carousel.CarouselSlider(
                            options: carousel.CarouselOptions(
                              height: 180.0,
                              reverse: false,
                              enableInfiniteScroll: false,
                              onPageChanged: (index, reason) {
                                controller.newDurationTikcet.value = 1;
                                controller.update();
                              },
                            ),
                            items: controller.recentTickets
                                .where((p0) =>
                                    p0.startTime.month ==
                                        controller.month.value &&
                                    p0.startTime.year == controller.year.value)
                                .map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return CarouselCardThree(
                                    ticket: i,
                                  );
                                },
                              );
                            }).toList(),
                          );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
