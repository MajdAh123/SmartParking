import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_parking/View/SplashContoller.dart';
import 'package:smart_parking/constant/appcolors.dart';
import 'package:smart_parking/constant/size.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primeryColor,
      body: Container(
        width: Appsize.width(context),
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo.png"),
              SizedBox(
                height: 20,
              ),
              if (controller.appLanguage.value == "")
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(30),
                      hoverColor: MaterialStateColor.resolveWith(
                          (states) => Colors.transparent),
                      onTap: () {
                        controller.changLang("en");
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        width: Appsize.width(context) * 0.35,
                        decoration: BoxDecoration(
                            color: AppColors.theredColor,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                                width: 1, color: AppColors.seconderyColor)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset(
                              "assets/images/en.png",
                              width: 30,
                            ),
                            Text(
                              "English",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    if (controller.appLanguage.value == "")
                      InkWell(
                        borderRadius: BorderRadius.circular(30),
                        hoverColor: MaterialStateColor.resolveWith(
                            (states) => Colors.transparent),
                        onTap: () {
                          controller.changLang("ar");
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          width: Appsize.width(context) * 0.35,
                          decoration: BoxDecoration(
                              color: AppColors.theredColor,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                  width: 1, color: AppColors.seconderyColor)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "عربي",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              Image.asset(
                                "assets/images/ar.png",
                                width: 30,
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
