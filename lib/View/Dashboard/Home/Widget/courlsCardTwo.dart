import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_parking/View/CarFunctions/Model/TicketModel.dart';
import 'package:smart_parking/View/Dashboard/Home/Controllers/home_page_Controller.dart';
import 'package:smart_parking/View/Dashboard/Vehicles/Controllers/vehicle_Controller.dart';
import 'package:smart_parking/constant/methods.dart';
import 'package:smart_parking/logale/locale_Cont.dart';

import '../../../../constant/appcolors.dart';
import '../../../../constant/data.dart';
import '../../../../constant/size.dart';
import 'courlsCardOne.dart';

class CarouselCardTwo extends StatelessWidget {
  final HomePageController _homePage = Get.put(HomePageController());
  final Ticket ticket;
  CarouselCardTwo({Key? key, required this.ticket}) : super(key: key) {
    _homePage.calculateRemainingTime(ticket.endTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: AppColors.paddingcontainer,
        width: Appsize.width(context),
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Container(
            //   padding: EdgeInsets.all(2),
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(4),
            //       color: AppColors.white),
            //   child: Container(
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(4),
            //         border: Border.all(color: Colors.black, width: 2),
            //         color: AppColors.white),
            //     child: Row(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         SizedBox(
            //           width: 10,
            //         ),
            //         Text(
            //           _homePage
            //               .getVehicleById(ticket.carId)
            //               .plateCodeId
            //               .toString(),
            //           style:
            //               TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //         ),
            //         SizedBox(
            //           width: 5,
            //         ),
            //         Column(
            //           children: [
            //             Text(
            //               Get.find<MyLocaleController>().lan.value == "en"
            //                   ? Get.find<VehicleController>()
            //                       .allPlateSource
            //                       .lastWhere((element) =>
            //                           _homePage
            //                               .getVehicleById(ticket.carId)
            //                               .plateSourceId ==
            //                           element.id)
            //                       .cityEn
            //                   : Get.find<VehicleController>()
            //                       .allPlateSource
            //                       .lastWhere((element) =>
            //                           _homePage
            //                               .getVehicleById(ticket.carId)
            //                               .plateSourceId ==
            //                           element.id)
            //                       .cityAr,
            //               style: TextStyle(
            //                   height: 1,
            //                   fontSize: 13,
            //                   fontWeight: FontWeight.bold),
            //             ),
            //             Text(
            //               Get.find<VehicleController>()
            //                   .allPlateSource
            //                   .lastWhere((element) =>
            //                       _homePage
            //                           .getVehicleById(ticket.carId)
            //                           .plateSourceId ==
            //                       element.id)
            //                   .code,
            //               style: TextStyle(
            //                   fontSize: 13, fontWeight: FontWeight.bold),
            //             )
            //           ],
            //         ),
            //         SizedBox(
            //           width: 5,
            //         ),
            //         Text(
            //           _homePage.getVehicleById(ticket.carId).plateNumber,
            //           style:
            //               TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            //         ),
            //         SizedBox(
            //           width: 10,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            CarCardNumber(
                isexpanded: true,
                vehicle: _homePage.getVehicleById(ticket.carId)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      "emirate".tr.toUpperCase(),
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      ticket.emirate.toUpperCase(),
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "expires at".tr.toUpperCase(),
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    RichText(
                      text: TextSpan(style: TextStyle(fontSize: 20), children: [
                        TextSpan(
                          text:
                              "${ticket.endTime.hour > 12 ? ticket.endTime.hour - 12 : ticket.endTime.hour}:${ticket.endTime.minute}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        WidgetSpan(
                            baseline: TextBaseline.alphabetic,
                            alignment: PlaceholderAlignment.bottom,
                            child: Text(
                              ticket.endTime.hour >= 0 &&
                                      ticket.endTime.hour < 12
                                  ? 'AM'.tr
                                  : "PM".tr,
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                            )),
                      ]),
                    ),
                    // Text(
                    //   "sharjah".toUpperCase(),
                    //   style:
                    //       TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    // ),
                  ],
                ),
                GetBuilder(
                    init: HomePageController(),
                    builder: (_home) {
                      String formattedRemainingTime = DateFormat.Hms().format(
                        DateTime.utc(
                            0,
                            0,
                            0,
                            _homePage.remainingTime.value.inHours.remainder(60),
                            _homePage.remainingTime.value.inMinutes
                                .remainder(60),
                            _homePage.remainingTime.value.inSeconds
                                .remainder(60)),
                      );
                      return Column(
                        children: [
                          Text(
                            "remaining time".tr.toUpperCase(),
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            formattedRemainingTime.toUpperCase(),
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppColors.red),
                          ),
                        ],
                      );
                    }),
              ],
            ),
            // SizedBox(
            //   height: 10,
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.grey300,
                ),
                padding: AppColors.paddingcontainer,
                child: Center(
                  child: Text(
                    "extend ticket".tr.toUpperCase(),
                    style: TextStyle(
                        color: AppColors.grey, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
