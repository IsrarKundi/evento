import 'package:event_connect/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

import 'my_text_widget.dart';


class IntlPhoneFieldWidget extends StatelessWidget {
  final String? lebel;
  final String? initialValue;
  final FormFieldValidator<String>? validator;
  final Function(dynamic)? onSubmitted;
  TextEditingController? controller = TextEditingController();
  IntlPhoneFieldWidget({
    super.key,
    this.lebel,
    this.controller,
    this.onSubmitted,
    this.initialValue,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          paddingTop: 8,
          paddingBottom: 7,
          text: "Phone number",
          size: 12,
          weight: FontWeight.w500,
          color: kBlackColor1,
        ),
        Container(
          height: 60,
          //color: Colors.amber,
          child: Center(
            child: IntlPhoneField(
              //
              //
              validator: (PhoneNumber? phoneNumber) {
                if (validator != null) {
                  print("$phoneNumber phoneNumber phoneNumber");
                  return validator!(phoneNumber?.number.toString());
                } else {
                  return null;
                }
              },

              onChanged: onSubmitted,
              controller: controller,
              autovalidateMode: AutovalidateMode.disabled,
              style: const TextStyle(color: kBlackColor1),
              showCountryFlag: false,
              flagsButtonPadding: const EdgeInsets.symmetric(horizontal: 5),
              flagsButtonMargin:
                  const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 5),
              showDropdownIcon: true,
              dropdownIcon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: kBlackColor1,
                size: 15,
              ),
              pickerDialogStyle: PickerDialogStyle(
                backgroundColor: kPrimaryColor,
                searchFieldCursorColor: kBlackColor1,
                searchFieldInputDecoration: const InputDecoration(


                  labelStyle: TextStyle(color: kBlackColor1),
                    counterStyle: TextStyle(color: kBlackColor1),
                    helperStyle: TextStyle(color: kBlackColor1),
                    hintStyle: TextStyle(color: kBlackColor1)),
                countryCodeStyle: const TextStyle(color: kBlackColor1),
                countryNameStyle: const TextStyle(color: kBlackColor1),
              ),

              dropdownTextStyle: const TextStyle(
                  fontSize: 12,
                  color: kBlackColor1,
                  fontWeight: FontWeight.w500),
              dropdownIconPosition: IconPosition.trailing,
              dropdownDecoration: BoxDecoration(
                  color: kSecondaryColor,
                  borderRadius: BorderRadius.circular(24)),
              decoration: InputDecoration(
                counterStyle: const TextStyle(color: Colors.amber),

                counterText: '',
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 3,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(width: 1, color: kGreyColor3)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(width: 1, color: kSecondaryColor)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(width: 1, color: kGreyColor3)),
              ),
              initialCountryCode: 'PK',
            ),
          ),
        ),
      ],
    );
  }
}
