import 'package:event_connect/core/utils/app_lists.dart';
import 'package:event_connect/core/utils/utils.dart';
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/services/snackbar_service/snackbar.dart';
import 'package:event_connect/views/widget/bottomSheets/city_selector_bottom_sheet.dart';
import 'package:event_connect/views/widget/my_button.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

void showFilterBottomSheet(BuildContext context,
    {Function(String selectedCity, String selectedEvent, DateTime dateTime)?
        onApply}) {
  // Controllers to hold selected values
  TextEditingController dateController = TextEditingController();
  DateTime? selectedDate;
  String selectedCity = "";
  String selectedEvent = "";

  showModalBottomSheet(
    context: context,

    builder: (context) {
      return StatefulBuilder(
        builder: (context,setState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Selection
                Text("Select Event",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () async {
                    // Show event selection (use your event selection here)
                    selectedEvent = await _selectEvent(context) ?? selectedEvent;
                    setState((){

                    });
                    },
                  child:
                      ListTile(
                      title: Text(selectedEvent),
                      trailing: Icon(Icons.arrow_drop_down),
                    ),

                ),

                Divider(),

                Text("Select Date",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () async {
                    selectedDate = await _selectDate(context) ?? null;
                    if (selectedDate != null)
                      dateController.text =
                      Utils.formatDateTimeSimple(selectedDate, context);
                        //  "${selectedDate}".split(' ')[0];
                  },
                  child: TextFormField(
                    controller: dateController,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: "Date",
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),

                Divider(),

                // City Selection
                Text("Select City",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () async {
                    showCityPicker(context, [...romaniaCities], (city) {
                      selectedCity = city;
                      setState((){

                      });
                    });
                  },
                  child: ListTile(
                    title: Text(selectedCity),
                    trailing: Icon(Icons.arrow_drop_down),
                  ),
                ),

                Divider(),
                SizedBox(height: 20,),
                MyButton(onTap: () {
                  // Close the bottom sheet

                  if(selectedCity.isNotEmpty && selectedEvent.isNotEmpty && selectedDate!=null){
                    if(onApply!=null){
                      Navigator.pop(context);
                      onApply(selectedCity,selectedEvent,selectedDate!);

                    }
                  }else if(selectedCity.isEmpty){
                    CustomSnackBars.instance.showToast(message: "Please Select City");
                  } else if(selectedEvent.isEmpty){
                    CustomSnackBars.instance.showToast(message: "Please Select Event");
                  }else if(selectedDate==null){
                    CustomSnackBars.instance.showToast(message: "Please Select Date");

                  }
                  // navigateToNextScreen(context, selectedEvent, dateController.text, selectedCity);
                }, buttonText: "Apply Filters"),

                SizedBox(height: 20,),
              ],
            ),
          );
        }
      );
    },
  );
}

// Event selection function (you can customize this as needed)
Future<String?> _selectEvent(BuildContext context) async {
  return showModalBottomSheet<String>(
    context: context,
    builder: (context) {
      return ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("${services[index]}"),
            onTap: () => Navigator.pop(context, "${services[index]}"),
          );
        },
      );
    },
  );
}

// Date picker function
Future<DateTime?> _selectDate(BuildContext context) async {
  DateTime initialDate = DateTime.now();
  DateTime firstDate = DateTime(1900);
  DateTime lastDate = DateTime(2100);

  return await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );
}

