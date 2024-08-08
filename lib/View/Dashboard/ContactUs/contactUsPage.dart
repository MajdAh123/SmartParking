import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_parking/constant/appcolors.dart';
import 'package:smart_parking/constant/size.dart';

import 'Widgets/textFieldContact.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController messageController = TextEditingController();
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              TextFieldContact(
                label: "full name".tr,
                iconData: Icons.person_2_rounded,
                controller: nameController,
                textInputType: TextInputType.emailAddress,
                maxLines: 1,
              ),
              TextFieldContact(
                label: "email".tr,
                iconData: Icons.email_rounded,
                controller: emailController,
                textInputType: TextInputType.emailAddress,
                maxLines: 1,
              ),
              TextFieldContact(
                label: "message".tr,
                iconData: Icons.edit,
                controller: messageController,
                textInputType: TextInputType.emailAddress,
                maxLines: 6,
              ),
              SizedBox(
                height: 70,
              ),
              // ElevatedButton(onPressed: () {}, child: Text("data")),
              Container(
                width: Appsize.width(context) * 0.5,
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    border:
                        Border.all(color: AppColors.seconderyColor, width: 1),
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.green),
                child: Center(
                    child: Text(
                  "Send".tr.toUpperCase(),
                  style: TextStyle(
                      color: AppColors.white, fontWeight: FontWeight.bold),
                )),
              ),
              SizedBox(
                height: 70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
