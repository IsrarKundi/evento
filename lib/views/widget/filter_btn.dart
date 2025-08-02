import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'common_image_view_widget.dart';


class FilterBtn extends StatelessWidget {
  final VoidCallback onTap;
  final bool isbackgroundFilled;
  final double h, w;
  const FilterBtn(
      {super.key,
      required this.onTap,
      this.isbackgroundFilled = true,
      this.h = 45,
      this.w = 45});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: h,
        width: w,
        decoration: BoxDecoration(
            color: isbackgroundFilled ? kGreyColor2 : kTransperentColor,
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: CommonImageView(
            // svgPath: Assets.imagesFilterIcon,
          ),
        ),
      ),
    );
  }
}
