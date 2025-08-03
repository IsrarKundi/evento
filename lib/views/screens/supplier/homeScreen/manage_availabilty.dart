import 'dart:developer';

import 'package:event_connect/core/constants/app_constants.dart';
import 'package:event_connect/core/constants/supabase_constants.dart';
import 'package:event_connect/core/utils/dialogs.dart';
import 'package:event_connect/core/utils/utils.dart';
import 'package:event_connect/l10n/app_localizations.dart';
import 'package:event_connect/models/availabilityModel/availability_model.dart';
import 'package:event_connect/services/snackbar_service/snackbar.dart';
import 'package:event_connect/services/supabaseService/supbase_crud_service.dart';
import 'package:event_connect/views/widget/my_button.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../main_packages.dart';





class ManageAvailabilityScreen extends StatefulWidget {
  const ManageAvailabilityScreen({super.key});

  @override
  State<ManageAvailabilityScreen> createState() =>
      _ManageAvailabilityScreenState();
}

class _ManageAvailabilityScreenState extends State<ManageAvailabilityScreen> {

  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate; // Changed from _selectedDates to single date
  

  
  List<String> timeSlots = Utils.generateTimeSlots();
  
  // Store slots per date - Map<date, set of selected slots>
  Map<DateTime, Set<String>> slotsPerDate = {};
  
  // Store booked slots per date - Map<date, set of booked slots>
  Map<DateTime, Set<String>> bookedSlotsPerDate = {};
  
  // Current slots for the selected date
  Set<String> currentSelectedSlots = {};

  Rx<AvailabilityModel?> availabilityModel = Rx<AvailabilityModel?>(null);
  // Store slots per date - Map<date, set of selected slots>



  Set<String> selectedSlots = {};



  List<DateTime> _selectedDates = [];

