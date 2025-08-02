import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';





class CustomDialog extends StatelessWidget {
  final Widget child;
  final double? horizontalMargin, height;
  const CustomDialog({
    super.key,
    required this.child,
    this.horizontalMargin = 32,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalMargin!),
            child: Stack(
              children: [
                Container(
                  height: height,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: child,
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.cancel_outlined)
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
