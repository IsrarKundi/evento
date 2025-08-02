import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'my_text_widget.dart';


class MyDropDown extends StatelessWidget {
  final Function(dynamic)? onChanged;
  final List<String> itemsList;
  final String? selectedValue, title, hint;
  final double paddingTop;
  final Color? bkColor, borderColor;
  final FontWeight titleFontWeight;
  const MyDropDown({
    super.key,
    this.onChanged,
    required this.itemsList,
    this.selectedValue,
    this.title,
    this.paddingTop = 8.0,
    this.hint = 'Select',
    this.bkColor,
    this.borderColor,
    this.titleFontWeight = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: paddingTop),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title != null
              ? MyText(
                  paddingBottom: 8,
                  text: '$title',
                  size: 16,
                  weight: titleFontWeight,
                  // color:
                )
              : SizedBox(),
          DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              hint.toString(),
              style: TextStyle(
                fontSize: 14,
                // color:
              ),
            ),
            items: itemsList
                .map((String item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item.toString(),
                        style: const TextStyle(fontSize: 14, color: kBlackColor1),
                      ),
                    ))
                .toList(),
            value: selectedValue,
            onChanged: onChanged,
            iconStyleData: IconStyleData(
                icon: Icon(
              Icons.arrow_drop_down,
              // color:
            )),

            // ----------- Drop Down Style --------------------

            dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                    border: Border.all(color: kSecondaryColor),
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(8))),

            // ----------- Button Style --------------------

            underline: SizedBox(),
            buttonStyleData: ButtonStyleData(
              decoration: BoxDecoration(
                  color: bkColor,
                  border: Border.all(
                      width: 0.6,
                      color: borderColor ?? kBlackColor1.withOpacity(0.3)),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              padding: EdgeInsets.only(left: 0, right: 10),
              height: 45,
            ),

            menuItemStyleData: MenuItemStyleData(
              height: 40,
            ),
          ),
        ],
      ),
    );
  }
}