  @override
  void initState() {
    getAvailability();
     getBookedSlots(); 
    super.initState();
  }
  getBookedSlots() async {
    List<Map<String, dynamic>>? bookingDocs = await SupabaseCRUDService.instance
        .readAllDocumentsWithFilters(
        tableName: SupabaseConstants().bookingsTable,
        filters: {"supplier_id": userModelGlobal.value!.id});

    if (bookingDocs != null && bookingDocs.isNotEmpty) {
      bookedSlotsPerDate.clear();
      
      for (var booking in bookingDocs) {
        DateTime bookingDate = DateTime.parse(booking['selected_date']);
        String bookingTime = booking['selected_time'];
        DateTime normalizedDate = _normalizeDate(bookingDate);
        
        if (bookedSlotsPerDate[normalizedDate] == null) {
          bookedSlotsPerDate[normalizedDate] = <String>{};
        }
        bookedSlotsPerDate[normalizedDate]!.add(bookingTime);
      }
      
      setState(() {});
    }
  }
// Replace your getAvailability method with this:
 getAvailability() async {
    List<Map<String, dynamic>>? availDocs = await SupabaseCRUDService.instance
        .readAllDocumentsWithFilters(
        tableName: SupabaseConstants().availabilityTable,
        filters: {"created_by": userModelGlobal.value!.id});

    if (availDocs != null && availDocs.isNotEmpty) {
      availabilityModel.value = AvailabilityModel.fromMap(availDocs.first);
      
      // Load existing data - check if per-date slots exist
      final savedDates = availabilityModel.value!.selectedDates;
      
      // Check if we have per-date slots data (new format)
      if (availabilityModel.value!.slotsPerDate != null && 
          availabilityModel.value!.slotsPerDate!.isNotEmpty) {
        // Load from new per-date format
        slotsPerDate.clear();
        availabilityModel.value!.slotsPerDate!.forEach((dateStr, slots) {
          DateTime date = DateTime.parse(dateStr);
          slotsPerDate[_normalizeDate(date)] = Set.from(slots);
        });
      } else {
        // Legacy format - don't load anything, let user start fresh
        slotsPerDate.clear();
      }
      
      // Set the first saved date as selected if available
      if (savedDates.isNotEmpty) {
        _selectedDate = _normalizeDate(savedDates.first);
        currentSelectedSlots = Set.from(slotsPerDate[_selectedDate] ?? {});
      }
      
      setState(() {});
    }
  }
    DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
    void _loadSlotsForDate(DateTime date) {
    final normalizedDate = _normalizeDate(date);
    currentSelectedSlots = Set.from(slotsPerDate[normalizedDate] ?? {});
  }
    void _updateSlotsForCurrentDate() {
    if (_selectedDate != null) {
      slotsPerDate[_selectedDate!] = Set.from(currentSelectedSlots);
    }
  }
 bool _isSlotBooked(String slot) {
    if (_selectedDate == null) return false;
    return bookedSlotsPerDate[_selectedDate]?.contains(slot) ?? false;
  }
addAvailability() async {
  // Update current date's slots before saving
  _updateSlotsForCurrentDate();
  
  if (slotsPerDate.isEmpty) {
    CustomSnackBars.instance.showFailureSnackbar(
        title: "Date Required", message: "Please select at least one date with time slots");
    return;
  }

  // Check if any date has selected slots
  bool hasAnySlots = slotsPerDate.values.any((slots) => slots.isNotEmpty);
  if (!hasAnySlots) {
    CustomSnackBars.instance.showFailureSnackbar(
        title: "TimeSlots Required", message: "Please select time slots for at least one date");
    return;
  }

  DialogService.instance.showProgressDialog(context: context);
  
  // Prepare data for saving
  List<DateTime> allSelectedDates = slotsPerDate.keys.toList();
  Set<String> allSlots = {};
  
  // Collect all unique slots from all dates
  for (Set<String> dateSlots in slotsPerDate.values) {
    allSlots.addAll(dateSlots);
  }

  // Create per-date slots map for storage
  Map<String, List<String>> slotsPerDateForStorage = {};
  slotsPerDate.forEach((date, slots) {
    if (slots.isNotEmpty) {
      slotsPerDateForStorage[date.toIso8601String()] = slots.toList();
    }
  });

  if (availabilityModel.value == null) {
    // Create new availability
    AvailabilityModel newAvailabilityModel = AvailabilityModel(
      selectedDates: allSelectedDates,
      createdBy: userModelGlobal.value?.id ?? "",
      startDate: allSelectedDates.isNotEmpty ? allSelectedDates.first : DateTime.now(),
      endDate: allSelectedDates.isNotEmpty ? allSelectedDates.last : DateTime.now(),
      availableTimes: allSlots.toList(),
      slotsPerDate: slotsPerDateForStorage, // Add this new field
    );

    await SupabaseCRUDService.instance.createDocument(
        tableName: SupabaseConstants().availabilityTable,
        data: newAvailabilityModel.toMap());
  } else {
    // Update existing availability
    bool isUpdated = await SupabaseCRUDService.instance.updateDocument(
      tableName: SupabaseConstants().availabilityTable,
      id: availabilityModel.value!.id ?? "",
      data: {
        "start_date": allSelectedDates.isNotEmpty ? allSelectedDates.first.toIso8601String() : DateTime.now().toIso8601String(),
        "end_date": allSelectedDates.isNotEmpty ? allSelectedDates.last.toIso8601String() : DateTime.now().toIso8601String(),
        "available_times": allSlots.toList(),
        "selected_dates": allSelectedDates.map((date) => date.toIso8601String()).toList(),
        "slots_per_date": slotsPerDateForStorage, // Add this new field
      });
    
    log("IsUpdated = $isUpdated");
    if (isUpdated) {
      Get.back();
    }
  }
  
  DialogService.instance.hideProgressDialog(context: context);
  CustomSnackBars.instance.showSuccessSnackbar(
      title: "Success", message: "Availability Updated");
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
          return _selectedDate != null && isSameDay(_selectedDate!, day);
        },
        // Custom day builder to show dates with slots
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            final normalizedDay = _normalizeDate(day);
            final hasSlots = slotsPerDate[normalizedDay]?.isNotEmpty ?? false;
            
