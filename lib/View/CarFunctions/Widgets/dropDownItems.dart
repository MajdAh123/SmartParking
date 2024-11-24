import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_parking/constant/size.dart';
import '../../../constant/appcolors.dart';

class DropDownItemWidget extends StatelessWidget {
  const DropDownItemWidget(
      {super.key,
      required this.label,
      required this.items,
      required this.stelctedItem,
      required this.onchange,
      this.isEnable = true,
      this.dropIconColor = Colors.black});
  final String label;
  final List items;
  final String stelctedItem;
  final void Function(dynamic) onchange;
  final bool isEnable;
  final Color dropIconColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: AppColors.white, borderRadius: BorderRadius.circular(25)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                  color: AppColors.grey600,
                  fontSize: 12,
                  height: 0.1,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 40,
            child: IgnorePointer(
              ignoring: !isEnable, // Disables interaction when needed
              child: DropdownButton(
                menuMaxHeight: Appsize.height(context) * 0.5,
                isExpanded: true,
                iconSize: 30,
                iconDisabledColor: dropIconColor,
                iconEnabledColor: dropIconColor,
                padding: EdgeInsets.zero,
                underline: SizedBox(), // Removes the underline
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),

                // Set value to null by default if nothing is selected
                value: stelctedItem.isEmpty ? null : stelctedItem,
                hint: Text(
                  "Select an option".tr, // Hint text when nothing is selected
                  style: TextStyle(color: AppColors.black),
                ),

                onChanged: onchange,

                // Populate the dropdown items
                items: items.map<DropdownMenuItem>((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
