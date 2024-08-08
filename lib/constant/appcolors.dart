import 'package:flutter/material.dart';

class AppColors {
  static Color primeryColor = const Color(0xff0167bb);
  static Color seconderyColor = const Color(0xff58a1df);
  static Color theredColor = const Color(0xff01346b);
  static Color fourthColor = const Color.fromARGB(255, 0, 69, 143);
  static Color white = Colors.white;
  static Color grey = Colors.grey;
  static Color grey300 = Colors.grey[300]!;
  static Color grey600 = Colors.grey[600]!;
  static Color grey800 = Colors.grey[800]!;
  static Color green = const Color(0xff6aad05);
  static Color black = const Color(0xff000000);
  static Color red = Color.fromARGB(255, 207, 12, 18);
  static Border border = Border.all(width: 1, color: AppColors.seconderyColor);
  static BoxDecoration containerDecoration = BoxDecoration(
      color: AppColors.fourthColor,
      borderRadius: BorderRadius.circular(5),
      border: Border.all(width: 1, color: seconderyColor));
  static BoxDecoration containerDecoration2 = BoxDecoration(
      color: AppColors.fourthColor,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(width: 2, color: seconderyColor));
  static BoxDecoration containerDecoration3 = BoxDecoration(
      color: AppColors.primeryColor,
      borderRadius: BorderRadius.circular(5),
      border: Border.all(width: 1, color: seconderyColor));
  static BoxDecoration containerDecoration3morecircle = BoxDecoration(
      color: AppColors.primeryColor,
      borderRadius: BorderRadius.circular(25),
      border: Border.all(width: 1, color: seconderyColor));

  static EdgeInsetsGeometry paddingcontainer = EdgeInsets.all(5);
}
