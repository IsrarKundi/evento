import 'dart:developer';

import 'package:event_connect/core/constants/app_constants.dart';
import 'package:event_connect/core/constants/supabase_constants.dart';
import 'package:event_connect/core/utils/dialogs.dart';
import 'package:event_connect/core/utils/utils.dart';
import 'package:event_connect/models/availabilityModel/availability_model.dart';
import 'package:event_connect/services/snackbar_service/snackbar.dart';
import 'package:event_connect/services/supabaseService/supbase_crud_service.dart';
import 'package:event_connect/views/widget/my_button.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../main_packages.dart';





class ManageAvailabilityScreen extends StatefulWidget {
  const ManageAvailabilityScreen({super.key});

  @override
  State<ManageAvailabilityScreen> createState() =>
      _ManageAvailabilityScreenState();
}

class _ManageAvailabilityScreenState extends State<ManageAvailabilityScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  List<String> timeSlots = Utils.generateTimeSlots();

  Set<String> selectedSlots = {};

  Rx<AvailabilityModel?> availabilityModel = Rx<AvailabilityModel?>(null);

  List<DateTime> _selectedDates = [];

  @override
  void initState() {
    getAvailability();
    super.initState();
  }

  getAvailability() async {
    List<Map<String, dynamic>>? availDocs = await SupabaseCRUDService.instance
        .readAllDocumentsWithFilters(
        tableName: SupabaseConstants().availabilityTable,
        filters: {"created_by": userModelGlobal.value!.id});

    if (availDocs != null) {
      availabilityModel.value = AvailabilityModel.fromMap(availDocs.first);


      selectedSlots = availabilityModel.value!.availableTimes.toSet();
      _selectedDates = availabilityModel.value!.selectedDates;
      _rangeStart = availabilityModel.value!.startDate;
      _rangeEnd = availabilityModel.value!.endDate;
      setState(() {

      });
    }
  }

  addAvailability() async {
    if (_selectedDates.isNotEmpty ) {
      if (selectedSlots.isNotEmpty) {
        DialogService.instance.showProgressDialog(context: context);
        if (availabilityModel.value == null) {
          AvailabilityModel availabilityModel = AvailabilityModel(
            selectedDates: _selectedDates,
              createdBy: userModelGlobal.value?.id ?? "",
              startDate: _rangeStart ?? DateTime.now(),
              endDate: _rangeEnd ?? DateTime.now(),
              availableTimes: selectedSlots.toList());

          await SupabaseCRUDService.instance.createDocument(
              tableName: SupabaseConstants().availabilityTable,
              data: availabilityModel.toMap());
        } else {
          // Replace this part in your addAvailability() method:
bool isUpdated = await SupabaseCRUDService.instance.updateDocument(
    tableName: SupabaseConstants().availabilityTable,
    id: availabilityModel.value!.id ?? "",
    data: {
      "start_date": _rangeStart?.toIso8601String(),
      "end_date": _rangeEnd?.toIso8601String(),
      "available_times": selectedSlots.toList(),
      "selected_dates": _selectedDates.map((date) => date.toIso8601String()).toList(), // Add this line
    });
        // bool isUpdated =  await SupabaseCRUDService.instance.updateDocument(
        //       tableName: SupabaseConstants().availabilityTable,
        //       id: availabilityModel.value!.id ?? "",
        //       data: {
        //         "start_date":_rangeStart?.toIso8601String(),
        //         "end_date":_rangeEnd?.toIso8601String(),
        //         "available_times":selectedSlots.toList()
        //       });
        log("Isupdated = $isUpdated");
        if(isUpdated){
          Get.back();
        }
        }
        DialogService.instance.hideProgressDialog(context: context);
        CustomSnackBars.instance.showSuccessSnackbar(
            title: "Success", message: "Availability Added");
      } else {
        CustomSnackBars.instance.showFailureSnackbar(
            title: "TimeSlots Required", message: "Please select Time slots");
      }
    } else {
      CustomSnackBars.instance.showFailureSnackbar(
          title: "Date Required", message: "Please select Dates");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.manageAvailability),
        centerTitle: true,
        leading: const BackButton(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MyButton(
            onTap: () {
              addAvailability();
            },
            buttonText: AppLocalizations.of(context)!.update),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCalendar(),
            const SizedBox(height: 16),
            _buildTimeSlots(),
          ],
        ),
      ),
    );
  }

  // Widget _buildCalendar() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(10),
  //       border: Border.all(color: kBorderColor),
  //     ),
  //     child: TableCalendar(
  //       firstDay: DateTime.utc(2020),
  //       lastDay: DateTime.utc(2030),
  //       focusedDay: _focusedDay,
  //       rangeStartDay: _rangeStart,
  //       rangeEndDay: _rangeEnd,
  //       rangeSelectionMode: RangeSelectionMode.toggledOn,
  //       calendarFormat: CalendarFormat.month,
  //       onDaySelected: (selectedDay, focusedDay) {
  //         setState(() {
  //           if (_rangeStart == null ||
  //               (_rangeStart != null && _rangeEnd != null)) {
  //             // Start a new range
  //             _rangeStart = selectedDay;
  //             _rangeEnd = null;
  //           } else if (_rangeStart != null && _rangeEnd == null) {
  //             if (selectedDay.isBefore(_rangeStart!)) {
  //               _rangeEnd = _rangeStart;
  //               _rangeStart = selectedDay;
  //             } else {
  //               _rangeEnd = selectedDay;
  //             }
  //           }
  //           _focusedDay = focusedDay;
  //         });
  //       },
  //       headerStyle: const HeaderStyle(
  //         formatButtonVisible: false,
  //         titleCentered: true,
  //       ),
  //       calendarStyle: CalendarStyle(
  //         todayDecoration: const BoxDecoration(
  //           color: Colors.transparent,
  //           shape: BoxShape.circle,
  //         ),
  //         rangeHighlightColor: kPrimaryColor.withOpacity(0.15),
  //         rangeStartDecoration: const BoxDecoration(
  //           color: kPrimaryColor,
  //           shape: BoxShape.circle,
  //         ),
  //         rangeEndDecoration: const BoxDecoration(
  //           color: kPrimaryColor,
  //           shape: BoxShape.circle,
  //         ),
  //         defaultTextStyle: TextStyle(color: Colors.black),
  //         weekendTextStyle: TextStyle(color: Colors.black),
  //       ),
  //     ),
  //   );
  // }


  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kBorderColor),
      ),
      child: TableCalendar(

        firstDay: DateTime.utc(2020),
        lastDay: DateTime.utc(2030),
        focusedDay: _focusedDay,
        calendarFormat: CalendarFormat.month,
        selectedDayPredicate: (day) {
          return _selectedDates.any((d) =>
              isSameDay(d, day)); // highlight if date exists in list
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            if (_selectedDates.any((d) => isSameDay(d, selectedDay))) {
              _selectedDates.removeWhere((d) => isSameDay(d, selectedDay));
            } else {
              _selectedDates.add(selectedDay);
            }
            _focusedDay = focusedDay;
          });
        },
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarStyle: CalendarStyle(
          isTodayHighlighted: false,
          todayTextStyle: TextStyle(color: kPrimaryColor),
          todayDecoration: const BoxDecoration(

            color: Colors.white,
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: kPrimaryColor,
            shape: BoxShape.circle,
          ),
          defaultTextStyle: TextStyle(color: Colors.black),
          weekendTextStyle: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildTimeSlots() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: timeSlots.map((slot) {
          final isSelected = selectedSlots.contains(slot);
          // final isDisabled = disabledSlots.contains(slot);

          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedSlots.remove(slot);
                } else {
                  selectedSlots.add(slot);
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? kPrimaryColor : Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected
                    ? [const BoxShadow(color: Colors.black12, blurRadius: 4)]
                    : [],
              ),
              child: Text(
                Utils.convertTo24Hour(slot),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.green.shade900,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
