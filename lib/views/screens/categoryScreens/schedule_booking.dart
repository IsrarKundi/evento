import 'package:event_connect/controllers/categoryControllers/schedule_booking_controller.dart';
import 'package:event_connect/core/utils/utils.dart';
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/models/serviceModels/services_model.dart';
import 'package:event_connect/services/snackbar_service/snackbar.dart';
import 'package:event_connect/views/screens/categoryScreens/schedule_booking_details.dart';
import 'package:event_connect/views/widget/calendar/custom_date_picker.dart';
import 'package:event_connect/views/widget/custom_dropdown_widget.dart';
import 'package:event_connect/views/widget/my_button.dart';
import 'package:event_connect/views/widget/my_text_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        child: Wrap(

          spacing: 10,
          runSpacing: 10,
          children: controller.times.map((time) {
            final isSelected = controller.selectedTime.value == time;
            return GestureDetector(
              onTap: () => controller.selectTime(time),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? kPrimaryColor : Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  Utils.convertTo24Hour(time),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }
}
