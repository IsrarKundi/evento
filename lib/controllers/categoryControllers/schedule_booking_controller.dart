import 'dart:developer';

import 'package:event_connect/core/constants/app_constants.dart';
import 'package:event_connect/core/constants/supabase_constants.dart';
import 'package:event_connect/core/enums/enums.dart';
import 'package:event_connect/core/utils/dialogs.dart';
import 'package:event_connect/core/utils/utils.dart';
import 'package:event_connect/l10n/app_localizations.dart';
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
import '../userControllers/bookings_controller.dart';



class ScheduleBookingController extends GetxController {
  ServiceModel serviceModel = Get.arguments;
  RxList<String> times = <String>[].obs;
  Rx<AvailabilityModel?> availableModel = Rx<AvailabilityModel?>(null);
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  RxMap<DateTime, Set<String>> bookedSlotsPerDate = <DateTime, Set<String>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAvailability();
    fetchBookedSlots();
    // Listen to date changes and reset selected time
    ever(selectedDate, (DateTime? date) {
      if (date != null) {
        selectedTime.value = ""; // Reset selected time when date changes
     bookedSlotsPerDate.refresh();
      }
    });
  }
bool isSlotBooked(String slot) {
  if (selectedDate.value == null) return false;
  DateTime normalizedDate = _normalizeDate(selectedDate.value!);
  return bookedSlotsPerDate[normalizedDate]?.contains(slot) ?? false;
}
  Set<String> getBookedSlotsForDate(DateTime date) {
    DateTime normalizedDate = _normalizeDate(date);
    return bookedSlotsPerDate[normalizedDate] ?? {};
  }
  // Reactive variable for selected time
  var selectedTime = "".obs;

  void selectTime(String time) {
    selectedTime.value = time;
  }