            if (hasSlots) {
              return Container(
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(color: Colors.green.shade700),
                  ),
                ),
              );
            }
            return null;
          },
        ),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            // Save current slots before switching dates
            if (_selectedDate != null) {
              _updateSlotsForCurrentDate();
            }
            
            // Switch to new date
            _selectedDate = _normalizeDate(selectedDay);
            _focusedDay = focusedDay;
            
            // Load slots for the new date
            _loadSlotsForDate(selectedDay);
          });
        },
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarStyle: CalendarStyle(
          isTodayHighlighted: true,
          todayTextStyle: TextStyle(color: kPrimaryColor),
          todayDecoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: kPrimaryColor),
          ),
          selectedDecoration: const BoxDecoration(
            color: kPrimaryColor,
            shape: BoxShape.circle,
          ),
          defaultTextStyle: const TextStyle(color: Colors.black),
          weekendTextStyle: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }

Widget _buildTimeSlots() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Show selected date info
        if (_selectedDate != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: kPrimaryColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: kPrimaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Selected Date: ${Utils.formatDate(_selectedDate!)}',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  if (currentSelectedSlots.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${currentSelectedSlots.length} slots',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        
        // Time slots
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: timeSlots.map((slot) {
              final isSelected = currentSelectedSlots.contains(slot);
              final isBooked = _isSlotBooked(slot);

              return GestureDetector(
                onTap: _selectedDate == null || isBooked ? null : () {
                  setState(() {
                    if (isSelected) {
                      currentSelectedSlots.remove(slot);
                    } else {
                      currentSelectedSlots.add(slot);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: _selectedDate == null 
                        ? Colors.grey.shade200
                        : isBooked
                            ? Colors.red.shade100
                            : isSelected 
                                ? kPrimaryColor 
                                : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isSelected && !isBooked
                        ? [const BoxShadow(color: Colors.black12, blurRadius: 4)]
                        : [],
                    border: isBooked 
                        ? Border.all(color: Colors.red.shade300, width: 1)
                        : null,
                  ),
                  child: Stack(
                    children: [
                      Text(
                        Utils.convertTo24Hour(slot),
                        style: TextStyle(
                          color: _selectedDate == null
                              ? Colors.grey.shade500
                              : isBooked
                                  ? Colors.red.shade700
                                  : isSelected 
                                      ? Colors.white 
                                      : Colors.green.shade900,
                          fontWeight: FontWeight.w500,
                          decoration: isBooked ? TextDecoration.lineThrough : null,
                          decorationColor: Colors.red.shade700,
                          decorationThickness: 2,
                        ),
                      ),
                      // if (isBooked)
                      //   Positioned(
                      //     top: 0,
                      //     right: 0,
                      //     child: Icon(
                      //       Icons.block,
                      //       size: 12,
                      //       color: Colors.red.shade700,
                      //     ),
                      //   ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        
        // Instructions
        if (_selectedDate == null)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Please select a date from the calendar to choose time slots',
                      style: TextStyle(
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        
        // Legend
        if (_selectedDate != null)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem(Colors.green.shade50, 'Available', Colors.green.shade900),
                _buildLegendItem(kPrimaryColor, 'Selected', Colors.white),
                _buildLegendItem(Colors.red.shade100, 'Booked', Colors.red.shade700),
              ],
            ),
          ),
      ],
    );
  }
  Widget _buildLegendItem(Color backgroundColor, String label, Color textColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(4),
            border: backgroundColor == Colors.red.shade100 
                ? Border.all(color: Colors.red.shade300)
                : null,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
