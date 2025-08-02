import 'dart:developer';

import 'package:event_connect/core/constants/app_constants.dart';
import 'package:event_connect/core/constants/supabase_constants.dart';
import 'package:event_connect/core/enums/enums.dart';
import 'package:event_connect/core/utils/dialogs.dart';
import 'package:event_connect/core/utils/utils.dart';
import 'package:event_connect/main.dart';
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/models/availabilityModel/availability_model.dart';
import 'package:event_connect/models/bookingModel/booking_model.dart';
import 'package:event_connect/models/serviceModels/services_model.dart';
import 'package:event_connect/services/onesignalNotificationService/one_signal_notification_service.dart';
import 'package:event_connect/services/snackbar_service/snackbar.dart';
import 'package:event_connect/services/supabaseService/supbase_crud_service.dart';
import 'package:event_connect/views/screens/auth/forgetScreen/congrats_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../userControllers/bookings_controller.dart';

class ScheduleBookingController extends GetxController {
  ServiceModel serviceModel = Get.arguments;
  RxList<String> times = <String>[].obs;
  Rx<AvailabilityModel?> availableModel = Rx<AvailabilityModel?>(null);
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchAvailability();
  }

  // Reactive variable for selected time
  var selectedTime = "".obs;

  void selectTime(String time) {
    selectedTime.value = time;
  }

  int convertTo24HourValue(String timeStr) {
    final clean = timeStr.replaceAll(RegExp(r'[\u200B-\u200D\uFEFF\u00A0]'), '').trim();

    final parts = clean.split(RegExp(r'[:\s]'));
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    String meridiem = parts[2].toUpperCase();

    if (meridiem == 'PM' && hour != 12) hour += 12;
    if (meridiem == 'AM' && hour == 12) hour = 0;

    return hour * 60 + minute; // total minutes since midnight
  }

  fetchAvailability() async {

    List<Map<String, dynamic>>? documents = await SupabaseCRUDService.instance
        .readAllDocuments(
            tableName: SupabaseCRUDService.instance.availabilityTable,
            fieldName: 'created_by',
            fieldValue: serviceModel.createdBy);

    if (documents != null) {
      availableModel.value = AvailabilityModel.fromMap(documents.first);
      log("AvailabilityModel = ${availableModel.value!.toMap()}");
      final rawTimes = availableModel.value?.availableTimes ?? [];

      final DateFormat format = DateFormat.jm(); // Expects: 12:00 AM, 2:00 PM

      rawTimes.sort((a, b) =>
          convertTo24HourValue(a).compareTo(convertTo24HourValue(b)));

      times.value = rawTimes;

    }
  }

  checkBooking({required BuildContext context}) async {
    DialogService.instance.showProgressDialog(context: context);
    List<Map<String, dynamic>>? docs = await SupabaseCRUDService.instance
        .readAllDocumentsWithFilters(
            tableName: SupabaseConstants().bookingsTable,
            filters: {
          'supplier_id': serviceModel.createdBy,
          'selected_date': selectedDate.value!.toIso8601String(),
          'selected_time': selectedTime.value
        });
    DialogService.instance.hideProgressDialog(context: context);
    if (docs != null && docs.isNotEmpty) {
      CustomSnackBars.instance.showFailureSnackbar(
          title: AppLocalizations.of(context)!.failed, message: AppLocalizations.of(context)!.dateTimeAlreadyBooked);
      return;
    } else {
      createBooking(context: context);
    }
  }

  createBooking({required BuildContext context}) async {
    DialogService.instance.showProgressDialog(context: context);
    BookingModel bookingModel = BookingModel(
        bookingStatus: BookingStatus.upcoming.name,
        serviceId: serviceModel.id ?? "",
        selectedDate: selectedDate.value!,
        selectedTime: selectedTime.value,
        supplierId: serviceModel.createdBy ?? "",
        bookedBy: userModelGlobal.value?.id ?? "");
    bool isCreated = await SupabaseCRUDService.instance.createDocument(
        tableName: SupabaseConstants().bookingsTable,
        data: bookingModel.toMap());
    DialogService.instance.hideProgressDialog(context: context);
    if (isCreated) {
      OneSignalNotificationService.instance.sendOneSignalNotificationToUser(

          isSaved: true,
          type: NotificationType.booking.name,
          externalId: serviceModel.createdBy??"",
          title: AppLocalizations.of(context)!.serviceBooked,
          message:
              "${userModelGlobal.value?.fullName ?? ''} ${AppLocalizations.of(context)!.bookedYourService} ${serviceModel.serviceName} ${AppLocalizations.of(context)!.serviceAt} ${Utils.formatDate(bookingModel.selectedDate)} - ${bookingModel.selectedTime}");
      Get.find<BookingsController>().getAllBookings();

      if (serviceModel.advertised == true) {
        Get.close(2);
      } else {
        Get.close(4);
      }
      Get.to(() => CongratsScreen());
      CustomSnackBars.instance
          .showSuccessSnackbar(title: AppLocalizations.of(context)!.success, message: AppLocalizations.of(context)!.bookingCreated);
    }
  }
}
