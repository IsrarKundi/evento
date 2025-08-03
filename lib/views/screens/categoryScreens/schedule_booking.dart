import 'package:event_connect/controllers/categoryControllers/schedule_booking_controller.dart';
import 'package:event_connect/core/utils/utils.dart';
import 'package:event_connect/l10n/app_localizations.dart';
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/models/serviceModels/services_model.dart';
import 'package:event_connect/services/snackbar_service/snackbar.dart';
import 'package:event_connect/views/screens/categoryScreens/schedule_booking_details.dart';
import 'package:event_connect/views/widget/calendar/custom_date_picker.dart';
import 'package:event_connect/views/widget/custom_dropdown_widget.dart';
import 'package:event_connect/views/widget/my_button.dart';
import 'package:event_connect/views/widget/my_text_widget.dart';

class ScheduleBooking extends StatelessWidget {
  final ServiceModel serviceModel;

  ScheduleBooking({super.key, required this.serviceModel});

  final ScheduleBookingController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(text: AppLocalizations.of(context)!.scheduleBooking),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(
              text: AppLocalizations.of(context)!.selectDate,
              size: 18,
              weight: FontWeight.w600,
            ),
            SizedBox(
              height: 20,
            ),
            Obx(
              () => CustomDatePicker(
                selectedDates: controller.availableModel.value?.selectedDates??[],


                  onDateSelected: (date) {
                    controller.selectedDate.value = date;
            //    controller.selectedDate.value=    Utils.formatDateToYMD(date);
                  }),
            ),
            SizedBox(
              height: 18,
            ),
            MyText(
              text: AppLocalizations.of(context)!.selectTime,
              size: 20,
              weight: FontWeight.w600,
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(child: TimePickerWidget()),
            MyButton(
              mBottom: 20,
                radius: 100,
                onTap: () {
                  if (controller.selectedTime.value.isNotEmpty &&
                      controller.selectedDate.value != null) {
                       // print("datetime passed ${Utils.formatDateTimeSimple(controller.selectedDate.value!,context)}");
                        print("time here1 ${controller.selectedTime.value}");
                    Get.to(() => ScheduleBookingDetails(
                        serviceModel: serviceModel,
                        date: Utils.formatDateTimeSimple(controller.selectedDate.value!,context),
                        time: controller.selectedTime.value));
                    // controller.checkBooking(context: context);
                  } else {
                    CustomSnackBars.instance.showFailureSnackbar(
                        title: AppLocalizations.of(context)!.pleaseSelect,
                        message: AppLocalizations.of(context)!.pleaseSelectTimeAndDate);
                  }
                },
                buttonText: AppLocalizations.of(context)!.scheduleBooking)

          ],
        ),
      ),
    );
  }
}

class TimePickerWidget extends StatelessWidget {
  final ScheduleBookingController controller =
      Get.find<ScheduleBookingController>();

  TimePickerWidget({super.key});

  // Helper method to normalize date (remove time component)
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Get slots for the currently selected date
      List<String> availableSlotsForDate = [];
      
      if (controller.selectedDate.value != null && 
          controller.availableModel.value != null) {
        
        final normalizedSelectedDate = _normalizeDate(controller.selectedDate.value!);
        
        // Check if we have per-date slots data
        if (controller.availableModel.value!.slotsPerDate != null && 
            controller.availableModel.value!.slotsPerDate!.isNotEmpty) {
          
          // Find slots for the selected date
          String? dateKey;
          for (String key in controller.availableModel.value!.slotsPerDate!.keys) {
            DateTime keyDate = DateTime.parse(key);
            if (_normalizeDate(keyDate).isAtSameMomentAs(normalizedSelectedDate)) {
              dateKey = key;
              break;
            }
          }
          
          if (dateKey != null) {
            availableSlotsForDate = List<String>.from(
              controller.availableModel.value!.slotsPerDate![dateKey] ?? []
            );
          }
        } else {
          // Fallback: if no per-date slots, check if selected date is in selectedDates
          bool isDateAvailable = controller.availableModel.value!.selectedDates.any((date) => 
            _normalizeDate(date).isAtSameMomentAs(normalizedSelectedDate)
          );
          
          if (isDateAvailable) {
            availableSlotsForDate = List<String>.from(controller.times);
          }
        }
      }

