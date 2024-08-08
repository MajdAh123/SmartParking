import 'package:flutter/material.dart';

import '../../../../constant/appcolors.dart';

class TextFieldContact extends StatelessWidget {
  const TextFieldContact(
      {super.key,
      required this.label,
      required this.iconData,
      required this.controller,
      required this.textInputType,
      required this.maxLines});
  final String label;
  final IconData iconData;
  final TextEditingController controller;
  final TextInputType textInputType;
  final int maxLines;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.seconderyColor, width: 2),
      ),
      child: TextField(
        maxLines: maxLines,
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
          label: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                    color: AppColors.fourthColor, fontWeight: FontWeight.w500),
              ),
              // SizedBox(
              //   width: 10,
              // ),
              Icon(
                iconData,
                color: AppColors.fourthColor,
              )
            ],
          ),
          border: InputBorder.none,
          // fillColor: AppColors.white,
          // filled: true
        ),
      ),
    );
  }
}
