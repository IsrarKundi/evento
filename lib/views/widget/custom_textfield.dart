import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_fonts.dart';
import 'my_text_widget.dart';


// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  TextEditingController? controller;
  final double radius;
  final bool isRequired;
  final double borderRadius;
  final Color? borderColor;
  final double borderWidth;
  final Color focusedBorderColor;
  final double focusedBorderWidth;
  final Color? outlineBorderColor;
  final double outlineBorderWidth;
  final String hintText;
  final double hintTextFontSize;
  final Color hintTextFontColor;
  final bool filled;
  final Color? backgroundColor;
  final double contentPaddingLeft;
  final double contentPaddingRight;
  final double contentPaddingBottom;
  final double contentPaddingTop;
  final double left;
  final double right;
  final double top;
  final double bottom;
  final bool obscureText;
  final double iconScale;
  final bool havePrefixIcon;
  final bool haveSuffixIcon;
  final String? labelText;
  final bool isUseLebelText;
  final Color lableColor;
  final Color txtColor;
  final bool enabled;
  final Widget? preffixWidget, suffixWidget;
  final GestureTapCallback? onSuffixTap;
  final VoidCallback? onTextFieldTap;
  final bool textFieldEnable, readOnly;
  final double height;
  FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;

  //final bool needSvgInPrefix;

  CustomTextField({
    super.key,
    this.controller,
    this.radius = 10,
    this.enabled = true,
    this.suffixWidget,
    this.preffixWidget,
    this.onSuffixTap,
    this.borderRadius = 0,
    this.borderColor,
    this.borderWidth = 0,
    this.focusedBorderColor = kSecondaryColor,
    this.focusedBorderWidth = 1,
    this.outlineBorderColor,
    this.outlineBorderWidth = 1,
    this.hintText = 'Hint here',
    this.hintTextFontColor = kBlackColor1,
    this.hintTextFontSize = 12,
    this.filled = true,
    this.backgroundColor,
    this.contentPaddingLeft = 22,
    this.contentPaddingRight = 0,
    this.contentPaddingBottom = 0,
    this.contentPaddingTop = 0,
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
    this.haveSuffixIcon = false,
    this.obscureText = false,
    this.iconScale = 4,
    this.havePrefixIcon = false,
    this.labelText,
    this.isUseLebelText = true,
    this.lableColor = kBlackColor1,
    this.txtColor = kBlackColor1,
    this.onTextFieldTap,
    this.textFieldEnable = true,
    this.readOnly = false,
    this.height = 45,
    this.validator,
    this.onChanged,  this.isRequired=false, this.keyboardType,
    //this.needSvgInPrefix = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (isUseLebelText == true)
              ? Row(
                children: [
                  MyText(
                    paddingBottom: 7,
                    text: labelText ?? "lebel Text Here",
                    size: 14,
                    weight: FontWeight.w600,
                    color: kBlackColor1,
                  ),
                  MyText(
                    paddingBottom: 7,
                    text: isRequired ? "*":"",
                    size: 12,
                    weight: FontWeight.w500,
                    color: kTertiaryColor,
                  ),
                ],
              )
              : SizedBox(),
          Container(
            // height: height,
            child: TextFormField(
              keyboardType: keyboardType,
                onChanged: onChanged,
                controller: controller,
                obscureText: obscureText,
                readOnly: readOnly,
                enableInteractiveSelection: textFieldEnable,
                onTap: onTextFieldTap ?? null,
                cursorColor: kSecondaryColor,
                enabled: enabled,

                //onChanged: onChanged,
                style: TextStyle(
                  color: kBlackColor1,
                  // txtColor,
                ),
                decoration: InputDecoration(
                  focusedErrorBorder: outlineInputBorderDecoration(
                      r: radius, borderClr: kTertiaryColor, width: 1.5),
                  errorBorder: outlineInputBorderDecoration(
                      r: radius,
                      borderClr: kLightRedColor,
                      width: outlineBorderWidth),
                  errorStyle: TextStyle(fontSize: 9),

                  prefixIcon: (havePrefixIcon == false)
                      ? null
                      : Container(
                          width: 40,
                          child: Center(child: preffixWidget),
                        ),
                  suffixIcon: (haveSuffixIcon == false)
                      ? null
                      : Container(
                          child: suffixWidget,
                        ),
                  filled: filled,
                  fillColor: backgroundColor ?? kWhiteColor,
                  hintText: hintText,
                  hintStyle: TextStyle(
                      color: kGreyColor1,
                      //hintTextFontColor.withOpacity(0.5),
                      fontSize: hintTextFontSize,
                      fontWeight: FontWeight.w400,
                      fontFamily: AppFonts.Poppins),
                  border: outlineInputBorderDecoration(
                      r: borderRadius,
                      borderClr: borderColor ?? kBlackColor1,
                      width: borderRadius),
                  focusedBorder: outlineInputBorderDecoration(
                      r: radius,
                      borderClr: focusedBorderColor,
                      width: focusedBorderWidth),
                  enabledBorder: outlineInputBorderDecoration(
                      r: radius,
                      borderClr:
                          outlineBorderColor ?? kBlackColor1,
                      width: outlineBorderWidth),
                  // disabledBorder: outlineInputBorderDecoration(
                  //     r: radius,
                  //     borderClr: outlineBorderColor,
                  //     width: outlineBorderWidth),
                  contentPadding: EdgeInsets.only(
                      left: contentPaddingLeft,
                      bottom: contentPaddingBottom,
                      top: contentPaddingTop,
                      right: contentPaddingRight),
                ),
                validator: validator),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder outlineInputBorderDecoration(
      {double? r, Color? borderClr, double? width}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(r!),
      borderSide: BorderSide(color: borderClr!, width: width!),
    );
  }
}
