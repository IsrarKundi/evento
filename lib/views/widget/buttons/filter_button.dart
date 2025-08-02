import 'package:flutter_svg/svg.dart';

import '../../../main_packages.dart';
import '../common_image_view_widget.dart';
import '../my_text_widget.dart';

class FilterButton extends StatelessWidget {
  final Function()? onTap;
  final String iconPath, label;
  final String? svgPath;

  const FilterButton({super.key,
    this.onTap,
    this.iconPath = Assets.imagesMenu,
    this.label = '', this.svgPath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          // svgPath!=null?
          //     CommonImageView(
          //       svgPath: svgPath,
          //     ):
          // CommonImageView(

          //   imagePath: iconPath,
          // ),
          SvgPicture.asset(svgPath?? ""),
          const SizedBox(
            width: 5,
          ),
          MyText(
            text: label,
            size: 14,
            weight: FontWeight.w400,
          )
        ],
      ),
    );
  }
}
