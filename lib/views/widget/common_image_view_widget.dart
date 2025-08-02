import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_colors.dart';


class CommonImageView extends StatelessWidget {
// ignore_for_file: must_be_immutable
  String? url;
  String? imagePath;
  String? svgPath;
  File? file;
  double? height;
  double? width;
  double? radius;
  final BoxFit fit;
  final String placeHolder;
  Color? svgColor;
  Color? imageColor;

  CommonImageView({
    this.url,
    this.imagePath,
    this.svgPath,
    this.file,
    this.height,
    this.width,
    this.radius = 0.0,
    this.fit = BoxFit.cover,
    this.placeHolder = 'assets/images/no-image-icon.png',
    this.svgColor,
    this.imageColor,
  });

  @override
  Widget build(BuildContext context) {
    return _buildImageView();
  }

  Widget _buildImageView() {
    if (svgPath != null && svgPath!.isNotEmpty) {
      return GestureDetector(
        child: Container(
          height: height,
          width: width,
          color: Colors.grey.withOpacity(0.1),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius!),
            child: SvgPicture.asset(
              svgPath!,
              height: height,
              width: width,
              fit: fit,
              color: svgColor,
            ),
          ),
        ),
      );
    } else if (file != null && file!.path.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius!),
        child: Image.file(
          file!,
          height: height,
          width: width,
          fit: fit,
        ),
      );
    } else if (url != null && url!.isNotEmpty) {
      return Container(
        height: height,
        width: width,
      decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),

        borderRadius: BorderRadius.circular(radius!),
      ),
        child: ClipRRect(
          
          borderRadius: BorderRadius.circular(radius!),
          child: CachedNetworkImage(
            height: height,
            width: width,
            fit: fit,
            imageUrl: url!,
            placeholder: (context, url) => Container(
              height: 23,
              width: 23,
              child: Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  // child: CircularProgressIndicator(
                  //   color: kSecondaryColor,
                  //   strokeWidth: 2,
                  //   backgroundColor: Colors.grey.shade100,
                  // ),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Image.asset(
              placeHolder,
              height: height,
              width: width,
              fit: fit,
            ),
          ),
        ),
      );
    } else if (imagePath != null && imagePath!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius!),
        child: Image.asset(
          imagePath!,
          height: height,
          width: width,
          fit: fit,
          color: imageColor,
        ),
      );
    }
    return SizedBox();
  }
}
