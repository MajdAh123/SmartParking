import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_parking/View/Dashboard/History/Controllers/historyController.dart';
import 'package:smart_parking/View/Dashboard/Home/Widget/courlsCardOne.dart';
import 'package:smart_parking/View/Dashboard/Vehicles/Models/VehicleModel.dart';
import 'package:smart_parking/constant/appcolors.dart';
import 'package:smart_parking/logale/locale_Cont.dart';
import 'Widget/historyCard.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  HistoryController historyController = Get.put(HistoryController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: SizedBox(),
          leadingWidth: 5,
          title: Text("EMIRATES SMART PARKING".tr),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Text(
              "parking history".tr.toUpperCase(),
              style: TextStyle(
                  fontSize: 20,
                  color: AppColors.white,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 15,
            ),
            GetBuilder(
                init: HistoryController(),
                builder: (controller) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () => historyController.descressVehicle(),
                          icon: Icon(
                            Get.find<MyLocaleController>().lan.value == "en"
                                ? CupertinoIcons.arrow_left_circle_fill
                                : CupertinoIcons.arrow_right_circle_fill,
                            color: AppColors.white,
                            size: 25,
                          )),
                      CarCardNumber(
                          isexpanded: false,
                          vehicle: controller.selectedVehicle!),
                      IconButton(
                          onPressed: () => historyController.incressVehicle(),
                          icon: Icon(
                            Get.find<MyLocaleController>().lan.value == "en"
                                ? CupertinoIcons.arrow_right_circle_fill
                                : CupertinoIcons.arrow_left_circle_fill,
                            color: AppColors.white,
                            size: 25,
                          )),
                    ],
                  );
                }),
            GetBuilder(
                init: HistoryController(),
                builder: (controller) {
                  return Expanded(
                    child: controller.vehicleTickets.isEmpty
                        ? Column(
                            children: [
                              SizedBox(
                                height: 200,
                              ),
                              Text(
                                "No data found..!".tr,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white),
                              ),
                            ],
                          )
                        : ListView.builder(
                            itemCount: controller.vehicleTickets.length,
                            itemBuilder: (context, index) {
                              return HistoryCard(
                                ticket: controller.vehicleTickets[index],
                              );
                            },
                          ),
                  );
                }),
          ],
        ));
  }
}