      // Show message if no date is selected
      if (controller.selectedDate.value == null) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                Icons.calendar_today,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              MyText(
                text: 
                //AppLocalizations.of(context)!.pleaseSelectDateFirst ?? 
                'Please select a date first',
                size: 16,
                color: Colors.grey[600],
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      // Show message if no slots available for selected date
      if (availableSlotsForDate.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                Icons.schedule_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              MyText(
                text: 
                //AppLocalizations.of(context)!.noSlotsAvailable ?? 
                'No time slots available for selected date',
                size: 16,
                color: Colors.grey[600],
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              MyText(
                text: 
                //AppLocalizations.of(context)!.pleaseSelectAnotherDate ?? 
                'Please select another date',
                size: 14,
                color: Colors.grey[500],
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      // Get booked slots for the selected date
      Set<String> bookedSlots = controller.bookedSlotsPerDate[controller.selectedDate.value] ?? {};
      List<String> availableSlots = availableSlotsForDate.where((slot) => !bookedSlots.contains(slot)).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show selected date info
          Container(
            margin: const EdgeInsets.only(bottom: 16),
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
                MyText(
                  text: '${'Selected Date'}: ${Utils.formatDateTimeSimple(controller.selectedDate.value!, context)}',
                  color: kPrimaryColor,
                  weight: FontWeight.w600,
                  size: 14,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: MyText(
                    text: '${availableSlots.length} ${'available'}',
                    color: Colors.white,
                    size: 12,
                    weight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // Time slots grid
          SingleChildScrollView(
  child: Wrap(
    spacing: 10,
    runSpacing: 10,
    children: availableSlotsForDate.map((time) {
      final isSelected = controller.selectedTime.value == time;
      final isBooked = controller.isSlotBooked(time); // Use controller method
      
      return GestureDetector(
        onTap: isBooked ? null : () => controller.selectTime(time),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isBooked 
                ? Colors.red.shade100
                : isSelected 
                    ? kPrimaryColor 
                    : Colors.white,
            border: Border.all(
              color: isBooked
                  ? Colors.red.shade300
                  : isSelected 
                      ? kPrimaryColor 
                      : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected && !isBooked ? [
              BoxShadow(
                color: kPrimaryColor.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ] : [],
          ),
          child: Stack(
            children: [
              MyText(
                text: Utils.convertTo24Hour(time),
                color: isBooked
                    ? Colors.red.shade700
                    : isSelected 
                        ? Colors.white 
                        : Colors.black87,
                weight: isSelected ? FontWeight.bold : FontWeight.w500,
                size: 14,
                decoration: isBooked ? TextDecoration.lineThrough : TextDecoration.none,
                decorationColor: Colors.red.shade700,
                decorationThickness: 2,
              ),
              // if (isBooked)
              //   Positioned(
              //     top: -2,
              //     right: -2,
              //     child: Icon(
              //       Icons.block,
              //       size: 14,
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
          // Legend
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem(Colors.white, 'Available', Colors.black87, Icons.schedule),
                _buildLegendItem(kPrimaryColor, 'Selected', Colors.white, Icons.check_circle),
                _buildLegendItem(Colors.red.shade100, 'Booked', Colors.red.shade700, Icons.block),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildLegendItem(Color backgroundColor, String label, Color textColor, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(4),
            border: backgroundColor == Colors.red.shade100 
                ? Border.all(color: Colors.red.shade300)
                : backgroundColor == Colors.white
                    ? Border.all(color: Colors.grey.shade300)
                    : null,
          ),
          child: Icon(
            icon,
            size: 12,
            color: textColor,
          ),
        ),
        const SizedBox(width: 4),
        MyText(
          text: label,
          size: 11,
          weight: FontWeight.w500,
          color: Colors.grey.shade700,
        ),
      ],
    );
  }
}