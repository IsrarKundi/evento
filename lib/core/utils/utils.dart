import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';

class Utils{

  static Future<void> openWhatsApp(String phoneNumber) async {
    final String url = 'https://wa.me/$phoneNumber';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch WhatsApp';
    }
  }

  static List<String> generateTimeSlots() {
    List<String> timeSlots = [];
    DateTime startTime = DateTime(0, 1, 1, 0, 0); // 12:00 AM
    DateTime endTime = DateTime(0, 1, 1, 23, 0); // 12:00 PM

    while (startTime.isBefore(endTime) || startTime.isAtSameMomentAs(endTime)) {
      final hour = startTime.hour % 12 == 0 ? 12 : startTime.hour % 12;
      final minute = startTime.minute.toString().padLeft(2, '0');
      final period = startTime.hour < 12 ? 'AM' : 'PM';

      timeSlots.add('$hour:$minute $period');
      startTime = startTime.add(const Duration(minutes: 60));
    }

    return timeSlots;
  }


  static Future<List<String>> loadRomanianCitiesFromCSV() async {

    log("loadRomanianCitiesFromCSV called");
    final csvData = await rootBundle.loadString('assets/romaina_cities.csv');
    final lines = csvData.split('\n').map((line) => line.trim()).where((line) => line.isNotEmpty).toList();
    return lines;
  }

  static String convertTo24Hour(String time12Hour) {
    // Clean string and split into parts
    time12Hour = time12Hour.trim();
    final parts = time12Hour.split(' '); // ["12:00", "AM"]

    if (parts.length != 2) return time12Hour; // return original if format invalid

    final timePart = parts[0]; // "12:00"
    final period = parts[1].toUpperCase(); // "AM" or "PM"

    final timeSegments = timePart.split(':'); // ["12", "00"]
    int hour = int.tryParse(timeSegments[0]) ?? 0;
    final minute = timeSegments[1];

    if (period == 'AM') {
      if (hour == 12) hour = 0; // 12 AM → 00
    } else if (period == 'PM') {
      if (hour != 12) hour += 12; // 1–11 PM → 13–23
    }

    final hourStr = hour.toString().padLeft(2, '0');
    return '$hourStr:$minute'; // e.g., "00:00"
  }

  static String formatDateTimeSimple(DateTime? dateTime, BuildContext context) {

    if(dateTime==null){
      return '';
    }


    dateTime = DateTime(dateTime.year,dateTime.month,dateTime.day);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));
    final yesterday = today.subtract(Duration(days: 1));

    // if (dateTime.isAtSameMomentAs(today)) {
    //   return AppLocalizations.of(context)!.today;
    // } else if (dateTime.isAtSameMomentAs(tomorrow)) {
    //   return AppLocalizations.of(context)!.tomorrow;
    // } else if (dateTime.isAtSameMomentAs(yesterday)) {
    //   return AppLocalizations.of(context)!.yesterday;
    // } else {

      return DateFormat('MMM, dd, yyyy').format(dateTime);
    //}
  }

  static String formatDateTime(DateTime? dateTime, BuildContext context) {

    if(dateTime==null){
      return '';
    }


    dateTime = DateTime(dateTime.year,dateTime.month,dateTime.day);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));
    final yesterday = today.subtract(Duration(days: 1));

    if (dateTime.isAtSameMomentAs(today)) {
      return AppLocalizations.of(context)!.today;
    } else if (dateTime.isAtSameMomentAs(tomorrow)) {
      return AppLocalizations.of(context)!.tomorrow;
    } else if (dateTime.isAtSameMomentAs(yesterday)) {
      return AppLocalizations.of(context)!.yesterday;
    } else {

      return DateFormat('MMM, d, yy').format(dateTime);
    }
  }
static DateTime formatDateToYMD(DateTime? dateTime) {
  if (dateTime == null) {
    return DateTime(1900); // or throw error / return null if preferred
  }

  // Normalize to Y-M-D without time
  return DateTime( dateTime.month, dateTime.day,dateTime.year);
}

  static String formatDateAndTime(DateTime? dateTime2, BuildContext context) {

    if(dateTime2==null){
      return '';
    }


    var dateTime = DateTime(dateTime2.year,dateTime2.month,dateTime2.day);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));
    final yesterday = today.subtract(Duration(days: 1));
    String time = formatTime(dateTime2);
    if (dateTime.isAtSameMomentAs(today)) {
      return '${AppLocalizations.of(context)!.today}-$time';
    } else if (dateTime.isAtSameMomentAs(tomorrow)) {
      return '${AppLocalizations.of(context)!.tomorrow}-$time';
    } else if (dateTime.isAtSameMomentAs(yesterday)) {
      return '${AppLocalizations.of(context)!.yesterday}-$time';
    } else {

      return "${DateFormat('d MMM, yy').format(dateTime)}-$time";
    }
  }

  static String formatDate(DateTime date) {
    return DateFormat('M/d/yy').format(date);
  }


  static bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

 static String formatMonth(DateTime date) {
    return DateFormat('MMM').format(date); // Returns "Jan", "Feb", etc.
  }

  static String formatYear(DateTime date) {
    return DateFormat('yyyy').format(date);
  }

  static String formatTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime); // Example: 2:00 PM
  }


  static DateTime combineManual(DateTime date, String timeString) {
    final parts = timeString.split(' ');
    final timeParts = parts[0].split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    final isPM = parts[1].toUpperCase() == 'PM';
    if (isPM && hour != 12) hour += 12;
    if (!isPM && hour == 12) hour = 0;

    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  static DateTime combineDateAndTime(DateTime date, String timeString) {
    // Remove invisible characters and extra spaces
    timeString = timeString.replaceAll(RegExp(r'[\u200B-\u200D\uFEFF\u00A0]'), '').trim();
    log("timeString = ${timeString.codeUnits}");
    // Now safely parse the cleaned time string
    final timeFormat = DateFormat.jm(); // e.g. "10:30 AM"
    final time = timeFormat.parse(timeString);

    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }
}