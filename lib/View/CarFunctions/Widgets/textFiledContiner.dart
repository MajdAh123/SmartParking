// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_parking/View/CarFunctions/Reminder/controllers/reminderController.dart';
import '../../../constant/appcolors.dart';
import 'package:intl/intl.dart';

class TextFieldContainer extends StatefulWidget {
  TextFieldContainer(
      {super.key,
      required this.label,
      required this.textEditingController,
      this.type = TextInputType.text});
  final String label;
  final TextEditingController textEditingController;
  TextInputType type;

  @override
  State<TextFieldContainer> createState() => _TextFieldContainerState();
}

class _TextFieldContainerState extends State<TextFieldContainer> {
  // DateTime selectedDateTime = DateTime.now();

  Future<void> _selectDateTime(BuildContext context) async {
    ReminderController reminderController = Get.put(ReminderController());
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: reminderController.reminderMeON,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(reminderController.reminderMeON),
      );

      if (pickedTime != null) {
        setState(() {
          reminderController.reminderMeON = DateTime(picked.year, picked.month,
              picked.day, pickedTime.hour, pickedTime.minute);

          widget.textEditingController.text = DateFormat('yyyy/MM/dd HH:mm')
              .format(reminderController.reminderMeON);
        });
      }
    }
  }

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
              widget.label.toUpperCase(),
              style: TextStyle(
                  color: AppColors.grey600,
                  fontSize: 12,
                  height: 0.1,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 40,
            child: TextField(
              style: TextStyle(fontWeight: FontWeight.bold),
              keyboardType: widget.type,
              readOnly: widget.type == TextInputType.datetime,
              onTap: () => widget.type == TextInputType.datetime
                  ? _selectDateTime(context)
                  : null,
              controller: widget.textEditingController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: widget.type == TextInputType.datetime
                      ? Icon(Icons.date_range_rounded)
                      : SizedBox(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 2, horizontal: 10)),
            ),
          )
        ],
      ),
    );
  }
}
