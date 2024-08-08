import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_parking/View/Dashboard/History/Controllers/historyController.dart';
import 'package:smart_parking/View/Dashboard/Home/Widget/courlsCardOne.dart';
import 'package:smart_parking/View/Dashboard/Vehicles/Models/VehicleModel.dart';
import 'package:smart_parking/constant/appcolors.dart';
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
          title: Text("EMIRATES SMART PARKING"),
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
                            CupertinoIcons.arrow_left_circle_fill,
                            color: AppColors.white,
                            size: 25,
                          )),
                      CarCardNumber(
                          isexpanded: false,
                          vehicle: controller.selectedVehicle!),
                      IconButton(
                          onPressed: () => historyController.incressVehicle(),
                          icon: Icon(
                            CupertinoIcons.arrow_right_circle_fill,
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
                    child: ListView.builder(
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
