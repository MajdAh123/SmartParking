import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_parking/View/CarFunctions/Model/TicketModel.dart';
import 'package:smart_parking/constant/methods.dart';

import '../../../../constant/appcolors.dart';
import '../../../../constant/size.dart';
import '../../../CarFunctions/BookParking/Controllers/book_parking_Controller.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({super.key, required this.ticket});
  final Ticket ticket;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 5),
        width: Appsize.width(context),
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
        decoration: AppColors.containerDecoration2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Reservation".tr.toUpperCase(),
              style: TextStyle(
                  color: AppColors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Text(
                      "emirate".tr.toUpperCase(),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white),
                    ),
                    Text(
                      ticket.emirate.toUpperCase(),
                      style: TextStyle(
                          fontSize: 12,
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
                      "${AppMethods.extractNumbers(ticket.duration)} hours"
                          .toUpperCase(),
                      style: TextStyle(
                          fontSize: 12,
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
                      text: TextSpan(style: TextStyle(fontSize: 20), children: [
                        TextSpan(
                          text:
                              "${ticket.endTime.hour > 12 ? ticket.endTime.hour - 12 : ticket.endTime.hour}:${ticket.endTime.minute}",
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        WidgetSpan(
                            baseline: TextBaseline.alphabetic,
                            alignment: PlaceholderAlignment.bottom,
                            child: Text(
                              ticket.endTime.hour >= 0 &&
                                      ticket.endTime.hour < 12
                                  ? ' AM'.tr
                                  : " PM".tr,
                              style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white),
                            )),
                      ]),
                    ),
                    Text(
                      DateFormat('dd/MM/yy').format(ticket.endTime),
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 12,
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
                ),
                Column(
                  children: [
                    Text(
                      "amount".tr.toUpperCase(),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white),
                    ),
                    RichText(
                      text: TextSpan(style: TextStyle(fontSize: 20), children: [
                        TextSpan(
                          text: ticket.cost.toString(),
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        WidgetSpan(
                            baseline: TextBaseline.ideographic,
                            alignment: PlaceholderAlignment.aboveBaseline,
                            child: Text(
                              ' aed'.tr.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white),
                            )),
                      ]),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    Ticket updatedTicket = Ticket(
                        id: ticket.id,
                        carId: ticket.carId,
                        emirate: ticket.emirate,
                        startTime: DateTime.now(),
                        endTime: DateTime.now().add(Duration(
                            hours: int.parse(
                                AppMethods.extractNumbers(ticket.duration)))),
                        duration: ticket.duration,
                        cost: ticket.cost,
                        zoneCode: ticket.zoneCode,
                        zoneNumber: ticket.zoneNumber);
                    // widget.ticket;
                    // updatedTicket.duration =
                    //     "${_homePage.newDurationTikcet.value} Hr";
                    // updatedTicket.startTime = DateTime.now();
                    // updatedTicket.endTime = DateTime.now().add(Duration(
                    //     hours: int.parse(AppMethods.extractNumbers(
                    //         updatedTicket.duration))));

                    BookParkingController bookParkingController =
                        Get.put(BookParkingController());
                    bookParkingController.SlectedTikcet = updatedTicket;
                    bookParkingController.selectedVehicle =
                        bookParkingController.getVehicleById(ticket.carId);
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
                    await bookParkingController.fetchSIMCards().then(
                        (value) => ChooseSIM(context, bookParkingController));
                  },
                  child: Container(
                    width: Appsize.width(context) * .75,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: AppColors.green,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 1, color: AppColors.white)),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
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
                )
              ],
            )
          ],
        ));
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
