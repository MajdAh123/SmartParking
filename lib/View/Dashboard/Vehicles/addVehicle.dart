import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_parking/View/CarFunctions/Widgets/buttons.dart';
import 'package:smart_parking/View/CarFunctions/Widgets/dropDownItems.dart';
import 'package:smart_parking/View/CarFunctions/Widgets/textFiledContiner.dart';
import 'package:smart_parking/View/Dashboard/Vehicles/Models/VehicleModel.dart';
import 'package:smart_parking/constant/data.dart';
import 'package:smart_parking/constant/size.dart';
import '../../../constant/appcolors.dart';
import 'Controllers/vehicle_Controller.dart';

class AddVehiclePage extends StatefulWidget {
  AddVehiclePage({super.key, this.isupdate = false});
  bool isupdate;
  @override
  State<AddVehiclePage> createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  // bool isprimary = true;
  VehicleController _vehicleController = Get.put(VehicleController());
  @override
  void initState() {
    !widget.isupdate ? _vehicleController.platenumber.text = "" : null;
    // TODO: implement initState
    super.initState();
  }

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
        child: GetBuilder(
            init: VehicleController(),
            builder: (controller) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "ADD VEHICLE".tr,
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    DropDownItemWidget(
                      label: "plate source".tr,
                      items: AppData.emirates,
                      stelctedItem: controller.plateSource.value,
                      onchange: (String? newValue) {
                        controller.plateSource.value = newValue!;
                        controller.allPlateType.value =
                            AppData.plateTypesInEmirates[newValue]!;
                        controller.plateType.value = controller.allPlateType[0];
                        controller.allPlateCode.value =
                            AppData.emiratePlateCodes[newValue]!;
                        controller.plateCode.value = controller.allPlateCode[0];
                        controller.update();
                        // setState(() {});
                      },
                    ),
                    DropDownItemWidget(
                      label: "plate type".tr,
                      items: controller.allPlateType,
                      stelctedItem: controller.plateType.value,
                      onchange: (String? newValue) {
                        controller.plateType.value = newValue!;
                        controller.update();
                        // setState(() {});
                      },
                    ),
                    DropDownItemWidget(
                      label: "plate code".tr,
                      items: controller.allPlateCode,
                      stelctedItem: controller.plateCode.value,
                      onchange: (String? newValue) {
                        controller.plateCode.value = newValue!;
                        controller.update();
                        // setState(() {});
                      },
                    ),
                    TextFieldContainer(
                        type: TextInputType.number,
                        label: "plate number".tr,
                        textEditingController: controller.platenumber),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: CheckboxListTile(
                        checkColor: AppColors.black,
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => AppColors.white),
                        value: controller.isprimary.value,
                        onChanged: (value) {
                          if (controller.vehicles.isNotEmpty) {
                            controller.isprimary.value = value!;
                          }
                          setState(() {});
                        },
                        title: Row(
                          children: [
                            Expanded(child: SizedBox()),
                            Text(
                              "set as primary".tr.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GreenButton(
                        onTap: () {
                          Vehicle vehicle = Vehicle(
                              id: widget.isupdate
                                  ? controller.plateid.value
                                  : 0,
                              plateSource: controller.plateSource.value,
                              plateType: controller.plateType.value,
                              plateCode: controller.plateCode.value,
                              plateNumber: controller.platenumber.text,
                              isPrimary: controller.isprimary.value);
                          widget.isupdate
                              ? controller.updateVehicle(vehicle)
                              : controller.addVehicle(vehicle);
                        },
                        title: widget.isupdate ? "update".tr : "add".tr),
                    BlueButton(
                        onTap: () {
                          Get.back();
                        },
                        title: "cancel".tr)
                  ],
                ),
              );
            }),
      ),
    );
  }
}
