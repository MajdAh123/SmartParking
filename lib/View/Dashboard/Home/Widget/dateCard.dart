import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking/constant/size.dart';

import '../../../../constant/appcolors.dart';

class DateCard extends StatelessWidget {
  const DateCard({
    super.key,
    required this.value,
    required this.title,
    required this.subtitle,
  });
  final String value;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppColors.paddingcontainer,
      decoration: AppColors.containerDecoration2,
      width: Appsize.width(context) * 0.27,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            AutoSizeText(
              value,
              maxFontSize: 18,
              minFontSize: 12,
              maxLines: 1,
              style: TextStyle(
                  // : 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white),
            ),
            Text(subtitle.toUpperCase(),
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey)),
            Text(title.toUpperCase(),
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white)),
          ],
        ),
      ),
    );
  }
}
