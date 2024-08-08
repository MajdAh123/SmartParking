import 'package:flutter/material.dart';

import '../../../constant/appcolors.dart';
import '../../../constant/size.dart';

class GreenButton extends StatelessWidget {
  const GreenButton({super.key, required this.onTap, required this.title});
  final String title;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: onTap,
        child: Container(
          width: Appsize.width(context),
          decoration: BoxDecoration(
              color: AppColors.green,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: AppColors.seconderyColor)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
          ),
        ),
      ),
    );
  }
}

class BlueButton extends StatelessWidget {
  const BlueButton({super.key, required this.onTap, required this.title});
  final String title;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: onTap,
        child: Container(
          width: Appsize.width(context),
          decoration: BoxDecoration(
              color: AppColors.fourthColor,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: AppColors.seconderyColor)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
          ),
        ),
      ),
    );
  }
}

class BlueButtonSmall extends StatelessWidget {
  const BlueButtonSmall({super.key, required this.onTap, required this.title});
  final String title;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: onTap,
        child: Container(
          // width: Appsize.width(context),
          decoration: BoxDecoration(
              color: AppColors.fourthColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.seconderyColor)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10),
            ),
          ),
        ),
      ),
    );
  }
}