Future<void> fetchBookedSlots() async {
  try {
    List<Map<String, dynamic>>? bookingDocs = await SupabaseCRUDService.instance
        .readAllDocumentsWithFilters(
        tableName: SupabaseConstants().bookingsTable,
        filters: {"supplier_id": serviceModel.createdBy});

    if (bookingDocs != null && bookingDocs.isNotEmpty) {
      Map<DateTime, Set<String>> tempBookedSlots = {};
      
      log("Found ${bookingDocs.length} bookings for supplier: ${serviceModel.createdBy}");
      
      for (var booking in bookingDocs) {
        try {
          DateTime bookingDate = DateTime.parse(booking['selected_date']);
          String bookingTime = booking['selected_time'];
          DateTime normalizedDate = _normalizeDate(bookingDate);
          
          if (tempBookedSlots[normalizedDate] == null) {
            tempBookedSlots[normalizedDate] = <String>{};
          }
          tempBookedSlots[normalizedDate]!.add(bookingTime);
          
          log("Added booked slot: ${Utils.formatDate(normalizedDate)} at $bookingTime");
        } catch (e) {
          log("Error parsing booking: $e");
        }
      }
      
      // Clear and update the reactive map
      bookedSlotsPerDate.clear();
      bookedSlotsPerDate.addAll(tempBookedSlots);
      
      log("Updated booked slots map with ${bookedSlotsPerDate.length} dates");
      
      // Auto-select nearest date after booked slots are loaded
      _autoSelectNearestDate();
    } else {
      log("No bookings found for supplier: ${serviceModel.createdBy}");
      // Clear the map if no bookings
      bookedSlotsPerDate.clear();
      // Still try to auto-select
      _autoSelectNearestDate();
    }
  } catch (e) {
    log("Error fetching booked slots: $e");
    bookedSlotsPerDate.clear();
    _autoSelectNearestDate(); // Still try to auto-select even on error
  }
}
  
  
  // Helper method to normalize date (remove time component)
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Add this method to auto-select nearest available date
void _autoSelectNearestDate() {
  if (availableModel.value == null) {
    log("Cannot auto-select: availableModel is null");
    return;
  }
  
  DateTime today = _normalizeDate(DateTime.now());
  DateTime? nearestDate;
  int minDaysDifference = 999999;
  
  log("Looking for nearest available date from today: ${Utils.formatDate(today)}");
  
  // Check if we have per-date slots
  if (availableModel.value!.slotsPerDate != null && 
      availableModel.value!.slotsPerDate!.isNotEmpty) {
    
    log("Using per-date slots data");
    // Get all dates that have available slots
    for (String dateStr in availableModel.value!.slotsPerDate!.keys) {
      DateTime date = _normalizeDate(DateTime.parse(dateStr));
      List<String> slotsForDate = availableModel.value!.slotsPerDate![dateStr] ?? [];
      
      // Check if this date has any non-booked slots
      Set<String> bookedSlots = bookedSlotsPerDate[date] ?? {};
      bool hasAvailableSlots = slotsForDate.any((slot) => !bookedSlots.contains(slot));
      
      log("Date: ${Utils.formatDate(date)}, Total slots: ${slotsForDate.length}, Booked: ${bookedSlots.length}, Available: $hasAvailableSlots");
      
      if (hasAvailableSlots && !date.isBefore(today)) {
        int daysDifference = date.difference(today).inDays;
        if (daysDifference < minDaysDifference) {
          minDaysDifference = daysDifference;
          nearestDate = date;
          log("New nearest date found: ${Utils.formatDate(date)} (${daysDifference} days from today)");
        }
      }
    }
  } else {
    log("Using fallback selectedDates");
    // Fallback: use selectedDates from availability model
    for (DateTime date in availableModel.value!.selectedDates) {
      DateTime normalizedDate = _normalizeDate(date);
      
      // Check if this date has any non-booked slots
      Set<String> bookedSlots = bookedSlotsPerDate[normalizedDate] ?? {};
      bool hasAvailableSlots = times.any((slot) => !bookedSlots.contains(slot));
      
      log("Date: ${Utils.formatDate(normalizedDate)}, Available: $hasAvailableSlots");
      
      if (hasAvailableSlots && !normalizedDate.isBefore(today)) {
        int daysDifference = normalizedDate.difference(today).inDays;
        if (daysDifference < minDaysDifference) {
          minDaysDifference = daysDifference;
          nearestDate = normalizedDate;
          log("New nearest date found: ${Utils.formatDate(normalizedDate)} (${daysDifference} days from today)");
        }
      }
    }
  }
  
  // Set the nearest available date
  if (nearestDate != null) {
    selectedDate.value = nearestDate;
    log("Auto-selected nearest available date: ${Utils.formatDate(nearestDate)}");
  } else {
    log("No available dates found for auto-selection");
  }
}

  // Get available (non-booked) slots for the selected date
  List<String> getAvailableSlotsForSelectedDate() {
    if (selectedDate.value == null) return [];
    
    List<String> allSlots = getSlotsForDate(selectedDate.value!);
    Set<String> bookedSlots = bookedSlotsPerDate[selectedDate.value] ?? {};
    
    // Filter out booked slots
    return allSlots.where((slot) => !bookedSlots.contains(slot)).toList();
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

Future<void> fetchAvailability() async {
  List<Map<String, dynamic>>? documents = await SupabaseCRUDService.instance
      .readAllDocuments(
          tableName: SupabaseCRUDService.instance.availabilityTable,
          fieldName: 'created_by',
          fieldValue: serviceModel.createdBy);

  if (documents != null && documents.isNotEmpty) {
    availableModel.value = AvailabilityModel.fromMap(documents.first);
    log("AvailabilityModel = ${availableModel.value!.toMap()}");
    
    // Get all unique time slots (for fallback purposes)
    final rawTimes = availableModel.value?.availableTimes ?? [];

    rawTimes.sort((a, b) =>
        convertTo24HourValue(a).compareTo(convertTo24HourValue(b)));

    times.value = rawTimes;
  }
}
  // Get available slots for a specific date
  List<String> getSlotsForDate(DateTime date) {
    if (availableModel.value == null) return [];
    
    final normalizedDate = _normalizeDate(date);
    
    // Check if we have per-date slots data
    if (availableModel.value!.slotsPerDate != null && 
        availableModel.value!.slotsPerDate!.isNotEmpty) {
      
      // Find slots for the specified date
      String? dateKey;
      for (String key in availableModel.value!.slotsPerDate!.keys) {
        DateTime keyDate = DateTime.parse(key);
        if (_normalizeDate(keyDate).isAtSameMomentAs(normalizedDate)) {
          dateKey = key;
          break;
        }
      }
      
      if (dateKey != null) {
        return List<String>.from(
          availableModel.value!.slotsPerDate![dateKey] ?? []
        );
      }
    } else {
      // Fallback: if no per-date slots, check if date is in selectedDates
      bool isDateAvailable = availableModel.value!.selectedDates.any((availableDate) => 
        _normalizeDate(availableDate).isAtSameMomentAs(normalizedDate)
      );
      
      if (isDateAvailable) {
        return List<String>.from(times);
      }
    }
    
    return [];
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
          title: AppLocalizations.of(context)!.failed, 
          message: AppLocalizations.of(context)!.dateTimeAlreadyBooked);
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
      // Try to send OneSignal notification, but don't fail if it doesn't work
      try {
        await OneSignalNotificationService.instance.sendOneSignalNotificationToUser(
            isSaved: true,
            type: NotificationType.booking.name,
            externalId: serviceModel.createdBy??"",
            title: AppLocalizations.of(context)!.serviceBooked,
            message:
                "${userModelGlobal.value?.fullName ?? ''} ${AppLocalizations.of(context)!.bookedYourService} ${serviceModel.serviceName} ${AppLocalizations.of(context)!.serviceAt} ${Utils.formatDate(bookingModel.selectedDate)} - ${bookingModel.selectedTime}");
      } catch (e) {
        log("OneSignal notification failed: $e");
        // Continue with the flow even if notification fails
      }
      
      // Also create an in-app notification as backup
      try {
        await SupabaseCRUDService.instance.createDocument(
          tableName: SupabaseConstants().notificationsTable,
          data: {
            'title': AppLocalizations.of(context)!.serviceBooked,
            'body': "${userModelGlobal.value?.fullName ?? ''} ${AppLocalizations.of(context)!.bookedYourService} ${serviceModel.serviceName} ${AppLocalizations.of(context)!.serviceAt} ${Utils.formatDate(bookingModel.selectedDate)} - ${bookingModel.selectedTime}",
            'sent_by': userModelGlobal.value?.id ?? "",
            'sent_to': serviceModel.createdBy ?? "",
            'type': NotificationType.booking.name,
            'is_read': false,
          }
        );
        log("In-app notification created successfully");
      } catch (e) {
        log("In-app notification failed: $e");
      }
      
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