import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_parking/View/CarFunctions/Widgets/buttons.dart';
import 'package:smart_parking/View/Dashboard/Vehicles/Models/VehicleModel.dart';
import 'package:smart_parking/View/Dashboard/Vehicles/addVehicle.dart';
import 'package:smart_parking/View/Dashboard/Home/Widget/courlsCardOne.dart';
import 'package:smart_parking/constant/size.dart';

import '../../../constant/appcolors.dart';
import '../../../constant/data.dart';
import 'Controllers/vehicle_Controller.dart';

class VehiclesPage extends StatefulWidget {
  const VehiclesPage({super.key});

  @override
  State<VehiclesPage> createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> {
  final VehicleController vehicleController = Get.put(VehicleController());
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
        child: Column(
          children: [
            Text(
              "MY VEHICLES".tr,
              style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
            // Row(
            //   children: [
            //     SizedBox(
            //       width: 15,
            //     ),
            //     Text(
            //       "make\nprimary".tr.toUpperCase(),
            //       style: TextStyle(
            //           fontSize: 13,
            //           fontWeight: FontWeight.w600,
            //           color: AppColors.white),
            //       textAlign: TextAlign.center,
            //     )
            //   ],
            // ),
            // Builder(
            //   builder: (context) {
            //     List<bool> alldata = [false, false, false];
            //     return Column(

            //     );
            //   },
            // )
            Obx(
              () => Expanded(
                  child: ListView.builder(
                itemCount: vehicleController.myVehicles.length,
                itemBuilder: (context, index) => MyVehicalCard(
                  vehicle: vehicleController.vehicles[index],
                ),
              )),
            ),
            GreenButton(
                onTap: () {
                  Get.to(() => AddVehiclePage());
                },
                title: "add new vehicle".tr),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}

class MyVehicalCard extends StatefulWidget {
  MyVehicalCard({super.key, required this.vehicle});
  Vehicle vehicle;
  @override
  State<MyVehicalCard> createState() => _MyVehicalCardState();
}

class _MyVehicalCardState extends State<MyVehicalCard> {
  VehicleController vehicleController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Checkbox(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            checkColor: AppColors.black,
            fillColor:
                MaterialStateColor.resolveWith((states) => AppColors.white),
            value: widget.vehicle.isPrimary,
            onChanged: (value) {
              // widget.vehicle.isPrimary = value!;
              // setState(() {});
              print("object");
            },
          ),
          CarCardNumber(
            isexpanded: true,
            vehicle: widget.vehicle,
          ),
          Expanded(
            child: SizedBox(
                // width: 5,
                ),
          ),
          BlueButtonSmall(
              onTap: () {
                vehicleController.plateSourceId.value =
                    widget.vehicle.plateSourceId;
                vehicleController.plateCodeId.value =
                    widget.vehicle.plateCodeId;
                // vehicleController.plateType.value = widget.vehicle.plateType;
                vehicleController.platenumber.text = widget.vehicle.plateNumber;
                vehicleController.isprimary.value = widget.vehicle.isPrimary;
                vehicleController.plateid.value = widget.vehicle.id;
                // vehicleController.allPlateType.value =
                //     AppData.plateTypesInEmirates[widget.vehicle.plateSource]!;
                vehicleController.allPlateCode
                    .where((p0) => p0.emirateId == widget.vehicle.plateSourceId)
                    .toList();
                // =
                //     AppData.emiratePlateCodes[widget.vehicle.plateSourceId]!;
                Get.to(() => AddVehiclePage(
                      isupdate: true,
                    ));
              },
              title: "edit".tr.toUpperCase()),
          SizedBox(
            width: 5,
          ),
          BlueButtonSmall(
              onTap: () {
                vehicleController.deleteVehicle(
                    widget.vehicle.id, widget.vehicle.isPrimary);
              },
              title: "delete".tr.toUpperCase()),
        ],
      ),
    );
  }
}
