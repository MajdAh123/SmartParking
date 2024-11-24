import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_parking/View/CarFunctions/BookParking/Controllers/book_parking_Controller.dart';
import 'package:smart_parking/View/CarFunctions/Model/TicketModel.dart';
import 'package:smart_parking/View/CarFunctions/Widgets/buttons.dart';
import 'package:smart_parking/View/Dashboard/Home/Controllers/home_page_Controller.dart';
import 'package:smart_parking/View/Dashboard/Home/Widget/courlsCardOne.dart';
import 'package:smart_parking/View/Dashboard/bottom_bar.dart';

import '../../../constant/appcolors.dart';
import '../../../constant/data.dart';
import '../../../constant/methods.dart';
import '../../../constant/size.dart';

class ExampleAlarmRingScreen extends StatefulWidget {
  const ExampleAlarmRingScreen(
      {required this.alarmSettings, required this.ticket, super.key});

  final AlarmSettings alarmSettings;
  final Ticket ticket;

  @override
  State<ExampleAlarmRingScreen> createState() => _ExampleAlarmRingScreenState();
}

class _ExampleAlarmRingScreenState extends State<ExampleAlarmRingScreen> {
  @override
  void initState() {
    // Alarm.stop(widget.alarmSettings.id).then((_) => Navigator.pop(context));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: SizedBox(),
          leadingWidth: 5,
          title: Text("EMIRATES SMART PARKING".tr),
          centerTitle: true,
        ),
        body: GetBuilder(
            init: BookParkingController(),
            builder: (controller) {
              return Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Re-Book Parking".tr.toUpperCase(),
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                        height: Appsize.height(context) * .25,
                        padding: AppColors.paddingcontainer,
                        width: Appsize.width(context),
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: AppColors.containerDecoration2,
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
                            //         border: Border.all(
                            //             color: Colors.black, width: 2),
                            //         color: AppColors.white),
                            //     child: Row(
                            //       mainAxisSize: MainAxisSize.min,
                            //       children: [
                            //         SizedBox(
                            //           width: 10,
                            //         ),
                            //         Text(
                            //           controller
                            //               .getVehicleById(widget.ticket.carId)
                            //               .plateCodeId
                            //               .toString(),
                            //           style: TextStyle(
                            //               fontSize: 18,
                            //               fontWeight: FontWeight.bold),
                            //         ),
                            //         SizedBox(
                            //           width: 5,
                            //         ),
                            //         Column(
                            //           children: [
                            //             Text(
                            //               AppData.translateToArabic(controller
                            //                   .getVehicleById(
                            //                       widget.ticket.carId)
                            //                   .plateSourceId
                            //                   .toString()),
                            //               style: TextStyle(
                            //                   height: 1,
                            //                   fontSize: 13,
                            //                   fontWeight: FontWeight.bold),
                            //             ),
                            //             Text(
                            //               controller
                            //                   .getVehicleById(
                            //                       widget.ticket.carId)
                            //                   .plateSourceId
                            //                   .toString(),
                            //               style: TextStyle(
                            //                   fontSize: 13,
                            //                   fontWeight: FontWeight.bold),
                            //             )
                            //           ],
                            //         ),
                            //         SizedBox(
                            //           width: 5,
                            //         ),
                            //         Text(
                            //           controller
                            //               .getVehicleById(widget.ticket.carId)
                            //               .plateNumber,
                            //           style: TextStyle(
                            //               fontSize: 16,
                            //               fontWeight: FontWeight.bold),
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
                                vehicle: Get.find<HomePageController>()
                                    .getVehicleById(widget.ticket.carId)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "City".tr.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.white),
                                    ),
                                    Text(
                                      widget.ticket.emirate.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.white),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "hour(s) used".tr.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.white),
                                    ),
                                    Text(
                                      "${AppMethods.extractNumbers(widget.ticket.duration)} hours"
                                          .toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.white),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "date/time".tr.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.white),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                          style: TextStyle(fontSize: 20),
                                          children: [
                                            TextSpan(
                                              text:
                                                  "${widget.ticket.endTime.hour}:${widget.ticket.endTime.minute}",
                                              style: TextStyle(
                                                  color: AppColors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            WidgetSpan(
                                                baseline:
                                                    TextBaseline.alphabetic,
                                                alignment:
                                                    PlaceholderAlignment.bottom,
                                                child: Text(
                                                  widget.ticket.endTime.hour >=
                                                              0 &&
                                                          widget.ticket.endTime
                                                                  .hour <
                                                              12
                                                      ? 'AM'.tr
                                                      : "PM".tr,
                                                  style: TextStyle(
                                                      fontSize: 8,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors.white),
                                                )),
                                          ]),
                                    ),
                                    Text(
                                      DateFormat('dd/MM/yy')
                                          .format(widget.ticket.endTime),
                                      style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // Text(
                                    //   "dubai".toUpperCase(),
                                    //   style: TextStyle(
                                    //       fontSize: 18,
                                    //       fontWeight: FontWeight.bold,
                                    //       color: AppColors.white),
                                    // ),
                                  ],
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () => controller.descressDurcation(),
                                  child: Container(
                                    decoration: AppColors.containerDecoration3,
                                    padding: AppColors.paddingcontainer,
                                    child: Center(
                                      child: Icon(
                                        Icons.remove,
                                        size: 10,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  "${controller.newDurationTikcet.value} ${"Hr".tr}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.white),
                                ),
                                GestureDetector(
                                  onTap: () => controller.incresDurcation(),
                                  child: Container(
                                    decoration: AppColors.containerDecoration3,
                                    padding: AppColors.paddingcontainer,
                                    child: Center(
                                      child: Icon(
                                        Icons.add,
                                        size: 10,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    Ticket updatedTicket = Ticket(
                                        id: widget.ticket.id,
                                        carId: widget.ticket.carId,
                                        emirate: widget.ticket.emirate,
                                        startTime: DateTime.now(),
                                        endTime: DateTime.now().add(Duration(
                                            hours: controller
                                                .newDurationTikcet.value)),
                                        duration:
                                            "${controller.newDurationTikcet.value} ${"Hr".tr}",
                                        cost:
                                            controller.newDurationTikcet.value *
                                                50,
                                        zoneCode: widget.ticket.zoneCode,
                                        zoneNumber: widget.ticket.zoneNumber);
                                    //ticket;
                                    // updatedTicket.duration =
                                    //     "${_homePage.newDurationTikcet.value} Hr";
                                    // updatedTicket.startTime = DateTime.now();
                                    // updatedTicket.endTime = DateTime.now().add(Duration(
                                    //     hours: int.parse(AppMethods.extractNumbers(
                                    //         updatedTicket.duration))));

                                    BookParkingController
                                        bookParkingController =
                                        Get.find<BookParkingController>();
                                    bookParkingController.SlectedTikcet =
                                        updatedTicket;
                                    bookParkingController.selectedVehicle =
                                        controller.getVehicleById(
                                            widget.ticket.carId);
                                    // updatedTicket = Ticket(
                                    //     id: 0,
                                    //     carId: 0,
                                    //     emirate: "",
                                    //     startTime: DateTime.now(),
                                    //     endTime: DateTime.now(),
                                    //     duration: "",
                                    //     cost: 0,
                                    //     zoneCode: "",
                                    //     zoneNumber: "");
                                    await bookParkingController
                                        .fetchSIMCards()
                                        .then((value) => ChooseSIM(
                                            context, bookParkingController));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: AppColors.green,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            width: 1, color: AppColors.white)),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 35),
                                        child: Text(
                                          "re-book".tr.toUpperCase(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: AppColors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Expanded(child: SizedBox()),
                    BlueButton(
                        onTap: () {
                          Get.offAll(() => BottomBarPage());
                        },
                        title: "Cancel".tr),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              );
            }));
  }

  Future<dynamic> ChooseSIM(
      BuildContext context, BookParkingController bookParkingController) {
    // BookParkingController bookParkingController =
    //     Get.put(BookParkingController());
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
