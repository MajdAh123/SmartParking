import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_parking/Models/PlateSource.dart';
import 'package:smart_parking/View/CarFunctions/Widgets/buttons.dart';
import 'package:smart_parking/View/CarFunctions/Widgets/dropDownItems.dart';
import 'package:smart_parking/View/CarFunctions/Widgets/textFiledContiner.dart';
import 'package:smart_parking/View/Dashboard/Vehicles/Models/VehicleModel.dart';
import 'package:smart_parking/constant/data.dart';
import 'package:smart_parking/constant/size.dart';
import 'package:smart_parking/logale/locale_Cont.dart';
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
        title: Text("EMIRATES SMART PARKING".tr),
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
                      // items: controller.allPlateSource,
                      items: controller.allPlateSource.map((plateSource) {
                        return Get.find<MyLocaleController>().lan.value == "en"
                            ? plateSource.cityEn
                            : plateSource.cityAr; // Return cityEn as a string
                      }).toList(),
                      stelctedItem: controller.plateSourceId.value == 0
                          ? ""
                          : Get.find<MyLocaleController>().lan.value == "en"
                              ? controller.allPlateSource
                                  .where((p0) =>
                                      p0.id == controller.plateSourceId.value)
                                  .toList()
                                  .first
                                  .cityEn
                              : controller.allPlateSource
                                  .where((p0) =>
                                      p0.id == controller.plateSourceId.value)
                                  .toList()
                                  .first
                                  .cityAr,
                      onchange: (newValue) {
                        controller.plateSourceId.value =
                            Get.find<MyLocaleController>().lan.value == "en"
                                ? controller.allPlateSource
                                    .where((p0) => p0.cityEn == newValue)
                                    .toList()
                                    .first
                                    .id
                                : controller.allPlateSource
                                    .where((p0) => p0.cityAr == newValue)
                                    .toList()
                                    .first
                                    .id;
                        // controller.allPlateType.value =
                        //     AppData.plateTypesInEmirates[newValue]!;
                        // controller.plateType.value = "";
                        // controller.allPlateCode.value = [];
                        controller.plateCodeId.value = 0;
                        controller.update();
                        // setState(() {});
                      },
                    ),
                    // DropDownItemWidget(
                    //   label: "plate type".tr,
                    //   items: controller.allPlateType,
                    //   stelctedItem: controller.plateType.value,
                    //   onchange: (String? newValue) {
                    //     controller.plateType.value = newValue!;
                    //     controller.allPlateCode.value = AppData
                    //         .emiratePlateCodes[controller.plateSource.value]!;
                    //     controller.update();
                    //     // setState(() {});
                    //   },
                    // ),
                    DropDownItemWidget(
                      label: "plate code".tr,
                      items: controller.plateSourceId.value == 0
                          ? []
                          : controller.allPlateCode
                              .where((p0) =>
                                  p0.emirateId ==
                                  controller.plateSourceId.value)
                              .map((platecode) {
                              return Get.find<MyLocaleController>().lan.value ==
                                      "en"
                                  ? platecode.codeEn
                                  : platecode.codeAr;
                            }).toList(),
                      stelctedItem: controller.plateCodeId.value == 0
                          ? ""
                          : Get.find<MyLocaleController>().lan.value == "en"
                              ? controller.allPlateCode
                                  .where((p0) =>
                                      p0.id == controller.plateCodeId.value)
                                  .toList()
                                  .first
                                  .codeEn
                              : controller.allPlateCode
                                  .where((p0) =>
                                      p0.id == controller.plateCodeId.value)
                                  .toList()
                                  .first
                                  .codeAr,

                      //  controller.plateCodeId.value,
                      onchange: (newValue) {
                        controller.checkValidation();

                        // controller.plateCodeId.value = newValue!;
                        controller.plateCodeId.value =
                            Get.find<MyLocaleController>().lan.value == "en"
                                ? controller.allPlateCode
                                    .where((p0) =>
                                        p0.codeEn == newValue &&
                                        p0.emirateId ==
                                            controller.plateSourceId.value)
                                    .toList()
                                    .first
                                    .id
                                : controller.allPlateCode
                                    .where((p0) =>
                                        p0.codeAr == newValue &&
                                        p0.emirateId ==
                                            controller.plateSourceId.value)
                                    .toList()
                                    .first
                                    .id;
                        log(controller.plateCodeId.value.toString());
                        log(controller.plateSourceId.value.toString());
                        controller.update();
                        // setState(() {});
                      },
                    ),
                    TextFieldContainer(
                        type: TextInputType.number,
                        label: "plate number".tr,
                        textEditingController: controller.platenumber),
                    Directionality(
                      textDirection:
                          Get.find<MyLocaleController>().lan.value == "en"
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                      child: CheckboxListTile(
                        checkColor: AppColors.black,
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => AppColors.white),
                        value: controller.isprimary.value,
                        onChanged: (value) {
                          controller.checkValidation();
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
                          if (controller.checkValidation()) {
                            Vehicle vehicle = Vehicle(
                                id: widget.isupdate
                                    ? controller.plateid.value
                                    : 0,
                                plateSourceId: controller.plateSourceId.value,
                                // plateType: controller.plateType.value,
                                plateCodeId: controller.plateCodeId.value,
                                plateNumber: controller.platenumber.text,
                                isPrimary: controller.isprimary.value);
                            widget.isupdate
                                ? controller.updateVehicle(vehicle)
                                : controller.addVehicle(vehicle);
                          } else {
                            Get.snackbar(
                                "Error".tr, "All fields is required".tr,
                                backgroundColor: AppColors.red);
                          }
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
